import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class BooksStack extends RouteStack<Book?> {
  BooksStack() : super(initialState: null);

  @override
  List<Page> pages(BuildContext context) {
    return [
      MaterialPage<dynamic>(
        key: const ValueKey('Books'),
        child: BooksPage(onSelectBook: _selectBook),
      ),
      if (state != null)
        MaterialPage<dynamic>(
          key: ValueKey(state),
          child: BookPage(book: state!),
        ),
    ];
  }

  @override
  void beforePop(BuildContext context, Route route, dynamic result) {
    state = null;
  }

  void _selectBook(Book book) {
    state = book;
  }

  @override
  RouteInfo get routeInfo => RouteInfo(
        pathSegments:
            state != null ? ['books', state!.id.toString()] : ['books'],
      );

  @override
  Book? routeInfoToState(RouteInfo routeInfo) {
    if (routeInfo.pathSegments.length == 2 &&
        routeInfo.pathSegments.firstOrNull == 'books') {
      final bookId = int.tryParse(routeInfo.pathSegments[1]);
      if (bookId != null) {
        return books.firstWhereOrNull((book) => book.id == bookId);
      }
    }
  }
}
