import 'package:reflectable/reflectable.dart';

class Reflector extends Reflectable {
  const Reflector()
      : super(invokingCapability, newInstanceCapability, staticInvokeCapability,
      declarationsCapability, reflectedTypeCapability, instanceInvokeCapability); // Request the capability to invoke methods.
}

const component = const Reflector();