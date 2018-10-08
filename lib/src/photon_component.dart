import 'dart:html';
import 'package:photon/src/photon_logger.dart';
import 'package:photon/src/proton_nodevalidator.dart';
import 'package:reflectable/reflectable.dart';
import 'package:photon/src/photon_reflector.dart';

@component
class Component {
  final List<Type> childComponents;
  Map<String, ClassMirror> _childTags = {};
  TrustedNodeValidator _validator;
  static String name = "Component";
  Element _el;
  String _previousTemplate = "";
  Map<String, Component> _children = {};

  Element get el {
    return _el;
  }

  Component() : super(){
    _createValidator();
    this.render();
  }

  get template {
    return '<div>This is a Component</div>';
  }

  void _createValidator() {
    _validator = TrustedNodeValidator();
    //_validator..allowCustomElement("null");
    for (Type c in childComponents) {
      ClassMirror C = component.reflectType(c);
      String name = C.invokeGetter("name");
      name = name.toUpperCase();
      if (_childTags[name] != null) {
        throw "Tag collision, tag '$name' appears twice in components in this.childComponents";
      }
      _childTags[name] = C;
      _validator
        ..allowCustomElement(name,
            attributes: ['df-tag', 'df-props', 'df-style']);
    }
  }

  void render() {
    if (_previousTemplate == template) {
      Logger().log(logKeys.General,
          "Skipping render - template has not changed - todo: rerender children");
      return;
    }
    // previous template allows for a quick string comparison to avoid tree parsing if nothing has changed
    Logger().log(logKeys.General, "Template changed - patching dom");
    _previousTemplate = template;
    if (_el == null) {
      print("this");

      _el = Element.html(template, validator: _validator); //todo: fix first render to only mount children
    }
    Element newEl = Element.html(this.template, validator: _validator);
    _patch(_el, newEl, "0");
  }

  void _patch(Element target, Element source, String positionKey) {
    if (_childTags[source.tagName] != null) { //special tags must be handled seperately by the object itself
      Logger().log(logKeys.General, "Found class element - attending to this");
      if (_children[positionKey] == null) {
        _children[positionKey] = _childTags[source.tagName].newInstance("", []);
        target.replaceWith(_children[positionKey].el);
      }
      //todo: do this
      return;
    }
    if (target.tagName != source.tagName) {
      // tag has changed replace everything
      target.replaceWith(source);
      return;
    }
    target.attributes = source.attributes; //blindly set attributes todo: check for map equality

    if (target.children.length == 0 && source.children.length == 0 && target.text != source.text) {
      target.text = source.text;
    }
    if (target.children.length != source.children.length) {
      throw "Target children and source children are not the same length - remember to return <null /> instead of null for programatic elements or use a ListComponent for lists";
    }
    for (int i = 0; i < target.children.length; i++) {
      _patch(target.children[i], source.children[i], "$positionKey.$i");
    }
  }

  void rerender() {
    if (_previousTemplate == template) {
      Logger().log(logKeys.General,
          "Skipping rerender - template has not changed - todo: rerender children");
      return;
    }
    Logger().log(logKeys.General, "Template changed - patching dom");
    Element newEl = Element.html(this.template, validator: _validator);
  }
}
