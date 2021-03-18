import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';

import '../app.dart';
import 'widgets.dart';

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
