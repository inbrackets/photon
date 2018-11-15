import 'dart:async';
import 'dart:html';

import 'package:photon/photon.dart';

class Singleton {
  static final Singleton _singleton = new Singleton._internal();

  factory Singleton() {
    return _singleton;
  }

  Singleton._internal() {
    //t = Timer.periodic(Duration(seconds: 1), (Timer t) => this.time(DateTime.now().toString()));
  }
  StateValue<String> time = StateValue("00:00:00");
  StateValue<String> name = StateValue("World");
  Timer t;
}

@component
class C extends Component {
  // Tag name for mounting in parent components
  @override
  static String tagName = "Component";
  // child components
  @override
  final List<Type> childComponents = [SubC];
  // External state tracking a single object
  StateValue<String> name = Singleton().name;
  StateValue<String> time = Singleton().time;
  StateValue<bool> showSub = StateValue(true);

  void changeName(Event e, VElement v) {
    name((v.el as TextInputElement).value);
  }

  void resetName(Event e, VElement v) {
    name("World");
  }

  void destroySub(Event e, VElement v) {
    showSub(!showSub());
  }

  get template {
    return '''
      <div>
        <div>Hello ${name}!</div>
        <div>The time is: ${time()}</div>
        <div>Another way to get the time is: The time is: ${time.value}</div>
        <div>Another way to get the time is: The time is: ${time}</div>
        ${showSub() ? '<SubComponent></SubComponent>' : '<null></null>'} <!-- note the use of the null string -->
        <button onclick="destroySub">${showSub() ? 'Destroy Sub Component' : 'Show Sub Component'}</button> <br />
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
    print("beforeDestroy ${tagName}");
  }
  @override
  void destroyed() {
    print("destroyed ${tagName}");
  }
}

@component
class SubC extends Component {
  // Tag name for mounting in parent components
  @override
  static String tagName = "SubComponent";
  // External state tracking a single object
  StateValue<String> time = Singleton().time;

  get template {
    return '''
      <div>
        <div>The time in sub component is: ${time}</div>
      </div>
    ''';
  }
  @override
  void beforeCreate () {
    print("beforeCreate ${tagName}");
  }
  @override
  void created () {
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
    print("beforeDestroy ${tagName}");
  }
  @override
  void destroyed() {
    print("destroyed ${tagName}");
  }
}