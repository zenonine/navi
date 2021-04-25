import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../index.dart';

class AuthorsPagelet extends StatelessWidget {
  const AuthorsPagelet({Key? key, required this.onSelectAuthor}) : super(key: key);

  final ValueChanged<Author> onSelectAuthor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Authors'),
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
                        context.navi.to(['books']);
                      },
                      child: const Text('Bookshelf')),
                ),
                Expanded(
                  child: ListView(
                    children: authors
                        .map((author) => ListTile(
                              title: Text(author.name),
                              onTap: () => onSelectAuthor(author),
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
