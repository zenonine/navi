import 'package:flutter/foundation.dart';

import '../main.dart';

abstract class StackStateInterface<T> {
  T get state;

  set state(T newState);

  RouteInfo get routeInfo;

// TODO: activate/deactivate methods
// TODO: pop method to pop directly on any stack
}

class StackState<T> extends ChangeNotifier implements StackStateInterface<T> {
  StackState({
    this.marker,
    required T initialState,
    RouteInfoBuilder<T>? routeInfoBuilder,
  })  : _state = initialState,
        _routeInfoBuilder = routeInfoBuilder {
    _updateRouteInfo();
  }

  final StackMarker<T>? marker;

  T _state;

  @override
  T get state => _state;

  @override
  set state(T newState) {
    setStateWithoutNotifyRouter(newState);
    RouterState().state = this;
  }

  void setStateWithoutNotifyRouter(T newState) {
    if (_state != newState) {
      _state = newState;
      _updateRouteInfo();
      notifyListeners();
    }
  }

  late RouteInfo _routeInfo;

  @override
  RouteInfo get routeInfo => _routeInfo;

  final RouteInfoBuilder<T>? _routeInfoBuilder;

  void _updateRouteInfo() {
    _routeInfo = _routeInfoBuilder?.call(_state) ?? const RouteInfo();
  }

  List<RouteInfo> parentRouteInfos = [];

  RouteInfo childRouteInfo = const RouteInfo();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StackState &&
          runtimeType == other.runtimeType &&
          marker == other.marker &&
          state == other.state;

  @override
  int get hashCode => marker.hashCode ^ state.hashCode;

  @override
  String toString() {
    return 'StackState{marker: $marker, state: $state}';
  }
}
