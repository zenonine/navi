import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:navi/navi.dart';
import 'package:navi/src/main.dart';

void setupLogger() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
        '${record.level.name.padRight(7)} ${record.time} ${record.loggerName}: ${record.message}');
  });
}

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
  late final _routerDelegate = NaviRouterDelegate.material(
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
