import 'dart:html';

import 'package:photon/photon.dart';

import 'Component.dart';
import 'photon_example_02.reflectable.dart';

main () {
  Logger().display = true;
  initializeReflectable();
  C c = C();
  mount(querySelector("#output"), c);
}