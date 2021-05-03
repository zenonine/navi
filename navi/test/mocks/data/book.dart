class Book {
  const Book({
    required this.id,
    required this.title,
    required this.authorId,
  });

  final int id;
  final String title;
  final int authorId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
