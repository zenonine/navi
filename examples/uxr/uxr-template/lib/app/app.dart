import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navi - Declarative navigation API for Flutter',
      routeInformationParser: NaviInformationParser(),
      routerDelegate: NaviRouterDelegate(rootStack: RootStack()),
    );
  }
}
