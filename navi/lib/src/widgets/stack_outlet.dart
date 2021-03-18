import 'package:flutter/material.dart';

import '../main.dart';

class StackOutlet extends StatefulWidget {
  StackOutlet({required this.stack});

  final RouteStack stack;

  @override
  _StackOutletState createState() => _StackOutletState();
}

class _StackOutletState extends State<StackOutlet> {
  @override
  Widget build(BuildContext context) {
    // TODO: build nested route
    return Center(
      child: Text('Navi Example'),
    );
  }
}
