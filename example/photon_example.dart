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

@component
class Bob extends Component {
  @override
  List<Type> childComponents = [];
  @override
  static String name = "bob";
  void bob(Event e) {
    print("Printing bob");
  }
  @override
  get template {
    return '''
      <div class="bob2">
        <div class="1" onclick="bob">Test 1</div>
        <div class="1">Test 2</div>
        <div class="1">Test 3</div>
        <div class="1">Test 4</div>
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
