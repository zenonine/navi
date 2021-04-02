import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class BookPage extends StatelessWidget {
  const BookPage({required this.book});

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
            Text(book.title),
            ElevatedButton(
              onPressed: () {
                // TODO: option 1a: navigate by absolute URL
                context.navi.byUrl('/authors/${book.author.id}');

                // TODO: option 1b: navigate by relative URL
                // context.navi.byUrl('../../authors/${book.author.id}');

                // TODO: option 2: typesafe navigate by state tree (or state chain)
                // context.navi.stack(RootStackMarker()).state =
                //     RootStackId.authors;
                // context.navi.stack(AuthorsStackMarker()).state = book.author;
              },
              child: Text(book.author.name),
            )
          ],
        ),
      ),
    );
  }
}
