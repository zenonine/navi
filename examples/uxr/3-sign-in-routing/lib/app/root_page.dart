import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _authService = AuthService();
  late final VoidCallback _authListener;

  final _stackController = StackController<bool>();

  @override
  void initState() {
    super.initState();

    _authListener = () => _stackController.state = _authService.authenticated;

    _authService.addListener(_authListener);
  }

  @override
  void dispose() {
    _authService.removeListener(_authListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: how to navigate to requested page, instead of home?

    return RouteStack<bool>(
      controller: _stackController,
      pages: (context, state) => [
        // true means authenticated
        if (state)
          MaterialPage<dynamic>(
            key: const ValueKey('Home'),
            child: BooksStack(),
          )
        else
          MaterialPage<dynamic>(
            key: const ValueKey('Auth'),
            child: AuthPage(),
          ),
      ],
      updateStateOnNewRoute: (routeInfo) => _authService.authenticated,
      updateRouteOnNewState: (state) =>
          RouteInfo(pathSegments: state ? [] : ['auth']),
    );
  }
}
