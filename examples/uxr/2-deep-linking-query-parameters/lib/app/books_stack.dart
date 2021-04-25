import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class SearchTermNotification extends Notification {
  const SearchTermNotification(this.searchTerm);

  final String? searchTerm;
}

class BooksStack extends StatefulWidget {
  @override
  _BooksStackState createState() => _BooksStackState();
}

class _BooksStackState extends State<BooksStack>
    with NaviRouteMixin<BooksStack> {
  String? searchTerm;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    searchTerm = unprocessedRoute.queryParams['filter']?.firstOrNull;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<SearchTermNotification>(
      onNotification: (notification) {
        setState(() {
          searchTerm = notification.searchTerm;
        });
        return true;
      },
      child: NaviStack(
        pages: (context) => [
          NaviPage.material(
            key: const ValueKey('Books'),
            route: NaviRoute(
                queryParams: searchTerm?.isNotEmpty == true
                    ? {
                        'filter': [searchTerm!]
                      }
                    : {}),
            child: BooksPagelet(searchTerm: searchTerm),
          ),
        ],
      ),
    );
  }
}
