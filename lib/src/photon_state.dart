import 'dart:async';
import 'dart:html';

abstract class State<T> {
  Element el;
  T _value;
  T get value;
  set value(T val);
  StreamSubscription subscribeType(String type, EventListener f);
  StreamSubscription subscribe(EventListener f);
}

class StateValue<T> implements State<T> {
  Element el = Element.div();
  T _value;

  String valueSet = 'SET';
  String valueChange = 'CHANGE';

  T get value => _value;

  set value(T value) {
    var type = valueChange;
    if (_value == null) {
      type = valueSet;
    }
    _value = value;
    el.dispatchEvent(CustomEvent(type, detail: value));
  }
  StreamSubscription subscribeType(String type, EventListener f) {
    return el.on[type].listen(f);
  }
  StreamSubscription subscribe(EventListener f) {
    return subscribeType(valueChange, f);
  }

  StateValue (T val) {
    this.value = val;
  }

}