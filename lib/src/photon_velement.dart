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

  void patchEl(Element el) {
    this._attributes = el.attributes;
    this._text = el.children.length == 0 && el.text != "" ? el.text : "";
    this._tag = el.tagName;
  }

  Map<String, String> _attributes = {};
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

  get el {
    return _el;
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

  Map<String, String> sanitizeAttributes() {
    Map<String, String> cleanAttributes = {};
    for (String k in _attributes.keys) {
      if (!(k.startsWith("on") || k.startsWith("pro-"))) {
        cleanAttributes[k] = _attributes[k];
      }
    }
    return cleanAttributes;
  }

  void addListeners () {
    InstanceMirror comp = component.reflect(_root);
    for (String k in _attributes.keys) {
      if (k.startsWith("on")) {
        _el.on[k.substring(2)].listen((Event e) {
          comp.invoke(_attributes[k], [e]);
        });
      }
    }
  }
}
