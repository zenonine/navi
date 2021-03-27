import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navi - Declarative navigation API for Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.white70,
          cursorColor: Colors.white30,
        ),
      ),
      routeInformationParser: NaviInformationParser(),
      routerDelegate: NaviRouterDelegate(rootStack: BooksStack()),
    );
  }
}
