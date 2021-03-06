import 'index.dart';

const List<Book> books = [
  Book(
    id: 0,
    title: 'Stranger in a Strange Land',
    author: Author(id: 3, name: 'Robert A. Heinlein'),
  ),
  Book(
    id: 1,
    title: 'Foundation',
    author: Author(id: 4, name: 'Isaac Asimov'),
  ),
  Book(
    id: 2,
    title: 'Fahrenheit 451',
    author: Author(id: 5, name: 'Ray Bradbury'),
  ),
];

final List<Author> authors = books.map((book) => book.author).toList();
