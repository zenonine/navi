import 'package:collection/collection.dart';

import '../mocks.dart';

class BookstoreService {
  const BookstoreService();

  static const List<Book> _books = [
    Book(
      id: 0,
      title: 'Stranger in a Strange Land',
      authorId: 0,
    ),
    Book(
      id: 1,
      title: 'Foundation',
      authorId: 2,
    ),
    Book(
      id: 2,
      title: 'Fahrenheit 451',
      authorId: 3,
    ),
  ];

  static const List<Author> _authors = [
    Author(id: 0, name: 'Robert A. Heinlein'),
    Author(id: 2, name: 'Isaac Asimov'),
    Author(id: 3, name: 'Ray Bradbury'),
  ];

  Book? getBook(int? id) =>
      id == null ? null : _books.firstWhereOrNull((book) => book.id == id);

  Author? getAuthor(int? id) => id == null
      ? null
      : _authors.firstWhereOrNull((author) => author.id == id);

  List<Author> getAuthors() => [..._authors];

  List<Book> getBooks([String? filter]) {
    final normalizedFilter = filter?.trim().toLowerCase() ?? '';
    return [
      ...normalizedFilter.isEmpty
          ? _books
          : _books.where(
              (book) =>
                  book.title.toLowerCase().contains(normalizedFilter) ||
                  getAuthor(book.authorId)
                          ?.name
                          .toLowerCase()
                          .contains(normalizedFilter) ==
                      true,
            )
    ];
  }
}
