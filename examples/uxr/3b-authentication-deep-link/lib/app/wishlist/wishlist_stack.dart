import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class WishlistStack extends RouteStack<Wishlist?> {
  WishlistStack() : super(initialState: null);

  @override
  List<Page> pages(BuildContext context) {
    return [
      const MaterialPage<dynamic>(
        key: ValueKey('Wishlists'),
        child: WishlistPage(),
      ),
      if (state != null)
        MaterialPage<dynamic>(
          key: ValueKey('Wishlist-${state!.id}'),
          child: WishlistPage(state),
        ),
    ];
  }

  @override
  RouteInfo get routeInfo {
    if (state != null) {
      return RouteInfo(pathSegments: ['${state!.id}']);
    }

    return const RouteInfo();
  }

  @override
  void beforePop(BuildContext context, Route route, dynamic result) {
    state = null;
  }

  @override
  Wishlist? routeInfoToState(RouteInfo routeInfo) {
    final id = routeInfo.pathSegments.firstOrNull?.trim();
    if (id != null) {
      return wishlists.firstWhereOrNull((w) => w.id.toString() == id);
    }
  }
}
