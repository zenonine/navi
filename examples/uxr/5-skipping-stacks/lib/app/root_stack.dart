import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

enum RootPageId { books, authors }

class RootStack extends StatefulWidget {
  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  RootPageId _pageId = RootPageId.books;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _pageId = unprocessedRoute.hasPrefixes(['authors'])
        ? RootPageId.authors
        : RootPageId.books;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) {
        switch (_pageId) {
          case RootPageId.authors:
            return [
              NaviPage.material(
                key: const ValueKey('Authors'),
                route: const NaviRoute(path: ['authors']),
                child: AuthorsStack(),
              )
            ];
          case RootPageId.books:
          default:
            return [
              NaviPage.material(
                key: const ValueKey('Books'),
                route: const NaviRoute(path: ['books']),
                child: BooksStack(),
              )
            ];
        }
      },
    );
  }
}
