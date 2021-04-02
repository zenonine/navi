import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class AuthorsStack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteStack<Author?>(
      marker: AuthorsStackMarker(),
      pages: (context, state) => [
        MaterialPage<dynamic>(
          key: const ValueKey('Authors'),
          child: AuthorsPage(),
        ),
        if (state != null)
          MaterialPage<dynamic>(
            key: ValueKey(state),
            child: AuthorPage(author: state),
          ),
      ],
      updateStateOnNewRoute: (routeInfo) {
        final authorId = int.tryParse(routeInfo.pathSegmentAt(0) ?? '');
        return authors.firstWhereOrNull((author) => author.id == authorId);
      },
      updateRouteOnNewState: (state) =>
          RouteInfo(pathSegments: state == null ? [] : ['${state.id}']),
      updateStateBeforePop: (context, route, dynamic result, state) => null,
    );
  }
}

class AuthorsStackMarker extends StackMarker<Author?> {}
