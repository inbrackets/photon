import 'dart:async';
import 'dart:html';

import 'package:photon/photon.dart';

@component
class C extends Component {
  // Tag name for mounting in parent components
  @override
  static String tagName = "Component";
  // internal state tracking a single object
  StateValue<String> time = StateValue("00:00:00");
  StateValue<String> name = StateValue("World");

  Timer t;

  void changeName(Event e, VElement v) {
    name((v.el as TextInputElement).value);
  }

  void resetName(Event e, VElement v) {
    name("World");
  }

  get template {
    return '''
      <div>
        <div>Hello ${name}!</div>
        <div>The time is: ${time()}</div>
        <div>Another way to get the time is: The time is: ${time.value}</div>
        <div>Another way to get the time is: The time is: ${time}</div>
        <label for="name-input">What is your name? </label>
        <input type="text" p-value="${name}" p-change="changeName" id="name-input" />
        <button onclick="resetName">Reset Name</button>
      </div>
    ''';
  }
  @override
  void beforeCreate () {
    print("beforeCreate ${tagName}");
  }
  @override
  void created () {
    t = Timer.periodic(Duration(seconds: 1), (Timer t) => this.time(DateTime.now().toString()));
    print("created ${tagName}");
  }
  @override
  void beforeUpdate () {
    print("beforeUpdate ${tagName}");
  }
  @override
  void updated () {
    print("updated ${tagName}");
  }
  @override
  void beforeDestroy() {
    t.cancel();
    print("beforeDestroy ${tagName}");
  }
  @override
  void destroyed() {
    print("destroyed ${tagName}");
  }
}