import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:navi/navi.dart';

import '../../mocks/mocks.dart';

class BooksStack extends StatefulWidget {
  @override
  _BooksStackState createState() => _BooksStackState();
}

class _BooksStackState extends State<BooksStack>
    with NaviRouteMixin<BooksStack> {
  String? filter;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    filter = unprocessedRoute.queryParams['filter']?.firstOrNull?.trim();
  }

  @override
  Widget build(BuildContext context) {
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Books'),
          route: NaviRoute(
              queryParams: filter?.isNotEmpty == true
                  ? {
                      'filter': [filter!]
                    }
                  : {}),
          child: BooksPagelet(filter: filter),
        ),
      ],
    );
  }
}

class BooksPagelet extends StatelessWidget {
  BooksPagelet({this.filter});

  final String? filter;
  late final _controller = TextEditingController(text: filter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          onSubmitted: (filter) {
            context.navi.relativeTo([], queryParams: {
              'filter': [filter]
            });
          },
        ),
      ),
      body: ListView(
        children: [
          ...bookstoreService.getBooks(filter).map(
                (book) => ListTile(
                  title: Text('Book ${book.id}'),
                ),
              )
        ],
      ),
    );
  }
}

void main() {
  setUpAll(() {
    setupLogger();
  });

  tearDown(() {
    reset(mockLogger);
  });
}
