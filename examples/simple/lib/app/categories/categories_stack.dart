import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';

import '../app.dart';

class CategoriesStack extends RouteStack {
  CategoriesStack({required this.categoryId});

  // TODO: @PathParam()
  final int categoryId;

  @override
  List<RouteStack> get upperStacks => [HomeStack()];

  @override
  List<Widget> get pages {
    // Assume parent categories are: 1, 2

    return [
      CategoryPage(categoryId: 1),
      CategoryPage(categoryId: 2),
      CategoryPage(categoryId: categoryId),
    ];
  }
}
