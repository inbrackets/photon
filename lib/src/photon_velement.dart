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
    this._index = index;
    this.genEl();
    this.setParent(parent);
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
    var listindex = -1;
    InstanceMirror rootComp = component.reflect(root);
    return el.children.map((Element e) {
      listindex++;
      if (childTags.containsKey(e.tagName)) {
        // todo: components in lists
        if (e.attributes.keys.contains("p-props")) {
          print("this is working");

          var props = rootComp.invoke(e.attributes["p-props"], []);
          print(props);
          Component comp = childTags[e.tagName].newInstance("withProps", [props, e.attributes["p-props"]]);
          comp.setParent(this);
          root.componentChildren.add(comp);
          return comp;
        }
        Component comp = childTags[e.tagName].newInstance("", []);
        comp.setParent(this);
        root.componentChildren.add(comp); //todo remove children
        return comp;
      } else {
        if (this._tag == "LIST") {
          return VElement().parseElementTree(root, e, this, childTags, index: listindex);
        } else {
          return VElement().parseElementTree(root, e, this, childTags, index: _index);
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
      (this as Component).render();
    //todo: set props here
      return;
    }
    if (this._tag != el.tagName) {
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
      Map<String, VElement> addItems = {};
      var listindex = -1;
      for (Element e in el.children) {
        listindex++;
        if (addKeys.contains(e.attributes["p-key"])) {
          addItems[e.attributes["p-key"]] = VElement().parseElementTree(root, e, null, this._root.childTags, index: listindex);
        }
      }
      listindex = -1;
      for (VElement e in this._children) {
        listindex++;
        if (deleteKeys.contains(e.attributes["p-key"])) {
          this._children.removeAt(listindex);
        }
      }
      listindex = -1;
      for (Element e in el.children) {
        listindex++;
        if (addKeys.contains(e.attributes["p-key"])) {
          var vEl = addItems[e.attributes["p-key"]];
          this._children.insert(listindex, vEl);
          vEl.setParent(this, index: listindex);
        } else {
          this.children[listindex].patchEl(e);
          this.children[listindex]._index = listindex;
        }
      }
      return;
    }
    if (this._children.length != el.children.length) {
      this._children.forEach((VElement v) => v.destroy());
      this.children = genChildren(this._root, el, this._parent, this._root.childTags);
    }
    for (var i = 0; i < this._children.length; i++) {
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
  int _index = null;

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

  void setParent (VElement parent, {int index}) {
    _parent = parent;
    if (_parent != null) {
      _parent.addChild(_el, index: index);
    }
  }



  void addChild(Element el, {int index}) {
    if (_el.children.contains(el)) {
      return;
    }
    if (index == null) {
      _el.append(el);
    } else {
      _el.children.insert(index, el);
    }
  }

  void genEl() {
    if (_text == "") {
      _el = Element.html("<$_tag />", validator: this.root.validator);
    } else {
      _el = Element.html("<$_tag>$_text</$_tag>", validator: this.root.validator);
    }
    _el.attributes = sanitizeAttributes();
    addListeners();
    // handle text area value attribute
//    if (this._el is TextAreaElement && _attributes.keys.contains("value")) {
//      (this._el as TextAreaElement).value = _attributes["value"];
//    }
    if (_parent != null) {
      _parent.addChild(_el);
    }
  }

  bool checkAttributes(String k) {
    return (!(k.startsWith("on") || k.startsWith("p-"))) || k == "p-value";
  }

  Map<String, String> sanitizeAttributes() {
    Map<String, String> cleanAttributes = {};
    for (String k in _attributes.keys) {
      if (checkAttributes(k)) {
        if (k == "p-value" && this.el is TextInputElement) {
          (this.el as TextInputElement).value = _attributes[k];
        } else if (k == "p-value" && this.el is TextAreaElement) {
          (this.el as TextAreaElement).value = _attributes[k];
        }
        if (k == "p-value") {
          cleanAttributes["value"] = _attributes[k];
        }
        cleanAttributes[k] = _attributes[k];
      }
    }
    return cleanAttributes;
  }

  bool _isListener (String k) {
    return k.startsWith("on") || k == "p-change";
  }
  void addListeners () {
    InstanceMirror comp = component.reflect(_root);
    for (String k in _attributes.keys) {
      createListener(k, comp);
    }
  }

  void createListener (String k, InstanceMirror comp) {
    if (_isListener(k)) {
      if (_listeners[k] != null) {
        _listeners[k].sub.cancel();
        _listeners.remove(k);
      }
      if (k == "p-change") {
        var sub = el.onChange.listen((Event e) {
          if (_index == null) {
            comp.invoke(_attributes[k], [e, this]);
          } else {
            comp.invoke(_attributes[k], [e, this, _index
            ]); //todo: fix this it is a closure, needs to get the new value;
          }
        });
        _listeners["onchange"] = OnXListener(_attributes[k], sub);

        sub = el.onKeyDown.listen((Event e) {
          if (_index == null) {
            comp.invoke(_attributes[k], [e, this]);
          } else {
            comp.invoke(_attributes[k], [e, this, _index
            ]); //todo: fix this it is a closure, needs to get the new value;
          }
        });
        _listeners["onkeydown"] = OnXListener(_attributes[k], sub);

        sub = el.onKeyUp.listen((Event e) {
          if (_index == null) {
            comp.invoke(_attributes[k], [e, this]);
          } else {
            comp.invoke(_attributes[k], [e, this, _index
            ]); //todo: fix this it is a closure, needs to get the new value;
          }
        });
        _listeners["onkeyup"] = OnXListener(_attributes[k], sub);

        sub = el.onCut.listen((Event e) {
          if (_index == null) {
            comp.invoke(_attributes[k], [e, this]);
          } else {
            comp.invoke(_attributes[k], [e, this, _index
            ]); //todo: fix this it is a closure, needs to get the new value;
          }
        });
        _listeners["oncut"] = OnXListener(_attributes[k], sub);

        sub = el.onPaste.listen((Event e) {
          if (_index == null) {
            comp.invoke(_attributes[k], [e, this]);
          } else {
            comp.invoke(_attributes[k], [e, this, _index
            ]); //todo: fix this it is a closure, needs to get the new value;
          }
        });
        _listeners["onpaste"] = OnXListener(_attributes[k], sub);
      } else {
        var sub = _el.on[k.substring(2)].listen((Event e) {
          if (_index == null) {
            comp.invoke(_attributes[k], [e, this]);
          } else {
            comp.invoke(_attributes[k], [e, this, _index
            ]); //todo: fix this it is a closure, needs to get the new value;
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
            if (k == "p-value" && this.el is TextInputElement) {
              (this.el as TextInputElement).value = _attributes[k];
            } else if (k == "p-value" && this.el is TextAreaElement) {
              (this.el as TextAreaElement).value = _attributes[k];
            }
            if (k == "p-value") {
              elAttributes["value"] = _attributes[k];
            }
            elAttributes[k] = _attributes[k];
          } else {
            createListener(k, comp);
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

  void destroy({bool parentMounted = true}) {
    beforeDestroy();
    _cancelListeners();
    this._parent?.el?.children?.remove(this.el);
    this.children.forEach((VElement v) => v.destroy(parentMounted: false)); //todo this is removing child even when parent is unmounted - set mounted flag
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