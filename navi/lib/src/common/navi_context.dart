import 'package:flutter/widgets.dart';

import '../main.dart';

class Navi {
  Navi(this.context);

  final BuildContext context;

  StackStateInterface get parentStack => InheritedStack.of(context);

  List<StackStateInterface> get parentStacks =>
      InheritedStackMarker.of(context);

  StackStateInterface<T> stack<T>(StackMarker<T> marker) =>
      InheritedStackMarker.singleOf<T>(context, marker);

  Future<void> byUrl(String location) {
    final uri = Uri.parse(location);
    return byRoute(RouteInfo.fromUri(uri));
  }

  Future<void> byRoute(RouteInfo routeInfo) async {
    RootStackController().childRouteInfo = routeInfo;
  }
}

class InternalNavi extends Navi {
  InternalNavi(BuildContext context) : super(context);

  int get newRouteCount => InheritedNewRouteCount.of(context);

  @override
  StackState get parentStack => super.parentStack as StackState;

  @override
  List<StackState> get parentStacks => super.parentStacks as List<StackState>;

  @override
  StackState<T> stack<T>(StackMarker<T> marker) =>
      super.stack(marker) as StackState<T>;
}

extension NaviContext on BuildContext {
  Navi get navi => Navi(this);
}

extension InternalNaviContext on BuildContext {
  InternalNavi get internalNavi => InternalNavi(this);
}
