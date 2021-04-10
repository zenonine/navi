import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class BookPagelet extends StatelessWidget {
  const BookPagelet({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              book.title,
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () {
                context.navi.to(['authors', '${book.author.id}']);
              },
              child: Text(book.author.name),
            )
          ],
        ),
      ),
    );
  }
}
