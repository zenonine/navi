import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  final _authService = authService;
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: _authService.authenticated
          ? StackOutlet(stack: HomeStack())
          : StackOutlet(stack: AuthStack()),
    );
  }
}
