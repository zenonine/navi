import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class AuthStack extends PageStack<void> {
  AuthStack() : super(initialState: null);

  @override
  List<Page> pages(BuildContext context) {
    return [
      MaterialPage<dynamic>(
        key: const ValueKey('Auth'),
        child: AuthPage(),
      )
    ];
  }
}
