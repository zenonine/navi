import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class AuthStack extends PageStack<User> {
  AuthStack() : super(initialState: User());

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
