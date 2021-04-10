import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class BooksStack extends StatefulWidget {
  @override
  _BooksStackState createState() => _BooksStackState();
}

class _BooksStackState extends State<BooksStack>
    with NaviRouteMixin<BooksStack> {
  Book? _selectedBook;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    _selectedBook = null;
    final bookId = int.tryParse(unprocessedRoute.pathSegmentAt(0) ?? '');
    if (bookId != null) {
      _selectedBook = books.firstWhereOrNull((book) => book.id == bookId);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Books'),
          child: BooksPagelet(
            onSelectBook: (book) => setState(() {
              _selectedBook = book;
            }),
          ),
        ),
        if (_selectedBook != null)
          NaviPage.material(
            key: ValueKey(_selectedBook),
            route: NaviRoute(path: ['${_selectedBook!.id}']),
            child: BookPagelet(book: _selectedBook!),
          ),
      ],
      onPopPage: (context, route, dynamic result) {
        if (_selectedBook != null) {
          setState(() {
            _selectedBook = null;
          });
        }
      },
    );
  }
}
