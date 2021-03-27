import 'package:flutter/material.dart';

import 'index.dart';

class BooksSearchResultsPage extends StatelessWidget {
  const BooksSearchResultsPage({required this.term});

  final String term;

  @override
  Widget build(BuildContext context) {
    final matchedBooks = books.where((book) =>
        book.title.toLowerCase().contains(term.toLowerCase()) ||
        book.author.toLowerCase().contains(term.toLowerCase()));
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: Text('Showing results for "$term"'),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: matchedBooks.isEmpty
              ? const Text('No books found!')
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: ListView(
                    children: matchedBooks
                        .map((book) => ListTile(
                              title: Text(book.title),
                              subtitle: Text(book.author),
                            ))
                        .toList(),
                  ),
                ),
        ),
      ),
    );
  }
}
