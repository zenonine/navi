import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';

import 'widgets.dart';

class HomeStack extends RouteStack {
  @override
  List<RouteStack> get upperStacks => [];

  @override
  List<Widget> get pages => [HomePage()];
}
