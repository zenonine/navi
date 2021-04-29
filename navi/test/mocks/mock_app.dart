import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

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
  final _informationParser = NaviInformationParser();
  late final _routerDelegate = NaviRouterDelegate.material(
    child: widget.child,
    navigatorKey: widget.navigatorKey,
  );

  @override
  void dispose() {
    _routerDelegate.dispose();
    super.dispose();
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
