A library for Dart developers.

Created from templates made available by Stagehand under a BSD-style
[license](https://github.com/dart-lang/stagehand/blob/master/LICENSE).

## Usage

A simple usage example:

```dart
import 'package:photon/photon.dart';

main() {
  var awesome = new Awesome();
}
```

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://example.com/issues/replaceme

## Tips
 * Return the null tag (`<null></null>`), to prevent unnecessary rerenders instead of returning null.
 * Don't use self closing tags. Instead of `<null />` return `<null></null>`, or instead of `<ComponentTag />` return `<ComponentTag></ComponentTag>`. You can use native html self closing tags e.g. `<input type="text" />`.
 * To reduce rerendering, wrap dynamic lists in the `<list></list>` tag, and provide a unique `p-key` value for each item.
 * Event functions should take the form `f(Event e, VElement v)` for non list events, and `f(Event e, VElement v, int index)` for events on list items.