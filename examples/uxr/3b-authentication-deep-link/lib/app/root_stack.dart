import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

enum RootStackPage { auth, home, wishlist }

class RootStack extends RouteStack<RootStackPage> {
  RootStack() : super(initialState: RootStackPage.home) {
    _authServiceListener = () {
      if (!_authService.authenticated) {
        state = RootStackPage.auth;
      }

      // TODO: How to redirect to previous page instead of specific page?
      state = RootStackPage.home;
    };
    _authService.addListener(_authServiceListener);
  }

  final _authService = AuthService();
  late final VoidCallback _authServiceListener;

  @override
  void dispose() {
    _authService.removeListener(_authServiceListener);
    super.dispose();
  }

  @override
  List<Page> pages(BuildContext context) {
    var rootPage = MaterialPage<dynamic>(
      key: const ValueKey('Home'),
      child: HomePage(),
    );

    switch (state) {
      case RootStackPage.auth:
        rootPage = MaterialPage<dynamic>(
          key: const ValueKey('Auth'),
          child: StackOutlet(stack: AuthStack()),
        );
        break;
      case RootStackPage.wishlist:
        rootPage = MaterialPage<dynamic>(
          key: const ValueKey('Wishlist'),
          child: StackOutlet(stack: WishlistStack()),
        );
        break;
      default:
        break;
    }

    return [rootPage];
  }

  @override
  void beforePop(BuildContext context, Route<dynamic> route, dynamic result) {}

  @override
  RootStackPage beforeSetState(RootStackPage newState) {
    if (newState == RootStackPage.wishlist && !_authService.authenticated) {
      // Redirect to auth if access protected page
      return RootStackPage.auth;
    }

    return super.beforeSetState(newState);
  }

  @override
  RouteInfo get routeInfo {
    switch (state) {
      case RootStackPage.auth:
        return const RouteInfo(pathSegments: ['auth']);
      case RootStackPage.wishlist:
        return const RouteInfo(pathSegments: ['wishlist']);
      default:
        return const RouteInfo();
    }
  }

  @override
  RootStackPage routeInfoToState(RouteInfo routeInfo) {
    final page = routeInfo.pathSegments.firstOrNull;
    if (page == 'auth') {
      return RootStackPage.auth;
    } else if (page == 'wishlist') {
      return RootStackPage.wishlist;
    }
    return RootStackPage.home;
  }
}
