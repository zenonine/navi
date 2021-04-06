import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class TabPage extends Page<dynamic> {
  const TabPage({LocalKey? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder<dynamic>(
      settings: this,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    );
  }
}

class TabFirstPage extends StatelessWidget {
  const TabFirstPage({required this.config, required this.items});

  final TabConfig config;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
        backgroundColor: config.color,
      ),
      body: ListView(
        children: [
          ...items.asMap().entries.map((entry) => ListTile(
                title: Text(entry.value),
                onTap: () {
                  context.navi.stack(InnerStackMarker()).state = entry.key;
                  // context.navi.byRoute(
                  //     RouteInfo(pathSegments: [config.path, '${entry.key}']));
                },
              ))
        ],
      ),
    );
  }
}

class TabSecondPage extends StatelessWidget {
  const TabSecondPage({required this.config, required this.text});

  final TabConfig config;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.title),
        backgroundColor: config.color,
      ),
      body: Center(
        child: Text(text),
      ),
    );
  }
}
