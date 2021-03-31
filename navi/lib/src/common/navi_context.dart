import 'package:flutter/widgets.dart';

import '../main.dart';

extension NaviContext on BuildContext {
  int get newRouteCount => InheritedNewRouteCount.of(this);

  StackState get stackState => InheritedStack.of(this);
}
