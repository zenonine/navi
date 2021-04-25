import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

final List<Wishlist> wishlists = [];

class WishlistsStack extends StatefulWidget {
  @override
  _WishlistsStackState createState() => _WishlistsStackState();
}

class _WishlistsStackState extends State<WishlistsStack> with NaviRouteMixin<WishlistsStack> {
  Wishlist? _selectedWishlist;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    int? id;
    if (unprocessedRoute.hasPrefixes(['wishlists'])) {
      id = int.tryParse(unprocessedRoute.pathSegmentAt(1) ?? '');
    }

    _selectedWishlist = id == null
        ? null
        : wishlists.firstWhere(
            (w) => w.id == id,
            orElse: () {
              final newWishlist = Wishlist(id!);
              wishlists.add(newWishlist);
              return newWishlist;
            },
          );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Wishlists'),
          child: WishlistsPagelet(
            wishlists: wishlists,
            onSelectWishlist: (wishlist) => setState(() {
              _selectedWishlist = wishlist;
            }),
          ),
        ),
        if (_selectedWishlist != null)
          NaviPage.material(
            key: ValueKey(_selectedWishlist),
            route: NaviRoute(path: ['wishlists', '${_selectedWishlist!.id}']),
            child: WishlistPagelet(wishlist: _selectedWishlist!),
          ),
      ],
      onPopPage: (context, route, dynamic result) {
        if (_selectedWishlist != null) {
          setState(() {
            _selectedWishlist = null;
          });
        }
      },
    );
  }
}
