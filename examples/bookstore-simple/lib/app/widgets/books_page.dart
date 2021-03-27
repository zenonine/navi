import 'package:flutter/material.dart';

import '../index.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key, this.onSelectBook}) : super(key: key);

  final ValueChanged<Book>? onSelectBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Note: 3x slow motion to recognize page transition.',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Expanded(
            child: ListView(
              children: books
                  .map((book) => ListTile(
                        title: Text(book.title),
                        subtitle: Text(book.author),
                        onTap: () => onSelectBook?.call(book),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
