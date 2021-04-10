import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class BooksStack extends StatefulWidget {
  @override
  _BooksStackState createState() => _BooksStackState();
}

class _BooksStackState extends State<BooksStack>
    with NaviRouteMixin<BooksStack> {
  bool _showBooks = false;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    setState(() {
      _showBooks = unprocessedRoute.hasPrefixes(['books']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Home'),
          child: HomePagelet(),
        ),
        if (_showBooks)
          NaviPage.material(
            key: const ValueKey('Books'),
            route: const NaviRoute(path: ['books']),
            child: BooksPagelet(),
          ),
      ],
      onPopPage: (context, route, dynamic result) {
        if (_showBooks) {
          setState(() {
            _showBooks = false;
          });
        }
      },
    );
  }
}
