import 'package:flutter/material.dart';

import '../index.dart';

class BooksPage extends StatelessWidget {
  BooksPage({Key? key, this.onSelectBook}) : super(key: key);

  final ValueChanged<Book>? onSelectBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Note that, animation duration is currently set to 3 times slower'
              ' to easily recognize page transition.',
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
