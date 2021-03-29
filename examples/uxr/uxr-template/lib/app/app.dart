import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class App extends StatelessWidget {
  final _informationParser = NaviInformationParser();
  final _routerDelegate = NaviRouterDelegate(
    rootStack: InlinePageStack(
      pages: (BuildContext context) => [
        MaterialPage<dynamic>(
          key: const ValueKey('Root'),
          child: RootPage(),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Navi - Declarative navigation API for Flutter',
      debugShowCheckedModeBanner: false,
      routeInformationParser: _informationParser,
      routerDelegate: _routerDelegate,
    );
  }
}