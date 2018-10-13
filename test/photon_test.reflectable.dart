// This file has been generated by the reflectable package.
// https://github.com/dart-lang/reflectable.

import "dart:core";
import 'package:photon/src/photon_component.dart' as prefix1;
import 'package:photon/src/photon_reflector.dart' as prefix0;
import 'package:photon/src/photon_velement.dart' as prefix2;

// ignore:unused_import
import "package:reflectable/mirrors.dart" as m;
// ignore:unused_import
import "package:reflectable/src/reflectable_builder_based.dart" as r;
// ignore:unused_import
import "package:reflectable/reflectable.dart" as r show Reflectable;

final _data = <r.Reflectable, r.ReflectorData>{
  const prefix0.Reflector(): new r.ReflectorData(
      <m.TypeMirror>[
        new r.NonGenericClassMirrorImpl(
            r"Component",
            r".Component",
            7,
            0,
            const prefix0.Reflector(),
            const <int>[0, 1, 2, 3, 7, 8, 9, 10],
            const <int>[
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24,
              25,
              2,
              3,
              4,
              7,
              8,
              9
            ],
            const <int>[5, 6],
            -1,
            {r"name": () => prefix1.Component.name},
            {r"name=": (value) => prefix1.Component.name = value},
            {r"": (b) => () => b ? new prefix1.Component() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null),
        new r.NonGenericClassMirrorImpl(
            r"VElement",
            r".VElement",
            7,
            1,
            const prefix0.Reflector(),
            const <int>[
              16,
              17,
              18,
              19,
              26,
              20,
              21,
              27,
              25,
              28,
              29,
              22,
              23,
              24,
              30,
              31
            ],
            const <int>[
              11,
              12,
              13,
              14,
              15,
              16,
              17,
              18,
              19,
              20,
              21,
              22,
              23,
              24,
              25
            ],
            const <int>[],
            -1,
            {},
            {},
            {r"": (b) => () => b ? new prefix2.VElement() : null},
            -1,
            -1,
            const <int>[-1],
            null,
            null)
      ],
      <m.DeclarationMirror>[
        new r.VariableMirrorImpl(r"childComponents", 2130949, 0,
            const prefix0.Reflector(), -1, -1, -1, null, null),
        new r.VariableMirrorImpl(r"name", 32789, 0, const prefix0.Reflector(),
            -1, -1, -1, null, null),
        new r.MethodMirrorImpl(r"render", 262146, 0, null, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"rerender", 262146, 0, null, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 0, -1, -1, 4),
        new r.ImplicitGetterMirrorImpl(const prefix0.Reflector(), 1, -1, -1, 5),
        new r.ImplicitSetterMirrorImpl(const prefix0.Reflector(), 1, -1, -1, 6),
        new r.MethodMirrorImpl(r"childTags", 4325379, 0, -1, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"childTags=", 262148, 0, null, -1, -1, null,
            const <int>[1], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"template", 65539, 0, null, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"", 0, 0, -1, -1, -1, null, const <int>[],
            const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"==", 131074, null, -1, -1, -1, null,
            const <int>[2], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"toString", 131074, null, -1, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"noSuchMethod", 65538, null, null, -1, -1, null,
            const <int>[3], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"hashCode", 131075, null, -1, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"runtimeType", 131075, null, -1, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"parseElementTree", 131074, 1, 1, -1, -1, null,
            const <int>[4, 5, 6, 7], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"patchEl", 262146, 1, null, -1, -1, null,
            const <int>[8], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"addChild", 262146, 1, null, -1, -1, null,
            const <int>[9], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"genEl", 262146, 1, null, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"sanitizeAttributes", 4325378, 1, -1, -1, -1,
            null, const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"addListeners", 262146, 1, null, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"children=", 262148, 1, null, -1, -1, null,
            const <int>[10], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"parent=", 262148, 1, null, -1, -1, null,
            const <int>[11], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"el", 65539, 1, null, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"attributes=", 262148, 1, null, -1, -1, null,
            const <int>[12], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"checkAttributes", 131074, 1, -1, -1, -1, null,
            const <int>[13], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"attributes", 4325379, 1, -1, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"text", 131075, 1, -1, -1, -1, null,
            const <int>[], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"text=", 262148, 1, null, -1, -1, null,
            const <int>[15], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"el=", 262148, 1, null, -1, -1, null,
            const <int>[16], const prefix0.Reflector(), null),
        new r.MethodMirrorImpl(r"", 64, 1, -1, -1, -1, null, const <int>[],
            const prefix0.Reflector(), null)
      ],
      <m.ParameterMirror>[
        new r.ParameterMirrorImpl(r"_name", 32870, 6, const prefix0.Reflector(),
            -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"value", 2129926, 8,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"other", 16390, 11,
            const prefix0.Reflector(), null, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"invocation", 32774, 13,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"root", 32774, 16, const prefix0.Reflector(),
            0, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"el", 32774, 16, const prefix0.Reflector(),
            -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"parent", 32774, 16,
            const prefix0.Reflector(), 1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"childTags", 2129926, 16,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"el", 32774, 17, const prefix0.Reflector(),
            -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"el", 32774, 18, const prefix0.Reflector(),
            -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"children", 2129926, 22,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"parent", 32774, 23,
            const prefix0.Reflector(), 1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"attr", 2129926, 25,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"k", 32774, 26, const prefix0.Reflector(),
            -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"value", 2129926, 25,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"value", 32774, 29,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null),
        new r.ParameterMirrorImpl(r"value", 32774, 30,
            const prefix0.Reflector(), -1, -1, -1, null, null, null, null)
      ],
      <Type>[prefix1.Component, prefix2.VElement],
      2,
      {
        r"==": (dynamic instance) => (x) => instance == x,
        r"toString": (dynamic instance) => instance.toString,
        r"noSuchMethod": (dynamic instance) => instance.noSuchMethod,
        r"hashCode": (dynamic instance) => instance.hashCode,
        r"runtimeType": (dynamic instance) => instance.runtimeType,
        r"parseElementTree": (dynamic instance) => instance.parseElementTree,
        r"patchEl": (dynamic instance) => instance.patchEl,
        r"addChild": (dynamic instance) => instance.addChild,
        r"genEl": (dynamic instance) => instance.genEl,
        r"sanitizeAttributes": (dynamic instance) =>
            instance.sanitizeAttributes,
        r"addListeners": (dynamic instance) => instance.addListeners,
        r"el": (dynamic instance) => instance.el,
        r"render": (dynamic instance) => instance.render,
        r"rerender": (dynamic instance) => instance.rerender,
        r"childComponents": (dynamic instance) => instance.childComponents,
        r"childTags": (dynamic instance) => instance.childTags,
        r"template": (dynamic instance) => instance.template
      },
      {
        r"children=": (dynamic instance, value) => instance.children = value,
        r"parent=": (dynamic instance, value) => instance.parent = value,
        r"attributes=": (dynamic instance, value) =>
            instance.attributes = value,
        r"childTags=": (dynamic instance, value) => instance.childTags = value
      },
      null,
      [])
};

final _memberSymbolMap = null;

initializeReflectable() {
  r.data = _data;
  r.memberSymbolMap = _memberSymbolMap;
}
