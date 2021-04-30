# [All examples](https://github.com/zenonine/navi/blob/master/examples)

* [Deep Linking - Path Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/1-deep-linking-path-parameters)
* [Deep Linking - Query Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/2-deep-linking-query-parameters)
* [Login/Logout/Sign-up Routing](https://github.com/zenonine/navi/tree/master/examples/uxr/3-sign-in-routing)
* [Skipping Stacks](https://github.com/zenonine/navi/tree/master/examples/uxr/5-skipping-stacks)
* [Dynamic Linking](https://github.com/zenonine/navi/tree/master/examples/uxr/6-dynamic-linking)
* [Nested Routing - Bottom Navigation Bar - without Keeping State](https://github.com/zenonine/navi/tree/master/examples/bottom-navigation-bar-without-keeping-state)
* [Nested Routing - Bottom Navigation Bar - Keeping State](https://github.com/zenonine/navi/tree/master/examples/bottom-navigation-bar-keeping-state)
* [Nested Routing - Tab Bar - Keeping State](https://github.com/zenonine/navi/tree/master/examples/tab-bar-keeping-state)

# Quick example

Below is an app with 2 pages:

* `/` shows list of books
* `/:id` shows a book.

```
dependencies:
  navi: any
```

```
import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final _informationParser = NaviInformationParser();
  final _routerDelegate = NaviRouterDelegate.material(child: BooksStack());

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: _informationParser,
      routerDelegate: _routerDelegate,
    );
  }
}
```

```
// your BooksStack widget state should use NaviRouteMixin in order to receive notification on route change
class _BooksStackState extends State<BooksStack> with NaviRouteMixin<BooksStack> {
  Book? _selectedBook;

  @override
  void onNewRoute(NaviRoute unprocessedRoute) {
    // if route changes (ex. browser address bar or deeplink), convert route to your state and rebuild the widget (stack)
    final bookId = int.tryParse(unprocessedRoute.pathSegmentAt(0) ?? '');
    _selectedBook = getBookById(bookId); // ex. get from database
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // you can nest NaviStack under another NaviStack without limitation to create nested routes
    // see 'Nested stack' secion below
    return NaviStack(
      pages: (context) => [
        NaviPage.material(
          key: const ValueKey('Books'),
          // without route property, url is '/' by default
          // BooksPagelet is your widget, which shows list of books
          child: BooksPagelet(
            // you can update state of BooksStack widget to navigate
            // or you can use context.navi to navigate inside BooksPagelet (see 'Navigate to a new route' section below)
            onSelectBook: (book) => setState(() {
              _selectedBook = book;
            }),
          ),
        ),
        if (_selectedBook != null)
          NaviPage.material(
            key: ValueKey(_selectedBook),
            route: NaviRoute(path: ['${_selectedBook!.id}']), // url is '/:id'
            // BookPagelet is your widget, which shows a book
            child: BookPagelet(book: _selectedBook!),
          ),
      ],
      onPopPage: (context, route, dynamic result) {
        // update state when pop
        if (_selectedBook != null) {
          setState(() {
            _selectedBook = null;
          });
        }
      },
    );
  }
}
```