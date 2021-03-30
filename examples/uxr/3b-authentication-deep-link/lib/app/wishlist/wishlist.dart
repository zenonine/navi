class Wishlist {
  const Wishlist({required this.id, required this.name});

  final int id;
  final String name;

  @override
  String toString() {
    return 'Wishlist{id: $id, name: $name}';
  }
}

const wishlists = [
  Wishlist(id: 1, name: 'Book 1'),
  Wishlist(id: 2, name: 'Book 2'),
  Wishlist(id: 3, name: 'Book 3'),
];
