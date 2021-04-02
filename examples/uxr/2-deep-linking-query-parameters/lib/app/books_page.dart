import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import 'index.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({this.searchTerm});

  final String? searchTerm;

  @override
  Widget build(BuildContext context) {
    final matchedBooks = searchTerm?.trim().isNotEmpty == true
        ? books.where((book) =>
            book.title.toLowerCase().contains(searchTerm!.toLowerCase()) ||
            book.author.toLowerCase().contains(searchTerm!.toLowerCase()))
        : books;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: _SearchField(searchTerm ?? ''),
          ),
        ),
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
                    children: matchedBooks
                        .map((book) => ListTile(
                              title: Text(book.title),
                              subtitle: Text(book.author),
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

class _SearchField extends StatelessWidget {
  _SearchField(String initialValue)
      : _controller = TextEditingController(text: initialValue);

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onSubmitted: (searchTerm) {
        context.navi.stack(BookStackMarker()).state = searchTerm;
      },
      style: Theme.of(context).accentTextTheme.headline6,
      decoration: InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        suffixIcon: Icon(
          Icons.search,
          color: Theme.of(context).accentIconTheme.color,
        ),
        hintText: 'Search books',
        hintStyle: Theme.of(context).accentTextTheme.headline6,
      ),
    );
  }
}
