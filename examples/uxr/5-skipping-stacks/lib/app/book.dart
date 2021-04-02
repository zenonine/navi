import 'index.dart';

class Book {
  const Book({required this.id, required this.title, required this.author});

  final int id;
  final String title;
  final Author author;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Book{id: $id, title: $title, author: $author}';
  }
}
