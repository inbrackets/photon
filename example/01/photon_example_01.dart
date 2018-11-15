import 'dart:html';

import 'package:photon/photon.dart';

import 'Component.dart';
import 'photon_example_01.reflectable.dart';

main () {
  Logger().display = false;
  initializeReflectable();
  C c = C();
  mount(querySelector("#output"), c);
}