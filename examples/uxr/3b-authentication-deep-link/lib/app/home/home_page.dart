import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class HomePage extends StatelessWidget {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          if (_authService.authenticated)
            TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () => _authService.logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
            )
          else
            TextButton.icon(
              style: TextButton.styleFrom(
                primary: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
              onPressed: () {
                context.stack<RootStack>().state = RootStackPage.auth;
              },
              icon: const Icon(Icons.login),
              label: const Text('Login'),
            ),
        ],
      ),
      body: Center(
          child: ElevatedButton(
              onPressed: () {
                context.stack<RootStack>().state = RootStackPage.wishlist;
              },
              child: const Text('Wishlist'))),
    );
  }
}
