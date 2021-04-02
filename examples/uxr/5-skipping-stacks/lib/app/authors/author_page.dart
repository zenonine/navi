import 'package:flutter/material.dart';

import '../index.dart';

class AuthorPage extends StatelessWidget {
  const AuthorPage({required this.author});

  final Author author;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Author'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(author.name),
          ],
        ),
      ),
    );
  }
}
