import '../main.dart';

abstract class RouteStack<State> extends PageStack<State> {
  RouteStack({String? name, required State initialState})
      : super(initialState: initialState, name: name);

  RouteInfo get routeInfo;

  set routeInfo(RouteInfo newRouteInfo) {
    state = routeInfoToState(newRouteInfo);
  }

  State routeInfoToState(RouteInfo routeInfo);
}
