import 'package:flutter/material.dart';

import 'index.dart';

class BooksPagelet extends StatelessWidget {
  const BooksPagelet({Key? key, required this.onSelectBook}) : super(key: key);

  final ValueChanged<Book> onSelectBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
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
                              subtitle: Text(book.author),
                              onTap: () {
                                // Option 1: update state
                                onSelectBook(book);

                                // Option 2: navigate to a specific URL (absolute or relative)
                                // context.navi.to(['books', '${book.id}']);
                                // context.navi.relativeTo(['${book.id}']);
                              },
                            ))
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Note: 3x slow motion to recognize page transition.',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
