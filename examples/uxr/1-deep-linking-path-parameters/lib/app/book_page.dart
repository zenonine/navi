import 'package:flutter/material.dart';

import 'index.dart';

class BookPage extends StatelessWidget {
  const BookPage({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(book.title),
            Text(book.author),
          ],
        ),
      ),
    );
  }
}
