import 'dart:async';
import 'dart:html';

import 'package:photon/photon.dart';
import 'package:reflectable/mirrors.dart';

@component
class VElement {
  VElement parseElementTree(Component root, Element el, VElement parent, Map<String, ClassMirror> childTags) {
    this._attributes = el.attributes;
    this._tag = el.tagName;
    this._text = el.children.length == 0 && el.text != "" ? el.text : "";
    this._root = root;
    this.genEl();
    this.parent = parent;
    this.children = el.children.map((Element e) {
      if (childTags.containsKey(e.tagName)) {
        Component comp = childTags[e.tagName].newInstance("", []);
        comp.parent = this;
        return comp;
      } else {
        return VElement().parseElementTree(root, e, this, childTags);
      }
    }).toList();
    return this;
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
    if (this._tag != el.tagName) {
      this.parseElementTree(this._root, el, this._parent, this._root.childTags);
      return;
    }
    this.attributes = el.attributes;
    this.text = el.children.length == 0 && el.text != "" ? el.text : "";
  }

  Map<String, String> _attributes = {};
  Map<String, OnXListener> _listeners = {};
  VElement _parent = null;
  String _tag = "";
  String _text = "";
  Element _el;
  Component _root;
  List<VElement> _children = null;
  VElement _vel = null;

  set children (List<VElement> children) {
    _children = children;
  }

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

  /*VElement(
      {Map<String, String> attributes = const {},
      VElement parent = null,
      String tag = "",
      Component component = null,
      String text = "",
      List<VElement> children = const []}) {
    _attributes = attributes;
    _parent = parent;
    _tag = tag;
    _component = component;
    _text = text;
    _children = children;
    this.genEl();
  }*/

  void genEl() {
    if (_text == "") {
      _el = Element.html("<$_tag />");
    } else {
      _el = Element.html("<$_tag>$_text</$_tag>");
    }
    _el.attributes = sanitizeAttributes();
    addListeners();
    if (_parent != null) {
      print(_el.children);
      _parent.addChild(_el);
    }
  }

  bool checkAttributes(String k) {
    return !(k.startsWith("on") || k.startsWith("pro-"));
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

  void addListeners () {
    InstanceMirror comp = component.reflect(_root);
    for (String k in _attributes.keys) {
      if (k.startsWith("on")) {
        var sub = _el.on[k.substring(2)].listen((Event e) {
          comp.invoke(_attributes[k], [e]);
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
    for (String k in _attributes.keys) {
      if (intersection.contains(k)) {
        if (_attributes[k] != newAtt[k]) {
          _attributes[k] = newAtt[k];
          if (checkAttributes(k)) {
            elAttributes[k] = _attributes[k];
          }
        }
      } else {
        _attributes.remove(k);
        if (checkAttributes(k)) {
          elAttributes.remove(k);
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