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
  void toggleColour(Event e) {
    print("turning blue");
    this.color.value = this.color.value == "blue" ? "red" : "blue";
    //this.render();
  }
  void red(Event e) {
    print("turning red");
    this.color.value = "red";
    this.method = "blue";

    //this.render();
  }
  String method = "blue";
  StateValue<String> color = Singleton().color;
  void listPrint(Event e, int i) {
    print("Clicked list item $i");
  }
  StateValue<bool> display = StateValue<bool>(false);

  StateList<int> items = StateList<int>([1, 2,3, 4]);
  void toggleDisplay(Event e) {
    display.value = !display.value;
  }
  @override
  get template {
    return '''
      <div class="bob2">
        <div class="1" onclick="toggleColour">Test 1</div>
        <div class="1" style="color: ${color.value}">Test 2</div>
        <div class="1">Test 3</div>
        <div class="1">Test 4</div>
        <list>
        ${["<div p-key='1' onclick='listPrint'>1</div>", "<div p-key='2' onclick='listPrint'>2</div>", "<div p-key='3' onclick='listPrint'>3</div>"]}
        </list>
        <list>
        ${items.value.map((int i) => '<div p-key="$i" onclick="listPrint">$i</div>')}
        </list>
        <button onclick="toggleDisplay">toggle display</button>
        ${display.value ? '<div>display 1</div>': '<div>display 2</div>'}
        ${display.value ? NullString : '<div>showing hidden display</div>'}
        <subComp/>
        <null/>
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
