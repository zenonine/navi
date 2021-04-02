import 'dart:math';

import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class WishlistsPage extends StatelessWidget {
  const WishlistsPage({required this.wishlists});

  final List<Wishlist> wishlists;

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
            child:
                Text('Navigate to /wishlist/<ID> in the URL bar to dynamically '
                    'create a new wishlist.'),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                context.navi.stack(RootStackMarker()).state =
                    Wishlist(_maxId + 1);
              },
              child: const Text('Create new Wishlist'),
            ),
          ),
          Expanded(
            child: ListView(
              children: wishlists
                  .map((w) => ListTile(
                        title: Text(w.toString()),
                        onTap: () {
                          context.navi.stack(RootStackMarker()).state = w;
                        },
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
