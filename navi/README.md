Navi - A declarative navigation framework for Flutter, based on Navigator 2.0.

Note that, imperative navigation API is also supported as an extra layer beyond the declarative API at lower layer.

# [Examples](https://github.com/zenonine/navi/tree/master/examples)

* [bookstore-simple](https://github.com/zenonine/navi/tree/master/examples/bookstore-simple)
* [Authentication](https://github.com/zenonine/navi/tree/master/examples/uxr/3a-authentication-home)
* [Deep Linking - Path Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/1-deep-linking-path-parameters)
* [Deep Linking - Query Parameters](https://github.com/zenonine/navi/tree/master/examples/uxr/2-deep-linking-query-parameters)

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

* Milestone 1 (currently WIP):
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
* Milestone 2:
  * Optimize to remove boilerplate code for common/general scenarios
  * Optimize performance
  * Test coverage at least 90%
  * Evaluate edge cases
* Milestone 3:
  * Code generator to even remove more boilerplate code

To use the library, you only need to know how to use **3 simple** classes:

* [`PageStack`](https://github.com/zenonine/navi/blob/master/navi/lib/src/common/page_stack.dart):
  declare the pages of a stack, which are updated accordingly to current state.
* [`RouteStack`](https://github.com/zenonine/navi/blob/master/navi/lib/src/common/route_stack.dart) extends `PageStack`
  with routing capability. If you don't need deep linking or target web, `PageStack` is enough for your app.

  Note that, deep linking is currently only working for root stack. Support child stacks will be available soon.
* [`StackOutlet`](https://github.com/zenonine/navi/blob/master/navi/lib/src/child/stack_outlet.dart) is a normal widget,
  which build pages of a stack.

Please see this [full source code example](https://github.com/zenonine/navi/tree/master/examples) app.

# Nested stack

Because `StackOutlet` is just a normal widget, you only need to use this widget to build nested stacks like you would do
with other widgets.

It's commonly used together
with [`BottomNavigationBar`](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html), but it will
definitely work with other components and designs.

If you want to keep state of nested stacks, you could
use [`IndexedStack`](https://api.flutter.dev/flutter/widgets/IndexedStack-class.html).

Please see
this [example](https://github.com/zenonine/navi/blob/master/examples/bookstore-simple/lib/app/widgets/book_page.dart).

# TODO: Reusable stacks

Each stack can generate only pages related to its domain. Sometime you would like to have a stack which contains pages
from other stacks.

For example, you have 2 stacks:

* `CategoryStack` has 3
  pages `[CategoryPage('Computer & Accessories'), CategoryPage('Data Storage'), CategoryPage('External Data Storage')]`
* `ProductStack` has 2 pages `[ProductOverviewPage(), ProductDetailsPage()]`

If you want to open `ProductDetailsPage`, you might want to have also pages from `CategoryStack` in your hierarchy. The
result you want could
be `[CategoryPage('Computer & Accessories'), CategoryPage('Data Storage'), CategoryPage('External Data Storage'), ProductOverviewPage(), ProductDetailsPage()]`
.

The code snippet below explains how you can achieve that:

```
class ProductStack extends PageStack {
  List<PageStack> upperStacks(BuildContext context) {
    return [CategoryStack()];
  }

  List<Page> pages(BuildContext context) {
    return [ProductOverviewPage(), ProductDetailsPage()];
  }
}
```

# TODO: Imperative navigation

Basically, you will not need this legacy approach if you can split your app into manageable stacks. However, it will
still be useful in many cases and will be supported.

* `context.navi.stack<ProductStack>().state = 1`: navigate to product stack with productId = 1.
* `context.navi.byUrl('details')`: navigate to relative URL
* `context.navi.byUrl('/products/1')`: navigate to absolute URL (begin with a slash)
* `context.navi.byUrl('/products/:id', pathParams: {'id': 1})`
* `context.navi.pop()`: move up one level in the current stack or exit if there's no upper page.
* `context.navi.back()`: move back to the previous page in the history.

# TODO: Sync URL and stack state?

You will have 2 options to choose:

* Don't use code generator: path parameters and query parameters are provided to you as `String`. You need to manually
  validate and convert to your types.
* Use code generator to generate typesafe interfaces, which allow you to sync path parameters and query parameters to
  your variable in the defined types automatically.

# TODO: Manipulation of the chronological history Stack

Browser back button and system back button should behave the same way, according
to [material navigation guideline](https://material.io/design/navigation/understanding-navigation.html#reverse-navigation)