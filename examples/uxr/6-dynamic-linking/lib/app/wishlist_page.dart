import 'package:flutter/material.dart';

import 'index.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({required this.wishlist});

  final Wishlist wishlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: Text(wishlist.toString()),
    );
  }
}
