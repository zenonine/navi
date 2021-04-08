import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../main.dart';

class ChildRouterDelegate<T> extends RouterDelegate<dynamic>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<dynamic> {
  ChildRouterDelegate({
    GlobalKey<NavigatorState>? navigatorKey,
    required this.naviPages,
    required this.stackState,
    required this.onPopPage,
  }) : navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _stackListener = () {
      notifyListeners();
    };
    stackState.addListener(_stackListener);
  }

  @override
  final GlobalKey<NavigatorState> navigatorKey;
  final NaviPagesBuilder<T> naviPages;
  late final StackState<T> stackState;
  late final VoidCallback _stackListener;
  final NaviPopPageCallback onPopPage;

  @override
  Widget build(BuildContext context) {
    final pages = naviPages(context, stackState.state);
    return InheritedStackMarker(
      states: context.internalNavi.parentStacks + [stackState],
      child: InheritedStack(
        state: stackState,
        child: Navigator(
          key: navigatorKey,
          pages: [
            ...pages.mapIndexed(
              (index, page) => page.pageBuilder(
                page.key,
                InheritedPageActivation(
                  active: index == pages.length - 1,
                  child: page.child,
                ),
              ),
            )
          ],
          onPopPage: (route, dynamic result) =>
              onPopPage(context, route, result),
        ),
      ),
    );
  }

  @override
  Future<void> setNewRoutePath(dynamic configuration) async {
    assert(false, 'ChildRouterDelegate should not call setNewRoutePath');
  }

  @override
  void dispose() {
    stackState.removeListener(_stackListener);
    super.dispose();
  }
}
