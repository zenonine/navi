Navi - A declarative navigation framework for Flutter, based on Navigator 2.0.

Note that, imperative navigation API is also supported as an extra layer beyond the declarative API at lower layer.

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
      pages: (context, state) => [],
      updateStateOnNewRoute: (routeInfo) => YourStackState(),
      
      // optional properties
      updateRouteOnNewState: (state) => const RouteInfo(),
      updateStateBeforePop: (context, route, dynamic result, state) => YourStackState(),
      marker: const StackMarker<YourStackState>(),
      controller: StackController<YourStackState>(),
    );
  }
}
```

# [Examples](https://github.com/zenonine/navi/tree/master/examples)

* [bookstore-simple](https://github.com/zenonine/navi/tree/master/examples/bookstore-simple)
* [Deep Linking - Path Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/1-deep-linking-path-parameters)
* [Deep Linking - Query Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/2-deep-linking-query-parameters)
* [Login/Logout/Sign-up Routing](https://github.com/zenonine/navi/tree/master/examples/uxr/3-sign-in-routing)
* [Skipping Stacks](https://github.com/zenonine/navi/tree/master/examples/uxr/5-skipping-stacks)
* [Dynamic Linking](https://github.com/zenonine/navi/tree/master/examples/uxr/6-dynamic-linking)

# Architecture layers

TBD.

# Declarative navigation

Declarative navigation is an example of [declarative programming](https://en.wikipedia.org/wiki/Declarative_programming)
, that expresses the logic of a computation without describing its control flow.

Using declarative navigation is only powerful if

* the provided API is simple enough
* your application is reasonable split into manageable domains (or stacks in this library)

An example, where declarative shines is to manage a chain of pages to complete a task is quite common. Using imperative
approach is usually more difficult in this case.

Chain of pages scenario (also known as flow of pages) is just one case, you can use with Navi. This library is
definitely much more than that.

# Introduction and Milestones

The goal of **Navi** package is to create a friendly **declarative** navigation API for Flutter projects. It depends
heavily on Navigator 2.0.

* Milestone 1 (currently WIP)
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
* Milestone 2
  * Optimize to remove boilerplate code for common/general scenarios
  * Optimize performance
  * Test coverage at least 90%
  * Evaluate edge cases
* Milestone 3
  * Implement a configurator, which fits to common scenarios. For more control, use high level declarative API.
* Milestone 4
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

Please see
this [example](https://github.com/zenonine/navi/blob/master/examples/bookstore-simple/lib/app/widgets/book_page.dart).

# Imperative navigation

* Completed
  * `context.navi.stack(ProductStackMarker())).state = 1`: navigate to product stack with productId = 1.
  * `context.navi.byUrl('/products/1')`: navigate to absolute URL (begin with a slash)

* TODOs:
  * `context.navi.byUrl('details')`: navigate to relative URL
  * `context.navi.pop()`: a shortcut of `Navigator.of(context).pop()`
  * `context.navi.stack(ProductStackMarker())).state.pop()`:
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