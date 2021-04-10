import 'dart:math';

import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class WishlistsPagelet extends StatelessWidget {
  const WishlistsPagelet({
    Key? key,
    required this.wishlists,
    required this.onSelectWishlist,
  }) : super(key: key);

  final List<Wishlist> wishlists;
  final ValueChanged<Wishlist> onSelectWishlist;

  int get _maxId => wishlists
      .map((e) => e.id)
      .fold(0, (previousValue, element) => max(previousValue, element));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlists'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
                'Navigate to /wishlists/<ID> in the URL bar to dynamically '
                'create a new wishlist.'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                context.navi.to(['wishlists', '${_maxId + 1}']);
              },
              child: const Text('Create new Wishlist'),
            ),
          ),
          Expanded(
            child: ListView(
              children: wishlists
                  .map((wishlist) => ListTile(
                        title: Text(wishlist.toString()),
                        onTap: () => onSelectWishlist(wishlist),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
