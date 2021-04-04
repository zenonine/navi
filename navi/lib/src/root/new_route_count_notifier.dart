import 'package:flutter/widgets.dart';

class NewRouteCountNotifier extends ChangeNotifier {
  factory NewRouteCountNotifier() => _instance;

  NewRouteCountNotifier._internal();

  static late final NewRouteCountNotifier _instance =
      NewRouteCountNotifier._internal();

  int _count = 0;

  int get count => _count;

  set count(int newCount) {
    if (_count != newCount) {
      _count = newCount;
      notifyListeners();
    }
  }
}
