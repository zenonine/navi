import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class HomePagelet extends StatefulWidget {
  @override
  _HomePageletState createState() => _HomePageletState();
}

class _HomePageletState extends State<HomePagelet> {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              primary: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: () => _authService.logout(),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
        ],
      ),
      body: Center(
          child: ElevatedButton(
        onPressed: () {
          context.navi.to(['books']);
        },
        child: const Text('Bookshelf'),
      )),
    );
  }
}
