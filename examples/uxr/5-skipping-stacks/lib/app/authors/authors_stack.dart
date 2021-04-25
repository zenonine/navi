import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class AuthorsStack extends StatefulWidget {
  @override
  _AuthorsStackState createState() => _AuthorsStackState();
}

class _AuthorsStackState extends State<AuthorsStack>
    with NaviRouteMixin<AuthorsStack> {
  Author? _selectedAuthor;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    final authorId = int.tryParse(unprocessedRoute.pathSegmentAt(0) ?? '');
    _selectedAuthor =
        authors.firstWhereOrNull((author) => author.id == authorId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Authors'),
          child: AuthorsPagelet(
            onSelectAuthor: (author) => setState(() {
              _selectedAuthor = author;
            }),
          ),
        ),
        if (_selectedAuthor != null)
          NaviPage.material(
            key: ValueKey(_selectedAuthor),
            route: NaviRoute(path: ['${_selectedAuthor!.id}']),
            child: AuthorPagelet(author: _selectedAuthor!),
          ),
      ],
      onPopPage: (context, route, dynamic result) {
        if (_selectedAuthor != null) {
          setState(() {
            _selectedAuthor = null;
          });
        }
      },
    );
  }
}
