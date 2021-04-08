import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class NaviPage {
  const NaviPage({
    this.key,
    required this.child,
    required this.pageBuilder,
  });

  NaviPage.material({
    LocalKey? key,
    required Widget child,
  }) : this(
          key: key,
          child: child,
          pageBuilder: (key, child) => MaterialPage<dynamic>(
            key: key,
            child: child,
          ),
        );

  NaviPage.cupertino({
    LocalKey? key,
    required Widget child,
  }) : this(
          key: key,
          child: child,
          pageBuilder: (key, child) => CupertinoPage<dynamic>(
            key: key,
            child: child,
          ),
        );

  final LocalKey? key;
  final Widget child;
  final PageBuilder pageBuilder;
}
