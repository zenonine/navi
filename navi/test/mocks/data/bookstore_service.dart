import 'package:collection/collection.dart';

import '../mocks.dart';

class BookstoreService {
  const BookstoreService();

  static const List<Book> _books = [
    Book(
      id: 0,
      title: 'Stranger in a Strange Land',
      author: 'Robert A. Heinlein',
    ),
    Book(
      id: 1,
      title: 'Foundation',
      author: 'Isaac Asimov',
    ),
    Book(
      id: 2,
      title: 'Fahrenheit 451',
      author: 'Ray Bradbury',
    ),
  ];

  Book? getBook(int? id) =>
      id == null ? null : _books.firstWhereOrNull((book) => book.id == id);

  List<Book> getBooks([String? filter]) {
    final normalizedFilter = filter?.trim().toLowerCase() ?? '';
    return [
      ...normalizedFilter.isNotEmpty
          ? _books.where(
              (book) =>
                  book.title.toLowerCase().contains(normalizedFilter) ||
                  book.author.toLowerCase().contains(normalizedFilter),
            )
          : _books
    ];
  }
}

const bookstoreService = BookstoreService();
