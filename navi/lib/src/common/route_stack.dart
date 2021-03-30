import '../main.dart';

abstract class RouteStack<State> extends PageStack<State> {
  RouteStack({String? name, required State initialState})
      : super(initialState: initialState, name: name);

  RouteInfo get routeInfo;

  set routeInfo(RouteInfo newRouteInfo) {
    state = routeInfoToState(newRouteInfo);
    // TODO: for all children, child.routeInfo = newRouteInfo - this.routeInfo
  }

  State routeInfoToState(RouteInfo routeInfo);
}
