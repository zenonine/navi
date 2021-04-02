import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  Widget build(BuildContext context) {
    return RouteStack<String?>(
      marker: BookStackMarker(),
      pages: (context, state) => [
        MaterialPage<dynamic>(
          key: const ValueKey('Books'),
          child: BooksPage(searchTerm: state),
        ),
      ],
      updateStateOnNewRoute: (routeInfo) {
        return routeInfo.queryParams['filter']?.firstOrNull;
      },
      updateRouteOnNewState: (state) {
        if (state?.trim().isNotEmpty == true) {
          return RouteInfo(
            queryParams: {
              'filter': [state!]
            },
          );
        }

        return const RouteInfo();
      },
    );
  }
}

class BookStackMarker extends StackMarker<String?> {}
