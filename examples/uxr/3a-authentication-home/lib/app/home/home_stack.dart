import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class HomeStack extends RouteStack<void> {
  HomeStack() : super(initialState: null);

  @override
  List<Page> pages(BuildContext context) {
    return [
      MaterialPage<dynamic>(
        key: const ValueKey('Home'),
        child: HomePage(),
      )
    ];
  }
}
