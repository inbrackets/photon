import 'dart:html';

import 'package:photon/photon.dart';

import 'photon_example.reflectable.dart';


@component
class Sam extends Component {
  @override
  final List<Type> childComponents = [Bob];
  @override
  static String name = "sam";
  static bob () => "john";
  String test = "samuel";
  @override
  get template {
    return '''
      <div class="bob">
        <bob df-tag="bob1">hello im $test</bob>
        <span>$test</span>
      </div>
    ''';
  }
}

class Singleton {
  static final Singleton _singleton = new Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
  StateValue<String> color = StateValue("red");
}

@component
class Bob extends Component {
  @override
  List<Type> childComponents = [Sub];
  @override
  static get name => "bob";
  void toggleColour(Event e, VElement v) {
    print("turning blue");
    this.color.value = this.color.value == "blue" ? "red" : "blue";
    //this.render();
  }
  void red(Event e, VElement v) {
    print("turning red");
    this.color.value = "red";
    this.method = "blue";

    //this.render();
  }
  String method = "blue";
  StateValue<String> input = StateValue("hello");
  StateValue<String> color = Singleton().color;
  void listPrint(Event e, VElement v, int i) {
    print("Clicked list item $i");
  }

  void listPrintSub(Event e, VElement v, int i) {
    e.stopPropagation();
    print("Clicked list item sub $i");
  }
  StateValue<bool> display = StateValue<bool>(false);

  StateList<int> items = StateList<int>([1, 2,3, 4]);
  void toggleDisplay(Event e, VElement v) {
    display.value = !display.value;
  }

  void addItem(Event e, VElement v) {
    var key = items.value.length + 1;
    items.add(key);
  }

  void changeInput(Event e, VElement v) {
    print((v.el as TextInputElement).value);
    input((v.el as TextInputElement).value);
  }

  void changeInput2(Event e, VElement v) {
    input((v.el as TextAreaElement).value);
    (v.el as TextAreaElement).focus();
  }

  void changeInput3(Event e, VElement v) {
    input((v.el as DivElement).text);
  }

  void addItem2(Event e, VElement v) {
    var key = items.value.length + 1;
    items.value.insert(2, key);
    //items.value = items.value;
    items.update();
  }

  void reorder(Event e, VElement v) {
    items.value = items.value.reversed.toList();
  }
  @override
  get template {
    return '''
      <div class="bob2">
        <div class="1" onclick="toggleColour">Test 1</div>
        <div class="1" style="color: ${color.value}">Test 2</div>
        <div class="1">Test 3</div>
        <div class="1">Test 4</div>
        <!--<list>
        ${["<div p-key='1' onclick='listPrint'><span>1</span> <span onclick='listPrintSub'>1</span></div>", "<div p-key='2' onclick='listPrint'>2</div>", "<div p-key='3' onclick='listPrint'>3</div>"]}
        </list> -->
        <list>
        ${items.value.map((int i) => '<div p-key="$i" onclick="listPrint">$i</div>').toList()}
        </list>
        <!--<div>
        ${items.value.map((int i) => '<div p-key="$i" onclick="listPrint">$i</div>').toList()}
        </div>-->
        <button onclick="addItem">add Item</button>
        <button onclick="addItem2">add Item @2</button>
        <button onclick="reorder">reorder</button>
        <button onclick="toggleDisplay">toggle display</button>
        ${display.value ? '<div>display 1</div>': '<div>display 2</div>'}
        ${display.value ? NullString : '<div>showing hidden display</div>'}
        <subComp></subComp>
        <null></null>
        <div>${input}</div>
        <input type="text" p-value="${input}" p-change="changeInput" />
        <textarea  p-value="${input}" p-change="changeInput2"></textarea>
        <div contenteditable="true" p-change="changeInput3">${input}</div>
        <div>Hello</div>
      </div>
    ''';
  }
}

@component
class Sub extends Component {
  @override
  final List<Type> childComponents = [];
  @override
  static String name = "subcomp";
  static bob () => "john";
  String test = "samuel";
  StateValue<String> color = Singleton().color;
  @override
  get template {
    return '''
      <div class="bob">
        <div class="1" style="color: ${color.value}">Sub color</div>
      </div>
    ''';
  }
}

main() {
  Logger().display = true;
  initializeReflectable();
  Sam sam = Sam();
//  sam.test = "bob";
//
//  print(sam.el);
//
//  sam.el.attributes = {"class": "bob john"};
  mount(querySelector("#output"), sam);
//  sam.test = "fuck you";
//  sam.render();
//  print(sam.el.children);

  //Bob bob = Bob();
  //print(bob);

  //print(sam.el.innerHtml);
  //mount(querySelector("#output"), bob);

}
