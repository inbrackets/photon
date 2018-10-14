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
    el.dispatchEvent(CustomEvent(type, detail: value)); //todo make this a function so it can be called from outside
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

class StateList<T> extends StateValue<List<T>> {
  StateList (List<T> val) : super(val);
  void add (T val) {
    this._value.add(val);
    el.dispatchEvent(CustomEvent(valueChange, detail: value));
  }
}