import 'package:flutter/widgets.dart';

abstract class RouteStack {
  List<RouteStack> get upperStacks;

  // TODO: should be an interface instead of Widget?
  List<Widget> get pages;
}
