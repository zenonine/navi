import 'package:flutter/widgets.dart';
import 'package:navi/navi.dart';

import '../app.dart';
import 'widgets.dart';

class AuthStack extends RouteStack {
  @override
  List<RouteStack> get upperStacks => [HomeStack()];

  @override
  List<Widget> get pages => [AuthPage()];
}
