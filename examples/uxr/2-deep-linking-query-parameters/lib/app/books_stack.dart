import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class BooksStack extends RouteStack<String?> {
  BooksStack() : super(initialState: '');

  bool get _hasSearchTerm => state?.trim().isNotEmpty == true;

  @override
  List<Page> pages(BuildContext context) {
    return [
      MaterialPage<dynamic>(
        key: const ValueKey('Books'),
        child: BooksPage(onSearchStart: _search),
      ),
      if (_hasSearchTerm)
        MaterialPage<dynamic>(
          key: const ValueKey('SearchResults'),
          child: BooksSearchResultsPage(term: state!.trim()),
        ),
    ];
  }

  @override
  void beforePop(BuildContext context, Route route, dynamic result) {
    state = null;
  }

  void _search(String term) {
    state = term;
  }

  @override
  RouteInfo get routeInfo {
    if (_hasSearchTerm) {
      return RouteInfo(
        pathSegments: ['books', 'q'],
        queryParams: {
          'term': [state!.trim()]
        },
      );
    }

    return const RouteInfo(pathSegments: ['books']);
  }

  @override
  String? routeInfoToState(RouteInfo routeInfo) {
    if (routeInfo.pathSegments.length == 2 &&
        routeInfo.pathSegments[0] == 'books' &&
        routeInfo.pathSegments[1] == 'q' &&
        routeInfo.queryParams['term']?.firstOrNull?.trim().isNotEmpty == true) {
      return routeInfo.queryParams['term']?.first;
    }
  }
}
