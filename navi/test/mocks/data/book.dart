class Book {
  const Book({
    required this.id,
    required this.title,
    required this.author,
  });

  final int id;
  final String title;
  final String author;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
