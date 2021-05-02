import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootStack extends StatefulWidget {
  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  final _authService = AuthService();
  late final VoidCallback _authListener;

  @override
  void initState() {
    super.initState();

    _authListener = () => setState(() {});

    _authService.addListener(_authListener);
  }

  @override
  void dispose() {
    _authService.removeListener(_authListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        if (_authService.authenticated)
          NaviPage.material(
            key: const ValueKey('Home'),
            child: BooksStack(),
          )
        else
          NaviPage.material(
            key: const ValueKey('Auth'),
            route: const NaviRoute(path: ['auth']),
            child: AuthPagelet(),
          ),
      ],
    );
  }
}
