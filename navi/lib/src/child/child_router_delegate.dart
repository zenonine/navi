import 'package:flutter/widgets.dart';

import '../main.dart';

class ChildRouterDelegate extends RouterDelegate<dynamic>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<dynamic> {
  ChildRouterDelegate({
    required this.stack,
    GlobalKey<NavigatorState>? navigatorKey,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _stackListener = () {
      notifyListeners();
    };
    stack.addListener(_stackListener);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final PageStack stack;
  late final VoidCallback _stackListener;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: stack.pages(context),
      onPopPage: (route, dynamic result) =>
          stack.onPopPage(context, route, result),
    );
  }

  @override
  Future<void> setNewRoutePath(dynamic configuration) async {
    assert(false, 'ChildRouterDelegate should not call setNewRoutePath');
  }

  @override
  void dispose() {
    stack.removeListener(_stackListener);
    super.dispose();
  }
}
