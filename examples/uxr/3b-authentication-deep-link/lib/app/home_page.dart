import 'package:flutter/material.dart';

import 'index.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      body: const Center(child: Text('Home')),
    );
  }
}
