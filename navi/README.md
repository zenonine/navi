Navi - A declarative navigation framework for Flutter, based on Navigator 2.0.

Note that, imperative navigation API is also supported as an extra layer beyond the declarative API at lower layer.

<a href="https://pub.dev/packages/navi"><img src="https://img.shields.io/pub/v/navi.svg" alt="pub package"></a>

# Quick Setup

To use the library, `RouteStack` widget is everything you need to learn!

```
void main() {
  runApp(App());
}

class App extends StatelessWidget {
  final _informationParser = NaviInformationParser();
  final _routerDelegate = NaviRouterDelegate.material(rootPage: RootPage());

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
class YourStackState {}

class RootPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // you can nest RouteStack under another RouteStack without limitation to create nested routes
    return RouteStack<YourStackState>(
      // mandatory properties
      pages: (context, state) => [], // which pages to show for current state
      updateStateOnNewRoute: (routeInfo) => YourStackState(), // If user enter a URL manually, what is the initial state for the given URL

      // optional properties
      updateRouteOnNewState: (state) => const RouteInfo(), // what is the URL for current state
      updateStateBeforePop: (context, route, dynamic result, state) => YourStackState(), // what is the state when user click in-app back button / pop()
      marker: const StackMarker<YourStackState>(), // if you need to access your stack in a deeper child widget
      controller: StackController<YourStackState>(), // if you need to control this stack in RootPage widget
    );
  }
}
```

# [Examples](https://github.com/zenonine/navi/tree/master/examples)

* [Deep Linking - Path Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/1-deep-linking-path-parameters)
* [Deep Linking - Query Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/2-deep-linking-query-parameters)
* [Login/Logout/Sign-up Routing](https://github.com/zenonine/navi/tree/master/examples/uxr/3-sign-in-routing)
* [Skipping Stacks](https://github.com/zenonine/navi/tree/master/examples/uxr/5-skipping-stacks)
* [Dynamic Linking](https://github.com/zenonine/navi/tree/master/examples/uxr/6-dynamic-linking)
* [Bookstore](https://github.com/zenonine/navi/tree/master/examples/bookstore-simple)

# Architecture layers

| Packages                  | Layers                         | Plan                                                        | Explanation                                                   |
| :-----------------------: | :----------------------------: | :---------------------------------------------------------- | :------------------------------------------------------------ |
| Navi                      | Code Generator                 | After release 1.0                                           | Generate boilerplate code                                     |
| Navi                      | Configurator                   | Before release 1.0 if possible, otherwise after release 1.0 | Comparable to URL mapping approaches like Angular or Vue      |
| Navi                      | Imperative API                 | Before release 1.0                                          | Useful when declarative is not needed                         |
| Navi                      | **High-level declarative API** | **WIP**                                                     | Simple and easy to use yet keep the powerful of Navigator 2.0 |
| Flutter SDK Navigator 2.0 | Low-level declarative API      | N/A                                                         | Too complex and difficult to use                              |

# Declarative navigation

If you love Flutter, you would love [declarative UI](https://flutter.dev/docs/get-started/flutter-for/declarative).

Declarative navigation is similar as it allows you to describe your navigation system by the current UI state. Updating
your current UI state to tell Navi figures out where to navigate to.

Using declarative navigation is only powerful if

* the provided API is simple enough
* your application is reasonable split into manageable domains (or stacks in this library)

An example, where declarative shines is to manage a chain of pages to complete a single task (ex. registration form with
multiple pages). Using imperative approach is usually more difficult in this case.

Chain of pages scenario (also known as flow of pages) is just one case, you can use with Navi. This library is
definitely much more than that.

# Introduction and Milestones

The goal of **Navi** package is to create a **friendly declarative** navigation API for Flutter projects. It depends
heavily on Navigator 2.0.

* Milestone 1 (WIP)
  * Easy to learn, simple to maintain and organize application code based on split domains.
  * Keep boilerplate code at reasonable level. More optimization will be in next milestones.
  * Flexible: easily integrate with other architectural elements, especially, state management
    (ex. [Bloc](https://pub.dev/packages/bloc)) and dependency injection (ex. [get_it](https://pub.dev/packages/get_it).
  * Modularization
    * friendly to projects, which require splitting into multiple teams
    * each stack can be considered as an isolated module
    * stacks should be reusable in other stacks
    * developers can freely organize stacks in the way they want
  * Imperative navigation API is also supported.
* Milestone 2 (Plan: before release 1.0)
  * Optimize to remove boilerplate code for common/general scenarios
  * Optimize performance
  * Test coverage at least 90%
  * Evaluate edge cases
* Milestone 3 (Plan: before release 1.0 if possible, otherwise after release 1.0)
  * Implement a configurator, which fits to common scenarios. For more control, please use the high level declarative
    API.
* Milestone 4 (Plan: after release 1.0)
  * Implement code generator to even remove more boilerplate code

Please see this [full source code example](https://github.com/zenonine/navi/tree/master/examples) app.

# Nested stack

Because `RouteStack` is just a normal widget, you only need to use this widget to build nested stacks like you would do
with other widgets.

It's commonly used together
with [`BottomNavigationBar`](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html), but it will
definitely work with other components and designs.

If you want to keep state of nested stacks, you could
use [`IndexedStack`](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html).

For example, you have a bookstore with 2 pages: book list page and book page. Their URLs are `/books` and `/books/:id`.

In book page, you split the content into 3 tabs: overview, details and reviews. Their URLs are `/books/:id/overview`
, `/books/:id/details`, `/books/:id/reviews`.

In this case, you can create 2 stacks:

```
// This stack could be your root stack, maybe directly under your MaterialApp.
RouteStack(
  pages: (context, state) => [BookListPage(), BookPage()],
  updateRouteOnNewState: (state) {
    // map /books to BookListPage()
    // map /books/:id to BookPage()
  },
);


// This stack is a child widget of BookPage widget
RouteStack(
  pages: (context, state) => [BookOverviewPage(), BookDetailsPage(), BookReviewsPage()],
  updateRouteOnNewState: (state) {
    // map /overview to BookOverviewPage()
    // map /details to BookDetailsPage()
    // map /reviews to BookReviewsPage()
  },
)
```

The main idea is that, in the nested stack, you don't need to know the URL of parent stack.

Navi will help you merge the current URL in parent stack (ex. `/books/1`) and nested stack (ex. `/overview`) to generate
the final URL for you (ex. `/books/1/overview`).

You can have unlimited nested stacks as deep as you want and each stack manage only the URL part it should know.

Please see more in
this [example](https://github.com/zenonine/navi/blob/master/examples/bookstore-simple/lib/app/widgets/book_page.dart).

# TODO: Flatten list of stacks to a single stack

```
FlatRouteStack(
  children: [
    RouteStack(),
    RouteStack(),
    // ...
  ]
)
```

`FlatRouteStack` merges all pages of child stacks into a single stack.

The difference is that, URL of nested stacks are dependent, but URLs of stacks in `FlatRouteStack` are independent.

# How to navigate?

* Implemented
  * `context.navi.stack(ProductStackMarker()).state = 1`: navigate to product stack with productId = 1.
  * `context.navi.byUrl('/products/1')`: navigate to absolute URL (begin with a slash)

* TODOs:
  * `context.navi.byUrl('details')`: navigate to relative URL
  * `context.navi.pop()`: a shortcut of `Navigator.of(context).pop()`
  * `context.navi.stack(ProductStackMarker()).state.pop()`:
    move up one level at the specified stack or exit if there's no upper page.
  * `context.navi.back()`: move back to the previous page in the history.

# Sync URL and stack state

You will have 2 options to choose:

* Don't use code generator: path parameters and query parameters are provided to you as `String`. You need to manually
  validate and convert to your types.
* TODO: Use code generator to generate typesafe interfaces, which allow you to sync path parameters and query parameters
  to your variable in the defined types automatically.

# TODO: Manipulation of the chronological history Stack

Browser back button and system back button should behave the same way, according
to [material navigation guideline](https://material.io/design/navigation/understanding-navigation.html#reverse-navigation)

# Contributing to Navi

First of all, thank you a lot to visit Navi project!

* Everyone is welcome
  * to file issues on GitHub
  * to help people asking for help
  * click the Github star/watch button
  * click the [Pub.dev](https://pub.dev/packages/navi) like button
  * to contribute code via pull requests

The more people interested in the project, the more motivation I will have to speed up the development.

Enjoy to use Navi!
