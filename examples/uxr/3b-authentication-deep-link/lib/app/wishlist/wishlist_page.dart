import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage([this.wishlist]);

  final Wishlist? wishlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(wishlist == null ? 'Wishlists' : 'Wishlist'),
      ),
      body: wishlist == null
          ? ListView(
              children: wishlists
                  .map((w) => ListTile(
                title: Text('$w'),
                        onTap: () {
                          context.stack<WishlistStack>().state = w;
                        },
                      ))
                  .toList(),
            )
          : Text('$wishlist'),
    );
  }
}
