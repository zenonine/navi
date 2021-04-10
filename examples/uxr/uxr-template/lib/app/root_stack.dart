import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

class RootStack extends StatefulWidget {
  @override
  _RootStackState createState() => _RootStackState();
}

class _RootStackState extends State<RootStack> with NaviRouteMixin<RootStack> {
  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Root'),
          child: const Center(
            child: Text('Root Pagelet'),
          ),
        )
      ],
    );
  }
}
