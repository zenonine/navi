import 'package:flutter/material.dart';

import 'index.dart';

class BooksPagelet extends StatelessWidget {
  BooksPagelet({Key? key}) : super(key: key);

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: books
                        .map((book) => ListTile(
                            title: Text(book.title),
                            subtitle: Text(book.author)))
                        .toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
