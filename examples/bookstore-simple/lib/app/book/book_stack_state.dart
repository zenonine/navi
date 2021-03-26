import '../index.dart';

class BookStackState {
  const BookStackState({this.book, this.tab});

  final Book? book;
  final BookTab? tab;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BookStackState &&
          runtimeType == other.runtimeType &&
          book == other.book &&
          tab == other.tab;

  @override
  int get hashCode => book.hashCode ^ tab.hashCode;

  @override
  String toString() {
    return 'BookStackState{book: $book, tab: $tab}';
  }
}
