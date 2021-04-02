import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({Key? key}) : super(key: key);

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
                              onTap: () => context.navi
                                  .stack(BookStackMarker())
                                  .state = book,
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
