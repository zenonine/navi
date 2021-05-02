import 'package:flutter/widgets.dart';

class InheritedRootNavigatorKey extends InheritedWidget {
  const InheritedRootNavigatorKey({
    Key? key,
    required Widget child,
    required this.navigatorKey,
  }) : super(key: key, child: child);

  final GlobalKey<NavigatorState> navigatorKey;

  static GlobalKey<NavigatorState> of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedRootNavigatorKey>()!
        .navigatorKey;
  }

  @override
  bool updateShouldNotify(covariant InheritedRootNavigatorKey oldWidget) {
    return navigatorKey != oldWidget.navigatorKey;
  }
}
