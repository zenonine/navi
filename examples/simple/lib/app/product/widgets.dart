import 'package:flutter/material.dart';
import 'package:navi/navi.dart';

import '../app.dart';

class ProductOverviewPage extends StatefulWidget {
  ProductOverviewPage({required this.productId});

  final int productId;

  @override
  _ProductOverviewPageState createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product ${widget.productId}'),
      ),
      // TODO: add button to navigate to product details page
      body: Text('Product ${widget.productId}'),
    );
  }
}

class ProductDetailsPage extends StatefulWidget {
  ProductDetailsPage({required this.productId});

  final int productId;

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

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

class ProductDetailsSpecsPage extends StatefulWidget {
  ProductDetailsSpecsPage({required this.productId});

  final int productId;

  @override
  _ProductDetailsSpecsPageState createState() =>
      _ProductDetailsSpecsPageState();
}

class _ProductDetailsSpecsPageState extends State<ProductDetailsSpecsPage> {
  @override
  Widget build(BuildContext context) {
    return Text('Product Specs ${widget.productId}');
  }
}

class ProductDetailsAccessoriesPage extends StatefulWidget {
  ProductDetailsAccessoriesPage({required this.productId});

  final int productId;

  @override
  _ProductDetailsAccessoriesPageState createState() =>
      _ProductDetailsAccessoriesPageState();
}

class _ProductDetailsAccessoriesPageState
    extends State<ProductDetailsAccessoriesPage> {
  @override
  Widget build(BuildContext context) {
    return Text('Product Accessories ${widget.productId}');
  }
}
