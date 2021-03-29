import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class App extends StatelessWidget {
  final _informationParser = NaviInformationParser();
  final _routerDelegate = NaviRouterDelegate(rootStack: BooksStack());

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
      routeInformationParser: _informationParser,
      routerDelegate: _routerDelegate,
    );
  }
}
