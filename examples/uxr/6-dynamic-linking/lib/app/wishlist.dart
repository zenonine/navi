class Wishlist {
  Wishlist(this.id);

  final int id;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Wishlist && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Wishlist{id: $id}';
  }
}
