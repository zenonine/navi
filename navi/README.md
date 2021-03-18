Work In Progress: Declarative Navigation framework for Flutter

# Introduction

The goal of this library is to create a simple declarative navigation API for Flutter projects.

To use the library, you only need to know how to use 2 simple classes: `RouteStack` class, `StackOutlet` widget and
nothing more.

```
// This stack only have a single page: [HomePage()]
class HomeStack extends RouteStack {
  List<RouteStack> get upperStacks => [];
  List<Widget> get pages => [HomePage()];
}

// This stack reuse upper stack `HomeStack` and join with category pages in current stack.
// Result: [HomePage(), CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: 3)]
class CategoriesStack extends RouteStack {
  CategoriesStack({required this.categoryId});

  final int categoryId;

  List<RouteStack> get upperStacks => [HomeStack()];

  List<Widget> get pages {
    // Assume parent categories are 1, 2
    return [
      CategoryPage(categoryId: 1),
      CategoryPage(categoryId: 2),
      CategoryPage(categoryId: categoryId),
    ];
  }
}
```

If you want to have nested routes, use `StackOutlet` widget.

The example below use `BottomNavigationBar` to demonstrate how you can use declarative API to switch between 2 tabs,
each tab is a route.

Calling `setState()` will update the current nested stack, and therefore switching the tabs.

You want to control transition of the nested stack? => just use the normal flutter way, because `StackOutlet` widget is
just a normal widget.

```
class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductDetailsTab tab = ProductDetailsTab.specs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ... removed for concise
      body: StackOutlet(
        stack: ProductDetailsStack(
          productId: widget.productId,
          tab: tab,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list)),
          BottomNavigationBarItem(icon: Icon(Icons.plumbing_sharp)),
        ],
        currentIndex: tab == ProductDetailsTab.specs ? 0 : 1,
        onTap: (tabIndex) {
          setState(() {
            tab = tabIndex == 0
                ? ProductDetailsTab.specs
                : ProductDetailsTab.accessories;
          });
        },
      ),
    );
  }
}
```

```
enum ProductDetailsTab { specs, accessories }

class ProductDetailsStack extends RouteStack {
  ProductDetailsStack({required this.productId, required this.tab});
  
  // ... removed for concise
  
  List<Widget> get pages {
    return [
      if (tab == ProductDetailsTab.specs)
        ProductDetailsSpecsPage(productId: productId),
      if (tab == ProductDetailsTab.accessories)
        ProductDetailsAccessoriesPage(productId: productId),
    ];
  }
}
```

# Example

Let's start with an example, which is complex enough to see the problem.

* We have an online store (Web and Mobile), and we want to organize our products into categories similar to Amazon. So
  we want:
  * Home page
    * shows all root categories
    * shows top products, recent products, etc.
    * Etc.
  * Category page
    * select a root category to open category page of 2nd level categories, so on and so on. For example of a 3rd level
      category, `Computer & Accessories › Data Storage › External Data Storage`.
    * in each category page,
      * shows all next level categories if it has
      * shows all products of current category and sub-categories
    * click in-app back button to go up to parent category page and finally home page.
  * Product overview page
    * general information of the product
    * click in-app back button to open category page of the product.
  * Product details page
    * details of the product
    * click in-app back button to open product overview page.
  * 404 page
    * click in-app back button to open home page.
* Hierarchy pages we want
  * `Navigator.pages` for home page: `[HomePage]`
  * `Navigator.pages` for a root category: `[HomePage, CategoryPage]`
  * `Navigator.pages` for a 2nd level category: `[HomePage, CategoryPage, CategoryPage]`. We can have 3rd, 4th level
    category, but let's stop here.
  * `Navigator.pages` for product overview page, which belongs to a 2nd level
    category: `[HomePage, CategoryPage, CategoryPage, ProductOverviewPage]`
  * `Navigator.pages` for product details
    page: `[HomePage, CategoryPage, CategoryPage, ProductOverviewPage, ProductDetailsPage]`.

    In this case, we also have nested stack for specs and accessories tabs: `[ProductDetailsSpecsPage]`
    or `[ProductDetailsAccessoriesPage]`

* Mapping URLs to pages
  * `/`: `HomePage`
  * `/categories/:id`: `CategoryPage`
  * `/products/:id`: `ProductOverviewPage`. Automatically find the default category it belongs to.
  * `/products/:id?categoryId=:categoryId`: `ProductOverviewPage`. Use the given category if valid or fallback to
    default category it belongs to.
  * `/products/:id/details`: `ProductDetailsPage`, tab `specs` by default. Automatically find the default category it
    belongs to.
  * `/products/:id/details?categoryId=:categoryId`: `ProductDetailsPage`, tab `specs` by default. Use the given category
    if valid or fallback to default category it belongs to.
  * `/products/:id/details?tab=accessories`: open tab `accessories` on `ProductDetailsPage`.

# High level idea

Managing the whole navigation system in one place `Navigator(pages: [...])` is too difficult.

Therefore, the idea is splitting into smaller navigation domains (I call them stacks) and combine them into a
single `Navigator.pages`.

* How we organize these smaller domains and their relationships?

In the example code below, we have 3 stacks `HomeStack`, `CategoriesStack` and `ProductStack`.

`ProductStack` reuses `HomeStack` and `CategoriesStack`, so home page and categories pages are added automatically to
product page.

For nested routes, we use simple declarative API with `StackOutlet` widget in a `BottomNavigationBar`.
Calling `setState()` will update the current nested stack, and therefore switching the tabs.

```
// Navigator.pages will be [HomePage()]
class HomeStack extends RouteStack {
  @override
  List<RouteStack> get upperStacks => [];

  @override
  List<Widget> get pages => [HomePage()];
}

// Navigator.pages will be [HomePage(), CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: 3)]
class CategoriesStack extends RouteStack {
  CategoriesStack({required this.categoryId});

  final int categoryId;

  @override
  List<RouteStack> get upperStacks => [HomeStack()];

  @override
  List<Widget> get pages {
    // Assume parent categories are 1, 2
    return [
      CategoryPage(categoryId: 1),
      CategoryPage(categoryId: 2),
      CategoryPage(categoryId: categoryId),
    ];
  }
}

// Navigator.pages will be smt like [HomePage(), CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: 3), ProductOverviewPage(id: 1)]
// or [HomePage(), CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: 3), ProductOverviewPage(id: 1), ProductDetailsPage(id: 1)]
class ProductStack extends RouteStack {
  ProductStack({required this.productId, required this.showDetails});

  // TODO: @PathParam()
  final int productId;
  final bool showDetails;

  @override
  List<RouteStack> get upperStacks {
    // calling remote endpoint to find product category
    final categoryId = 3;
    return [HomeStack(), CategoriesStack(categoryId: categoryId)];
  }

  @override
  List<Widget> get pages {
    return [
      ProductOverviewPage(productId: productId),
      if (showDetails) ProductDetailsPage(productId: productId),
    ];
  }
}
```

```
class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductDetailsTab tab = ProductDetailsTab.specs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product ${widget.productId}'),
      ),
      body: StackOutlet(
        stack: ProductDetailsStack(
          productId: widget.productId,
          tab: tab,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list)),
          BottomNavigationBarItem(icon: Icon(Icons.plumbing_sharp)),
        ],
        currentIndex: tab == ProductDetailsTab.specs ? 0 : 1,
        onTap: (tabIndex) {
          setState(() {
            tab = tabIndex == 0
                ? ProductDetailsTab.specs
                : ProductDetailsTab.accessories;
          });
        },
      ),
    );
  }
}

enum ProductDetailsTab { specs, accessories }

class ProductDetailsStack extends RouteStack {
  ProductDetailsStack({required this.productId, required this.tab});

  // TODO: @PathParam()
  final int productId;
  final ProductDetailsTab tab;

  @override
  List<RouteStack> get upperStacks => [];

  @override
  List<Widget> get pages {
    return [
      if (tab == ProductDetailsTab.specs)
        ProductDetailsSpecsPage(productId: productId),
      if (tab == ProductDetailsTab.accessories)
        ProductDetailsAccessoriesPage(productId: productId),
    ];
  }
}
```

* Imperative navigation
  * `context.navi.byUrl('details')`: navigate to relative URL
  * `context.navi.byUrl('/products/1')`: navigate to absolute URL (begin with a slash)
  * `context.navi.byUrl('/products/:id', pathParams: {'id': 1})`
  * `context.navi.byStack(ProductStack(id: 1))`
  * `context.navi.byStack(ProductStack(id: 1, categoryId: 3))`
  * `context.navi.byStack(ProductStack(id: 1, onNavigated: () {}), onFailure: () {})`
  * `context.navi.pop()`: move up one level in the current stack or exit if there's no upper page.
  * `context.navi.back()`: move back to the previous page in the history.

* How to sync URL and the current navigation stack?

  You will have 2 options to choose:
  * Don't use code generator: path parameters and query parameters are provided to you as `String`. You need to manually
    validate and convert to your types.
  * Use code generator to generate typesafe interfaces, which allow you to sync path parameters and query parameters to
    your variable in the defined types automatically.