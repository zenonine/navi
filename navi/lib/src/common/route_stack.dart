import '../main.dart';

abstract class RouteStack<State> extends PageStack<State> {
  RouteStack({required State initialState}) : super(initialState: initialState);

  RouteInfo get routeInfo;

  set routeInfo(RouteInfo newRouteInfo) {
    state = routeInfoToState(newRouteInfo);
  }

  State routeInfoToState(RouteInfo routeInfo);
}
