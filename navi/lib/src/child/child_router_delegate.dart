import 'package:flutter/widgets.dart';

import '../main.dart';

class ChildRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  ChildRouterDelegate({
    required this.stack,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _stackListener = () {
      notifyListeners();
    };
    stack.addListener(_stackListener);
  }

  final GlobalKey<NavigatorState> navigatorKey;
  final PageStack stack;
  late final VoidCallback _stackListener;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: stack.pages(context),
      onPopPage: (route, result) => stack.onPopPage(context, route, result),
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {
    assert(false, 'ChildRouterDelegate should not call setNewRoutePath');
  }

  @override
  void dispose() {
    stack.removeListener(_stackListener);
    super.dispose();
  }
}
