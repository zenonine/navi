import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

final List<Wishlist> wishlists = [];

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteStack<Wishlist?>(
      marker: RootStackMarker(),
      pages: (context, state) => [
        MaterialPage<dynamic>(
          key: const ValueKey('Home'),
          child: WishlistsPage(wishlists: wishlists),
        ),
        if (state != null)
          MaterialPage<dynamic>(
            key: ValueKey(state),
            child: WishlistPage(wishlist: state),
          ),
      ],
      updateStateOnNewRoute: (routeInfo) {
        if (routeInfo.hasPrefixes(['wishlists'])) {
          final id = int.tryParse(routeInfo.pathSegmentAt(1) ?? '');

          if (id != null) {
            return wishlists.firstWhere(
              (w) => w.id == id,
              orElse: () => Wishlist(id),
            );
          }
        }
      },
      updateRouteOnNewState: (state) {
        if (state != null && !wishlists.contains(state)) {
          wishlists.add(state);
        }

        return RouteInfo(
            pathSegments: state == null ? [] : ['wishlists', '${state.id}']);
      },
      updateStateBeforePop: (context, route, dynamic result, state) => null,
    );
  }
}

class RootStackMarker extends StackMarker<Wishlist?> {}
