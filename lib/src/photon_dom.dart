import 'dart:html';

import 'package:photon/photon.dart';

void mount(Element el, Component c) {
  el.children = [c.el];
}