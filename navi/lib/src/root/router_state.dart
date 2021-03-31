import 'package:flutter/widgets.dart';

import '../main.dart';

class RouterState extends ChangeNotifier {
  factory RouterState() => _instance;

  RouterState._internal();

  static late final RouterState _instance = RouterState._internal();

  StackState? _state;

  StackState? get state => _state;

  set state(StackState? newState) {
    _state = newState;
    notifyListeners();
  }

  @override
  String toString() {
    return 'RouterState{state: $state}';
  }
}
