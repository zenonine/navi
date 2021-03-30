import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';

// TODO: better way to manage NaviState
class NaviState extends ChangeNotifier {
  factory NaviState() => _instance;

  NaviState._internal();

  static final NaviState _instance = NaviState._internal();

  List<PageStack> _stacks = [];

  List<PageStack> get stacks => _stacks;

  set stacks(List<PageStack> newStacks) {
    _stacks = newStacks;
    notifyListeners();
  }

  RouteInfo get routeInfo {
    final routeInfos = _stacks.map((stack) {
      if (stack is RouteStack) {
        return stack.routeInfo;
      }
    }).whereType<RouteInfo>();

    return RouteInfo(
      pathSegments: routeInfos.expand((r) => r.pathSegments).toList(),
    );
  }
}
