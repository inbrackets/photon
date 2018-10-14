import 'dart:async';
import 'dart:html';

import 'package:photon/photon.dart';
import 'package:reflectable/mirrors.dart';

@component
class VElement {
  VElement parseElementTree(Component root, Element el, VElement parent, Map<String, ClassMirror> childTags, {int index}) {
    this._attributes = el.attributes;
    this._tag = el.tagName;
    this._text = el.children.length == 0 && el.text != "" ? el.text : "";
    this._root = root;
    if (index == null) {
      this.genEl();
    } else {
      this.genEl(index: index);
    }
    this.parent = parent;
    this.children = genChildren(root, el, parent, childTags);
    return this;
  }

  List<VElement> genChildren (Component root, Element el, VElement parent, Map<String, ClassMirror> childTags) {
    if (this._tag == "LIST") {
      // check that all children have key prop
      if (el.children.where((Element e) => e.attributes["p-key"] == null).length != 0) {
        throw "All children of a list should have a p-key attribute";
      }
    }
    var index = -1;
    return el.children.map((Element e) {
      index++;
      if (childTags.containsKey(e.tagName)) {
        Component comp = childTags[e.tagName].newInstance("", []);
        comp.parent = this;
        return comp;
      } else {
        if (this._tag == "LIST") {
          return VElement().parseElementTree(root, e, this, childTags, index: index);
        } else {
          return VElement().parseElementTree(root, e, this, childTags);
        }
      }
    }).toList();
  }

  Map<String, String> get attributes => _attributes;

  set attributes(Map<String, String> value) {
    _diffPatchAttributes(value);
  }

  String get text => _text;

  set text(String value) {
    if (_text == value) {
      return;
    }
    _text = value;
    this.el.text = _text;
  }

  void patchEl(Element el) {
    if (this is Component && this._tag != el.tagName) {
//      print("Hello from here");
      (this as Component).render();
    //todo: set props here
      return;
    }
    if (this._tag != el.tagName) {
      print("${this._tag}, ${el.tagName}, ${this is Component}");
      this.parseElementTree(this._root, el, this._parent, this._root.childTags);
      return;
    }
    this.attributes = el.attributes;
    this.text = el.children.length == 0 && el.text != "" ? el.text : "";
    if (this._tag == "LIST") {
      var existingKeys = this._children.map((VElement e) => e.attributes["p-key"]).toSet();
      var newKeys = el.children.map((Element e) => e.attributes["p-key"]).toSet();
      var keepKeys = existingKeys.intersection(newKeys);
      var deleteKeys = existingKeys.difference(keepKeys);
      var addKeys = newKeys.difference(keepKeys);
      return;
    }
    if (this._children.length != el.children.length) {
      this._children.forEach((VElement v) => v._destroy());
      this.children = genChildren(this._root, el, this._parent, this._root.childTags);
    }
    for (var i = 0; i < this._children.length; i++) {
      print("this is working");
      this._children[i].patchEl(el.children[i]);
    }
  }

  Map<String, String> _attributes = {};
  Map<String, OnXListener> _listeners = {};
  VElement _parent = null;
  String _tag = "";
  String _text = "";
  Element _el;
  Component _root;

  Component get root => _root;

  set root(Component value) {
    _root = value;
  }

  List<VElement> _children = null;

  List<VElement> get children => _children;

  set children(List<VElement> value) {
    _children = value;
  }

  VElement _vel = null;

  set parent (VElement parent) {
    _parent = parent;
    if (_parent != null) {
      _parent.addChild(_el);
    }
  }



  void addChild(Element el) {
    if (_el.children.contains(el)) {
      return;
    }
    //print(el);
    _el.append(el);
  }

  void genEl({int index}) {
    if (_text == "") {
      _el = Element.html("<$_tag />", validator: this.root.validator);
    } else {
      _el = Element.html("<$_tag>$_text</$_tag>", validator: this.root.validator);
    }
    _el.attributes = sanitizeAttributes();
    if (index == null) {
      addListeners();
    } else {
      addListeners(index: index);
    }
    if (_parent != null) {
      _parent.addChild(_el);
    }
  }

  bool checkAttributes(String k) {
    return !(k.startsWith("on") || k.startsWith("p-"));
  }

  Map<String, String> sanitizeAttributes() {
    Map<String, String> cleanAttributes = {};
    for (String k in _attributes.keys) {
      if (checkAttributes(k)) {
        cleanAttributes[k] = _attributes[k];
      }
    }
    return cleanAttributes;
  }

  bool _isListener (String k) {
    return k.startsWith("on");
  }

  void addListeners ({int index}) {
    InstanceMirror comp = component.reflect(_root);
    for (String k in _attributes.keys) {
      if (_isListener(k)) {
        var sub = _el.on[k.substring(2)].listen((Event e) {
          if (index == null) {
            comp.invoke(_attributes[k], [e]);
          } else {
            comp.invoke(_attributes[k], [e, index]);
          }
        });
        _listeners[k] = OnXListener(_attributes[k], sub);
      }
    }
  }

  void _diffPatchAttributes (Map<String, String> newAtt) {
    var attKeyset = _attributes.keys.toSet();
    var newAttKeySet = newAtt.keys.toSet();
    var intersection = attKeyset.intersection(newAttKeySet);
    var elAttributes = _el.attributes;
    InstanceMirror comp = component.reflect(_root);
    for (String k in _attributes.keys) {
      if (intersection.contains(k)) {
        if (_attributes[k] != newAtt[k]) {
          _attributes[k] = newAtt[k];
          if (checkAttributes(k)) {
            elAttributes[k] = _attributes[k];
          } else if (_isListener(k)) {
            if (_listeners[k] != null) {
              _listeners[k].sub.cancel();
              _listeners.remove(k);
            }
            var sub = _el.on[k.substring(2)].listen((Event e) {
              comp.invoke(_attributes[k], [e]);
            });
            _listeners[k] = OnXListener(_attributes[k], sub);
          }
        }
      } else {
        _attributes.remove(k);
        if (checkAttributes(k)) {
          elAttributes.remove(k);
        } else if (_isListener(k)) {
          _listeners[k].sub.cancel();
          _listeners.remove(k);
        }
      }
    }

  }


  void _cancelListeners () {
    for (String k in _listeners.keys) {
      _listeners[k].sub.cancel();
    }
    _listeners = {};
  }


  Element get el => _el;

  set el(Element value) {
    _el = value;
  }

  void _destroy() {
    beforeDestroy();
    _cancelListeners();
    this.children.forEach((VElement v) => v._destroy());
    afterDestroy();
  }
  void beforeDestroy() {
  }
  void afterDestroy() {
  }
}

class OnXListener {
  String _name = "";
  StreamSubscription _sub = null;

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  StreamSubscription get sub => _sub;
  set sub(StreamSubscription value) {
    _sub = value;
  }
  OnXListener(this._name, this._sub);
}