import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';

import 'widgets.dart';

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
