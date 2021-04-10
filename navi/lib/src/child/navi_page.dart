import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class NaviPage {
  const NaviPage({
    required this.key,
    this.route = const NaviRoute(),
    required this.child,
    required this.pageBuilder,
  });

  NaviPage.material({
    required LocalKey key,
    NaviRoute route = const NaviRoute(),
    required Widget child,
  }) : this(
          key: key,
          route: route,
          child: child,
          pageBuilder: (key, child) => MaterialPage<dynamic>(
            key: key,
            child: child,
          ),
        );

  NaviPage.cupertino({
    required LocalKey key,
    NaviRoute route = const NaviRoute(),
    required Widget child,
  }) : this(
          key: key,
          route: route,
          child: child,
          pageBuilder: (key, child) => CupertinoPage<dynamic>(
            key: key,
            child: child,
          ),
        );

  final LocalKey key;
  final NaviRoute route;
  final Widget child;
  final PageBuilder pageBuilder;
}
