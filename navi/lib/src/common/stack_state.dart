import 'package:flutter/foundation.dart';

import '../main.dart';

class StackState<T> extends ChangeNotifier {
  StackState({
    required T initialState,
    RouteInfoBuilder<T>? routeInfoBuilder,
  })  : _state = initialState,
        _routeInfoBuilder = routeInfoBuilder {
    _updateRouteInfo();
  }

  T _state;

  T get state => _state;

  set state(T newState) {
    _state = newState;
    _updateRouteInfo();
    notifyListeners();
  }

  late RouteInfo _routeInfo;

  RouteInfo get routeInfo => _routeInfo;

  final RouteInfoBuilder<T>? _routeInfoBuilder;

  void _updateRouteInfo() {
    _routeInfo = _routeInfoBuilder?.call(_state) ?? const RouteInfo();
  }

  List<RouteInfo> parentRouteInfos = [];

  RouteInfo childRouteInfo = const RouteInfo();

  @override
  String toString() {
    return 'StackState{state: $state}';
  }
}
