import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

const defaultInitialState = BookStackState();

class BookStack extends RouteStack<BookStackState> {
  BookStack({BookStackState initialState = defaultInitialState})
      : super(initialState: initialState);

  @override
  List<Page> pages(BuildContext context) => [
        MaterialPage(
          key: ValueKey('Books'),
          child: BooksPage(onSelectBook: _selectBook),
        ),
        if (state.book != null)
          MaterialPage(
            key: ValueKey(state),
            child: BookPage(
              book: state.book!,
              tab: state.tab,
              onSelectBookTab: _selectBookTab,
            ),
          ),
      ];

  void _selectBook(Book? book) {
    state = BookStackState(book: book);
  }

  void _selectBookTab(BookTab bookTab) {
    state = BookStackState(
      book: state.book,
      tab: bookTab,
    );
  }

  @override
  void beforePop(context, route, result) => state = defaultInitialState;

  @override
  RouteInfo get routeInfo {
    final bookId = state.book?.id;
    if (bookId != null) {
      return RouteInfo(
        pathSegments: [bookId.toString()],
        queryParams: {
          'tab': [bookTabName(state.tab ?? defaultBookTab)]
        },
      );
    }

    return RouteInfo();
  }

  @override
  BookStackState routeInfoToState(RouteInfo routeInfo) {
    final bookId = int.tryParse(routeInfo.pathSegments.firstOrNull ?? '');
    final tab = fromBookTabName(routeInfo.queryParams['tab']?.firstOrNull);

    return BookStackState(
      book: books.firstWhereOrNull((book) => book.id == bookId),
      tab: tab,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookStack &&
          runtimeType == other.runtimeType &&
          state == other.state;

  @override
  int get hashCode => state.hashCode;
}
