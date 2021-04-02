import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';

class RootStackController extends ChangeNotifier {
  factory RootStackController() => _instance;

  RootStackController._internal();

  static late final RootStackController _instance =
      RootStackController._internal();

  RouteInfo _childRouteInfo = const RouteInfo();

  RouteInfo get childRouteInfo => _childRouteInfo;

  set childRouteInfo(RouteInfo childRouteInfo) {
    _childRouteInfo = childRouteInfo;
    notifyListeners();
  }
}
