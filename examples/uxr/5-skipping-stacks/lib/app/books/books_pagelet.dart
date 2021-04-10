import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

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
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: ElevatedButton(
                      onPressed: () {
                        context.navi.to(['authors']);
                      },
                      child: const Text('Authors')),
                ),
                Expanded(
                  child: ListView(
                    children: books
                        .map((book) => ListTile(
                              title: Text(book.title),
                              subtitle: Text(book.author.name),
                              onTap: () => onSelectBook(book),
                            ))
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
