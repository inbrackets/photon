import 'dart:async';
import 'dart:html';
import 'package:photon/photon.dart';
import 'package:photon/src/photon_logger.dart';
import 'package:photon/src/proton_nodevalidator.dart';
import 'package:reflectable/reflectable.dart';
import 'package:photon/src/photon_reflector.dart';

@component
class Component<P extends Props> extends VElement {
  final List<Type> childComponents;
  List<Component> componentChildren = []; //children for rerendering
  Map<String, ClassMirror> _childTags = {};
  Map<String, ClassMirror> get childTags => _childTags;
  List<StreamSubscription> _componentListeners = [];
  String propsMethod = null;
  P props;

  set childTags(Map<String, ClassMirror> value) {
    _childTags = value;
  }

  TrustedNodeValidator validator;
  static get name => "Component";
  String _previousTemplate = "";

  Component() : this.withProps(null, null);

  Component.withProps(this.props, this.propsMethod) : super() {
    _createValidator();
    this.render();
    _subscribeToState();
  }

  get template {
    return '<div>This is a Component</div>';
  }

  void _createValidator() {
    validator = TrustedNodeValidator();
    //_validator..allowCustomElement("null");
    for (Type c in childComponents) {
      ClassMirror C = component.reflectType(c);
      String name = C.invokeGetter("name");
      print(name);
      name = name.toUpperCase();
      if (childTags[name] != null) {
        throw "Tag collision, tag '$name' appears twice in components in this.childComponents";
      }
      childTags[name] = C;
      validator
        ..allowCustomElement(name,
            attributes: ['df-tag', 'df-props', 'df-style']);
    }
  }

  void render() {
    if (_previousTemplate == template) {
      Logger().log(logKeys.General,
          "Skipping render - template has not changed - todo: rerender children");
      InstanceMirror thisComp = component.reflect(this);
      for (Component c in componentChildren) {
        if (c.propsMethod != null) {
          var newProps = thisComp.invoke(c.propsMethod, []);
          c.props = newProps;
        }
        c.render();
      }
      return;
    }
    // previous template allows for a quick string comparison to avoid tree parsing if nothing has changed
    Logger().log(logKeys.General, "Template changed - patching dom");
    _previousTemplate = template;
    if (el == null) {
      parseElementTree(
          this, Element.html(template, validator: validator), null, childTags);
    } else {
      beforeUpdate();
      this.patchEl(Element.html(template, validator: validator));
      afterUpdate();
    }
  }

  void rerender() {
    if (_previousTemplate == template) {
      Logger().log(logKeys.General,
          "Skipping rerender - template has not changed - todo: rerender children");
      return;
    }
    Logger().log(logKeys.General, "Template changed - patching dom");
    Element newEl = Element.html(this.template, validator: validator);
  }

  void _subscribeToState () {
    InstanceMirror comp = component.reflect(this);
    ClassMirror C = comp.type;
    for (String k in C.instanceMembers.keys){
      try {
        if (k.endsWith("=")) {
          continue;
        } else if ("${C.instanceMembers[k].reflectedReturnType}".startsWith("State")) {
          State s = comp.invokeGetter(k);
          _componentListeners.add(s.subscribe(this._subscribeAndRender));
        }
      } catch (e) {
        continue;
    }
    }
  }

  void _subscribeAndRender(Event e) {
    this.render();
  }

  void beforeUpdate() {
    Logger().log(logKeys.Update, "beforeUpdate $name");
  }
  void afterUpdate() {
    Logger().log(logKeys.Update, "afterUpdate $name");
  }
  @override
  void destroy({bool parentMounted = true}) {
    for (StreamSubscription s in _componentListeners) {
      s.cancel();
    }
    super.destroy(parentMounted: parentMounted);
  }
  @override
  void beforeDestroy() {
    Logger().log(logKeys.Destroy, "beforeDestroy $name");
  }
  @override
  void afterDestroy() {
    Logger().log(logKeys.Destroy, "afterDestroy $name");
  }
}
