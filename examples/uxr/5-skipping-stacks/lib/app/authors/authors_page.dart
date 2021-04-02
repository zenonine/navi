import 'package:flutter/material.dart';
import 'package:navi/navi.dart';
import 'package:navi_uxr_example/app/root_page.dart';

import '../index.dart';

class AuthorsPage extends StatelessWidget {
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
                        context.navi.stack(RootStackMarker()).state =
                            RootStackId.books;
                      },
                      child: const Text('Bookshelf')),
                ),
                Expanded(
                  child: ListView(
                    children: authors
                        .map((author) => ListTile(
                              title: Text(author.name),
                              onTap: () {
                                context.navi.stack(AuthorsStackMarker()).state =
                                    author;
                              },
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
