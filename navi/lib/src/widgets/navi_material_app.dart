import 'package:flutter/material.dart';

class NaviMaterialApp extends StatefulWidget {
  NaviMaterialApp({
    Key? key,
    this.title = '',
  }) : super(key: key);

  final String title;

  @override
  _NaviMaterialAppState createState() => _NaviMaterialAppState();
}

class _NaviMaterialAppState extends State<NaviMaterialApp> {
  @override
  Widget build(BuildContext context) {
    // TODO: MaterialApp.router()
    return MaterialApp(
      title: widget.title,
      home: Center(
        child: Text(widget.title),
      ),
    );
  }
}