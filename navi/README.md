Work In Progress: Declarative Navigation framework for Flutter

# Example
Let's start with an example, which is complex enough to see the problem.

* We have an online store (Web and Mobile), and we want to organize our products into categories similar to Amazon. So we want:
  * Home page
    * shows all root categories
    * shows top products, recent products, etc.
    * Etc.
  * Category page
    * select a root category to open category page of 2nd level categories, so on and so on.
      For example of a 3rd level category, `Computer & Accessories › Data Storage › External Data Storage`.
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
  * `Navigator.pages` for a 2nd level category: `[HomePage, CategoryPage, CategoryPage]`. We can have 3rd, 4th level category, but let's stop here.
  * `Navigator.pages` for product overview page, which belongs to a 2nd level category: `[HomePage, CategoryPage, CategoryPage, ProductOverviewPage]`
  * `Navigator.pages` for product details page: `[HomePage, CategoryPage, CategoryPage, ProductOverviewPage, ProductDetailsPage]`
* Mapping URLs to pages
  * `/`: `HomePage`
  * `/categories/:id`: `CategoryPage`
  * `/products/:id`: `ProductOverviewPage`. Automatically find the default category it belongs to.
  * `/products/:id?categoryId=:categoryId`: `ProductOverviewPage`. Use the given category if valid or fallback to default category it belongs to.
  * `/products/:id/details`: `ProductDetailsPage`. Automatically find the default category it belongs to.
  * `/products/:id/details?categoryId=:categoryId`: `ProductDetailsPage`. Use the given category if valid or fallback to default category it belongs to.

# High level idea

Managing the whole navigation system in one place `Navigator(pages: [...])` is too difficult.

Therefore, the idea is splitting into smaller navigation domains (I call them stacks) and combine them into a single `Navigator.pages`.

* How we organize these smaller domains and their relationships?
  
```
// Navigator.pages will be [HomePage()]
class RootStack {
  List<RouteStack> get parentStacks => [];

  List<RouteEntry> get pages => [HomePage()];
}

// Navigator.pages will be [HomePage(), CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: 3)]
class CategoryStack {
  CategoryStack({required this.id});

  final int id;
  
  List<RouteStack> get parentStacks => [RootStack()];

  List<RouteEntry> get pages {
    // assume, this.id = 3,
    // calling remote endpoint to see parent categories: 1, 2.
    return [CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: id)];
  }
}

// Navigator.pages will be smt like [HomePage(), CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: 3), ProductOverviewPage(id: 1)]
// or [HomePage(), CategoryPage(id: 1), CategoryPage(id: 2), CategoryPage(id: 3), ProductOverviewPage(id: 1), ProductDetailPage(id: 1)]
class ProductStack {
  ProductStack({required this.id, this.categoryId, this.pageId});
  
  final int id;
  final int? categoryId;
  final String? pageId;
  
  List<RouteStack> get parentStacks {
    // calling service to validate categoryId, if not valid, return a default category for the product.
    // assuming the categoryId is valid and we use it directly to simplify the example.
    
    return [
      RootStack(),
      CategoryStack(id: categoryId),
    ];
  };

  List<RouteEntry> get pages {
    // assume, this.id = 1,
    return [
      CategoryStack(),
      ProductOverviewPage(id: id),
      if (pageId == 'details') ProductDetailPage(id: id),
    ];
  }
}
```
