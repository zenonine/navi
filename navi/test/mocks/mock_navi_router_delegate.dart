import 'package:flutter/material.dart';
import 'package:navi/navi.dart';
import 'package:navi/src/common/callbacks.dart';
import 'package:navi/src/main.dart';

import 'mocks.dart';

class MockNaviRouterDelegate extends NaviRouterDelegate {
  MockNaviRouterDelegate.material({
    GlobalKey<NavigatorState>? navigatorKey,
    required Widget child,
    NaviRootPopPageCallback? onPopPage,
    Widget? uninitializedPage,
  }) : super.material(
          navigatorKey: navigatorKey,
          child: child,
          onPopPage: onPopPage,
          uninitializedPage: uninitializedPage,
        );

  late final log = logger(this);

  @override
  void dispose() {
    super.dispose();
    log.info('MockNaviRouterDelegate disposed');
    mockLogger.info('MockNaviRouterDelegate disposed');
  }
}
