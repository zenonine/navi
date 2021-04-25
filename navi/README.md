Navi - A declarative navigation framework for Flutter, based on Navigator 2.0.

If you love Flutter, you would love [declarative UI](https://flutter.dev/docs/get-started/flutter-for/declarative) and
therefore declarative navigation.

Note that, imperative navigation API is also supported as an extra layer beyond the declarative API at lower layer.

<a href="https://pub.dev/packages/navi"><img src="https://img.shields.io/pub/v/navi.svg" alt="pub package"></a>

* [Quick example](#quick-example)
* [More examples](#more-examples)
* [Architecture layers](#architecture-layers)
* [Declarative navigation](#declarative-navigation)
* [Navigate to a new route](#navigate-to-a-new-route)
* [Nested stack](#nested-stack)
* [Milestones](#milestones)
* [Contributing to Navi](#contributing-to-navi)

# Quick example

To use the library, controlling `NaviStack` widget is everything you need to learn!

Below is an app with 2 pages:

* `/` shows list of books
* `/:id` shows a book.

```
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
          // BooksPagelet is a normal widget, which shows list of books
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
            // BookPagelet is a normal widget, which shows a book
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

# More examples

[All examples](https://github.com/zenonine/navi/tree/master/examples)

* [Deep Linking - Path Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/1-deep-linking-path-parameters)
* [Deep Linking - Query Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/2-deep-linking-query-parameters)
* [Login/Logout/Sign-up Routing](https://github.com/zenonine/navi/tree/master/examples/uxr/3-sign-in-routing)
* [Skipping Stacks](https://github.com/zenonine/navi/tree/master/examples/uxr/5-skipping-stacks)
* [Dynamic Linking](https://github.com/zenonine/navi/tree/master/examples/uxr/6-dynamic-linking)
* [Nested Routing - Bottom Navigation Bar - without Keeping State](https://github.com/zenonine/navi/tree/master/examples/bottom-navigation-bar-without-keeping-state)
* [Nested Routing - Bottom Navigation Bar - Keeping State](https://github.com/zenonine/navi/tree/master/examples/bottom-navigation-bar-keeping-state)
* [Nested Routing - Tab Bar - Keeping State](https://github.com/zenonine/navi/tree/master/examples/tab-bar-keeping-state)

# Architecture layers

| Packages                  | Layers                         | Plan                                                        | Explanation                                                   |
| :-----------------------: | :----------------------------: | :---------------------------------------------------------- | :------------------------------------------------------------ |
| Navi                      | Code Generator                 | After release 1.0                                           | Generate boilerplate code                                     |
| Navi                      | Configurator                   | Before release 1.0 if possible, otherwise after release 1.0 | Comparable to URL mapping approaches like Angular or Vue      |
| Navi                      | Imperative API                 | Before release 1.0                                          | Useful when declarative is not needed                         |
| Navi                      | **High-level declarative API** | **WIP**                                                     | Simple and easy to use yet keep the powerful of Navigator 2.0 |
| Flutter SDK Navigator 2.0 | Low-level declarative API      | N/A                                                         | Too complex and difficult to use                              |

# Declarative navigation

Declarative navigation is similar to [declarative UI](https://flutter.dev/docs/get-started/flutter-for/declarative) as
it allows you to describe your navigation system by the current UI state. Updating your current UI state to tell Navi
figures out where to navigate to.

Using declarative navigation is only powerful if

* the provided API is simple enough
* your application is reasonable split into manageable domains (or stacks in this library)

An example, where declarative shines is to manage a chain of pages to complete a single task (ex. registration form with
multiple pages). Using imperative approach is usually more difficult in this case.

Chain of pages scenario (also known as flow of pages) is just one case, you can use with Navi. This library is
definitely much more than that.

# Navigate to a new route

* `context.navi.to(['products', '1'])`: navigate to absolute URL `/products/1`.
* `context.navi.relativeTo(['details'])`: navigate to relative URL. If current URL is `products/1`, the destination URL
  will be `/products/1/details`.

Beside the API to navigate by URL, you can also update your widget state (or multiple widget states) to rebuild the
widgets. It will rebuild the needed stacks and update URL accordingly.

* TODOs:
  * `context.navi.stack(ProductsStackMarker()).to(['2', 'overview'])`: navigate to relative URL starting from current
    URL of the given stack. If current URL is `my/path/to/products/1/details` and `ProductsStack` URL
    is `my/path/to/products`, the destination URL will be `my/path/to/products/2/overview`.
  * `context.navi.pop()`: a shortcut of `Navigator.of(context).pop()`
  * `context.navi.back()`: move back to the previous page in the history.

# Nested stack

Because `NaviStack` is just a normal widget, you only need to use this widget to build nested stacks like you would do
with other widgets.

For example, you have a bookstore with 2 pages: book list page and book page. Their URLs are `/books` and `/books/:id`.

In book page, you split the content into 2 tabs: overview and details. Their URLs are `/books/:id/overview`
, `/books/:id/details`.

In this case, you can create 2 stacks:

```
// This stack could be your RootStack, maybe directly under your MaterialApp.
NaviStack(
  pages: (context) => [
    NaviPage.material(
      route: NaviRoute(path: ['books']),
      child: BooksPagelet(),
    ),
    NaviPage.material(
      route: NaviRoute(path: ['books', book.id]),
      child: BookStack(),
    ),
  ],
);


// In BookStack widget, you build another stack
NaviStack(
  pages: (context) => [
    if (pageId == 'overview') NaviPage.material(
      route: NaviRoute(path: ['overview']),
      child: BookOverviewPage(),
    ),
    if (pageId == 'details') NaviPage.material(
      route: NaviRoute(path: ['details']),
      child: BookDetailsPage(),
    ),
  ],
);
```

The main idea is that, in the nested stack `BookStack`, you don't need to know the URL of parent stack (`RootStack` in
this case).

Navi will help you merge the current URL in parent stack (ex. `/books/1`) and nested stack (ex. `/overview`) to generate
the final URL for you (ex. `/books/1/overview`).

You can have unlimited nested stacks as deep as you want and each stack manage only the URL part it should know.

It's commonly used together
with [`BottomNavigationBar`](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html)
and [`TabBar`](https://api.flutter.dev/flutter/material/TabBar-class.html), but it will definitely work with other
components and designs.

If you want to keep state of nested stacks in `BottomNavigationBar`, you could
use [`IndexedStack`](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html).

If you want to keep state of nested stacks in `TabBar`, you could
use [`AutomaticKeepAliveClientMixin`](https://api.flutter.dev/flutter/widgets/AutomaticKeepAliveClientMixin-mixin.html).

When use with tabs and keeping state of tabs, you keep multiple stack branches in the widget tree. In this case, please
make sure to set `active: false` to inactive stacks in inactive tabs. Only the stack in the current tab
set `active: true`. The active stack is responsible to report the correct final URL to browser address bar, while
inactive stacks don't.

Please see more in [Examples](https://github.com/zenonine/navi/tree/master/examples).

# Custom page

To use default material and cupertino pages, you can use shortcuts:

* `NaviRouterDelegate.material()`
* `NaviRouterDelegate.cupertino()`
* `NaviPage.material()`
* `NaviPage.cupertino()`

To use a custom page, use the default constructors:

* `NaviRouterDelegate(rootPage: () => YourCustomPage())`
* `NaviPage(pageBuilder: (key, child) => YourCustomPage())`

# TODO: Flatten list of stacks to a single stack

```
FlatRouteStack(
  children: [
    NaviStack(),
    NaviStack(),
    // ...
  ]
)
```

`FlatRouteStack` merges all pages of child stacks into a single stack.

The difference is that, URL of nested stacks are dependent, but URLs of stacks in `FlatRouteStack` are independent.

# TODO: Manipulation of the chronological history Stack

Browser back button and system back button should behave the same way, according
to [material navigation guideline](https://material.io/design/navigation/understanding-navigation.html#reverse-navigation)

# Milestones

The goal of **Navi** package is to create a **friendly declarative** navigation API for Flutter projects. It depends
heavily on Navigator 2.0.

* Milestone 1 (WIP)
  * Easy to learn, simple to maintain and organize application code based on split domains.
  * Keep boilerplate code at reasonable level. More optimization will be in next milestones.
  * Flexible: easily integrate with other architectural elements, especially, state management
    (ex. [Bloc](https://pub.dev/packages/bloc)) and dependency injection (ex. [get_it](https://pub.dev/packages/get_it))
    .
  * Modularization
    * friendly to projects, which require splitting into multiple teams
    * each stack can be considered as an isolated module
  * Imperative navigation API is also supported.
* Milestone 2 (Plan: before release 1.0)
  * Optimize to remove boilerplate code for common/general scenarios
  * Optimize performance
  * Test coverage at least 90%
  * Evaluate edge cases
* Milestone 3 (Plan: before release 1.0 if possible, otherwise after release 1.0)
  * Implement a configurator, which fits to common scenarios. For more flexibility, use the high level declarative API.
* Milestone 4 (Plan: after release 1.0)
  * Implement code generator to even remove more boilerplate code

# Contributing to Navi

First of all, thank you a lot to visit Navi project!

* Everyone is welcome
  * to file issues on GitHub
  * to help people asking for help
  * click the GitHub star/watch button
  * click the [Pub.dev](https://pub.dev/packages/navi) like button
  * to contribute code via pull requests

The more people interested in the project, the more motivation I will have to speed up the development.

Enjoy to use Navi!
