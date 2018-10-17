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
     //todo make this a function so it can be called from outside
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

class StateList<T> extends StateValue<List<T>>  {
  StateList (List<T> val) : super(val);
  void add (T val) {
    this._value.add(val);
    update();
  }

  @override
  T first;

  @override
  T last;

  @override
  int get length {
    return _value.length;
  }

  @override
  List<T> operator +(List<T> other) {
    // TODO: implement +
  }

  @override
  T operator [](int index) {
    // TODO: implement []
  }

  @override
  void operator []=(int index, T value) {
    // TODO: implement []=
  }

  @override
  void addAll(Iterable<T> iterable) {
    // TODO: implement addAll
  }

  @override
  bool any(bool Function(T element) test) {
    // TODO: implement any
  }

  @override
  Map<int, T> asMap() {
    // TODO: implement asMap
  }

  @override
  List<R> cast<R>() {
    // TODO: implement cast
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  bool contains(Object element) {
    // TODO: implement contains
  }

  @override
  T elementAt(int index) {
    // TODO: implement elementAt
  }

  @override
  bool every(bool Function(T element) test) {
    // TODO: implement every
  }

  @override
  Iterable<T> expand<T>(Iterable<T> Function(T element) f) {
    // TODO: implement expand
  }

  @override
  void fillRange(int start, int end, [T fillValue]) {
    // TODO: implement fillRange
  }

  @override
  T firstWhere(bool Function(T element) test, {T Function() orElse}) {
    // TODO: implement firstWhere
  }

  @override
  T fold<T>(T initialValue, T Function(T previousValue, T element) combine) {
    // TODO: implement fold
  }

  @override
  Iterable<T> followedBy(Iterable<T> other) {
    // TODO: implement followedBy
  }

  @override
  void forEach(void Function(T element) f) {
    // TODO: implement forEach
  }

  @override
  Iterable<T> getRange(int start, int end) {
    // TODO: implement getRange
  }

  @override
  int indexOf(T element, [int start = 0]) {
    // TODO: implement indexOf
  }

  @override
  int indexWhere(bool Function(T element) test, [int start = 0]) {
    // TODO: implement indexWhere
  }

  @override
  void insert(int index, T element) {
    // TODO: implement insert
  }

  @override
  void insertAll(int index, Iterable<T> iterable) {
    // TODO: implement insertAll
  }

  // TODO: implement isEmpty
  @override
  bool get isEmpty => null;

  // TODO: implement isNotEmpty
  @override
  bool get isNotEmpty => null;

  // TODO: implement iterator
  @override
  Iterator<T> get iterator => null;

  @override
  String join([String separator = ""]) {
    // TODO: implement join
  }

  @override
  int lastIndexOf(T element, [int start]) {
    // TODO: implement lastIndexOf
  }

  @override
  int lastIndexWhere(bool Function(T element) test, [int start]) {
    // TODO: implement lastIndexWhere
  }

  @override
  T lastWhere(bool Function(T element) test, {T Function() orElse}) {
    // TODO: implement lastWhere
  }

  @override
  Iterable<T> map<T>(T Function(T e) f) {
    // TODO: implement map
  }

  @override
  T reduce(T Function(T value, T element) combine) {
    // TODO: implement reduce
  }

  @override
  bool remove(Object value) {
    // TODO: implement remove
  }

  @override
  T removeAt(int index) {
    // TODO: implement removeAt
  }

  @override
  T removeLast() {
    // TODO: implement removeLast
  }

  @override
  void removeRange(int start, int end) {
    // TODO: implement removeRange
  }

  @override
  void removeWhere(bool Function(T element) test) {
    // TODO: implement removeWhere
  }

  @override
  void replaceRange(int start, int end, Iterable<T> replacement) {
    // TODO: implement replaceRange
  }

  @override
  void retainWhere(bool Function(T element) test) {
    // TODO: implement retainWhere
  }

  // TODO: implement reversed
  @override
  Iterable<T> get reversed => null;

  @override
  void setAll(int index, Iterable<T> iterable) {
    // TODO: implement setAll
  }

  @override
  void setRange(int start, int end, Iterable<T> iterable, [int skipCount = 0]) {
    // TODO: implement setRange
  }

  @override
  void shuffle([Random random]) {
    // TODO: implement shuffle
  }

  // TODO: implement single
  @override
  T get single => null;

  @override
  T singleWhere(bool Function(T element) test, {T Function() orElse}) {
    // TODO: implement singleWhere
  }

  @override
  Iterable<T> skip(int count) {
    // TODO: implement skip
  }

  @override
  Iterable<T> skipWhile(bool Function(T value) test) {
    // TODO: implement skipWhile
  }

  @override
  void sort([int Function(T a, T b) compare]) {
    // TODO: implement sort
  }

  @override
  List<T> sublist(int start, [int end]) {
    // TODO: implement sublist
  }

  @override
  Iterable<T> take(int count) {
    // TODO: implement take
  }

  @override
  Iterable<T> takeWhile(bool Function(T value) test) {
    // TODO: implement takeWhile
  }

  @override
  List<T> toList({bool growable: true}) {
    // TODO: implement toList
  }

  @override
  Set<T> toSet() {
    // TODO: implement toSet
  }

  @override
  Iterable<T> where(bool Function(T element) test) {
    // TODO: implement where
  }

  @override
  Iterable<T> whereType<T>() {
    // TODO: implement whereType
  }
}