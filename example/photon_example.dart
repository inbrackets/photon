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
  void bob() {
    print("Printing bob");
  }
  @override
  get template {
    return '''
      <div class="bob" pro-onclick="bob">
      I am bob
      </div>
    ''';
  }
}

main() {
  Logger().display = true;
  initializeReflectable();
  Sam sam = Sam();
  sam.test = "bob";

  print(sam.el);

  sam.el.attributes = {"class": "bob john"};
  mount(querySelector("#output"), sam);
  sam.test = "fuck you";
  sam.render();
  print(sam.el.children);

}
