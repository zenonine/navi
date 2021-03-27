import 'package:flutter/material.dart';

import 'index.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({this.onSearchStart});

  final ValueChanged<String>? onSearchStart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 300),
            child: _SearchField(onSearchStart: onSearchStart),
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
                    children: books
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
  const _SearchField({this.onSearchStart});

  final ValueChanged<String>? onSearchStart;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: (term) {
        onSearchStart?.call(term);
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
