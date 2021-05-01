import 'package:flutter/material.dart';
import 'package:navi/navi.dart';
import 'package:navi/src/main.dart';

import 'mocks.dart';

class MockApp extends StatefulWidget {
  const MockApp({
    required this.navigatorKey,
    this.routeInformationProvider,
    required this.child,
  }) : super();

  final GlobalKey<NavigatorState> navigatorKey;
  final RouteInformationProvider? routeInformationProvider;
  final Widget child;

  @override
  _MockAppState createState() => _MockAppState();
}

class _MockAppState extends State<MockApp> {
  _MockAppState() {
    setupLogger();
  }

  late final log = logger(this);

  final _informationParser = NaviInformationParser();
  late final _routerDelegate = MockNaviRouterDelegate.material(
    child: widget.child,
    navigatorKey: widget.navigatorKey,
  );

  @override
  void initState() {
    log.info('initState');
    super.initState();
  }

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
    log.info('_MockAppState disposed');
    mockLogger.info('_MockAppState disposed');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _informationParser,
      routerDelegate: _routerDelegate,
      routeInformationProvider: widget.routeInformationProvider,
    );
  }
}
