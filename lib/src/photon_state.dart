import 'dart:async';
import 'dart:core';
import 'dart:html';

import 'dart:math';

abstract class State<T> {
  Element el;
  T _value;
  T get value;
  set value(T val);
  StreamSubscription subscribeType(String type, EventListener f);
  StreamSubscription subscribe(EventListener f);
  void update();
  void trigger(String type);
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
    trigger(type);
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

  @override
  void update() {
    el.dispatchEvent(CustomEvent(valueChange));
  }

  @override
  void trigger(String type) {
    el.dispatchEvent(CustomEvent(type));
  }

}

// todo: check null values for optional

class StateList<T> extends StateValue<List<T>> implements List<T> {
  StateList (List<T> val) : super(val);

  @override
  void add (T val) {
    this._value.add(val);
    update();
  }

  @override
  T get first {
   return _value.first;
  }

  @override
  set first(T value) {
    _value.first = value;
  }

  @override
  T get last {
    return _value.last;
  }

  @override
  set last(T value) {
    _value.last = value;
  }

  @override
  int get length {
    return _value.length;
  }

  @override
  set length(int newLength) {
    _value.length = newLength;
  }

  @override
  List<T> operator +(List<T> other) {
    return _value + other;
  }

  @override
  T operator [](int index) {
    return _value[index];
  }

  @override
  void operator []=(int index, T value) {
    _value[index] = value;
    update();
  }

  @override
  void addAll(Iterable<T> iterable) {
    _value.addAll(iterable);
    update();
  }

  @override
  bool any(bool Function(T element) test) {
    return _value.any(test);
  }

  @override
  Map<int, T> asMap() {
    return _value.asMap();
  }

  @override
  List<R> cast<R>() {
    return _value.cast<R>();
  }

  @override
  void clear() {
    _value.clear();
    update();
  }

  @override
  bool contains(Object element) {
    return _value.contains(element);
  }

  @override
  T elementAt(int index) {
    return _value.elementAt(index);
  }

  @override
  bool every(bool Function(T element) test) {
    return _value.every(test);
  }

  @override
  Iterable<R> expand<R>(Iterable<R> Function(T element) f) {
    return _value.expand<R>(f);
  }

  @override
  void fillRange(int start, int end, [T fillValue]) {
    _value.fillRange(start, end, fillValue);
    update();
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) {
    return _value.firstWhere(test, orElse: orElse);
  }

  @override
  R fold<R>(R initialValue, R Function(R previousValue, T element) combine) { //todo dunno if this is right
    return _value.fold<R>(initialValue, combine);
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    return _value.followedBy(other);
  }

  @override
  void forEach(void Function(T element) f) {
    _value.forEach(f);
  }

  @override
  Iterable<T> getRange(int start, int end) {
    return _value.getRange(start, end);
  }

  @override
  int indexOf(T element, [int start = 0]) {
    return _value.indexOf(element, start);
  }

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    return _value.indexWhere(test, start);
  }

  @override
  void insert(int index, T element) {
    _value.insert(index, element);
    update();
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    _value.insertAll(index, iterable);
    update();
  }

  @override
  bool get isEmpty => _value.isEmpty;

  @override
  bool get isNotEmpty => _value.isNotEmpty;

  @override
  Iterator<T> get iterator => _value.iterator;

  @override
  String join([String separator = ""]) {
    return _value.join(separator);
  }

  @override
  int lastIndexOf(T element, [int start]) {
    return _value.lastIndexOf(element, start);
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    return _value.lastIndexWhere(test, start);
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) {
    return _value.lastWhere(test, orElse: orElse);
  }

  @override
  Iterable<R> map<R>(R Function(T e) f) {
    return _value.map<R>(f);
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    return _value.reduce(combine);
  }

  @override
  bool remove(Object value) {
    var rem = _value.remove(value);
    update();
    return rem;
  }

  @override
  T removeAt(int index) {
    var rem = _value.removeAt(index);
    update();
    return rem;
  }

  @override
  T removeLast() {
    var rem = _value.removeLast();
    update();
    return rem;
  }

  @override
  void removeRange(int start, int end) {
    _value.removeRange(start, end);
    update();
  }

  @override
  void removeWhere(bool Function(T element) test) {
    _value.removeWhere(test);
    update();

  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    _value.replaceRange(start, end, replacement);
    update();
  }

  @override
  void retainWhere(bool Function(T element) test) {
    _value.retainWhere(test);
    update();
  }

  // TODO: implement reversed
  @override
  Iterable<T> get reversed => _value.reversed; //todo handle rerender here

  @override
  void setAll(int index, Iterable<T> iterable) {
    _value.setAll(index, iterable);
    update();
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    _value.setRange(start, end, iterable, skipCount);
    update();
  }

  @override
  void shuffle([Random random]) {
    _value.shuffle(random);
    update();
  }

 @override
  T get single => _value.single;

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) {
    return _value.singleWhere(test, orElse: orElse);
  }

  @override
  Iterable<T> skip(int count) {
    return _value.skip(count);
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    return _value.skipWhile(test);
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    if (compare == null) {
      _value.sort();
    } else {
      _value.sort(compare);
    }
    update();
  }

  @override
  List<T> sublist(int start, [int end]) {
    return _value.sublist(start, end);
  }

  @override
  Iterable<T> take(int count) {
    return _value.take(count);
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    return _value.takeWhile(test);
  }

  @override
  List<T> toList({bool growable: true}) {
    return _value.toList(growable: growable);
  }

  @override
  Set<T> toSet() {
    return _value.toSet();
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    return _value.where(test);
  }

  @override
  Iterable<R> whereType<R>() {
    return _value.whereType<R>();
  }


}