import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class RootStack extends PageStack<void> {
  RootStack() : super(initialState: null);

  @override
  List<Page> pages(BuildContext context) {
    return [
      MaterialPage<dynamic>(
        key: const ValueKey('Root'),
        child: RootPage(),
      )
    ];
  }
}
