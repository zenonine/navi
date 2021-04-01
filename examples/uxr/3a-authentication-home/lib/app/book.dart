class Book {
  const Book({required this.id, required this.title, required this.author});

  final int id;
  final String title;
  final String author;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Book{title: $title, author: $author}';
  }
}

const List<Book> books = [
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
