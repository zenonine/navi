import 'package:flutter/widgets.dart';

import '../main.dart';

abstract class PageStack<State> extends ChangeNotifier {
  PageStack({String? name, required State initialState})
      : _name = name,
        _state = initialState;

  final String? _name;

  String? get name => _name;

  State _state;

  State get state => _state;

  set state(State newState) {
    _state = beforeSetState(newState);
    notifyListeners();
    afterSetState();
  }

  List<PageStack> parents = [];

  List<Page> pages(BuildContext context);

  @protected
  State beforeSetState(State newState) => newState;

  @protected
  void afterSetState() {
    NaviState().stacks = parents + [this];
  }

  bool onPopPage(BuildContext context, Route route, dynamic result) {
    final didPopSuccess = route.didPop(result);

    if (!didPopSuccess) {
      return false;
    }

    if (route.isFirst) {
      // Forward pop to parent navigator
      Navigator.pop(context, result);
      return false;
    }

    beforePop(context, route, result);
    return true;
  }

  void beforePop(BuildContext context, Route route, dynamic result);

  @override
  String toString() {
    return '$runtimeType{name: $name, state: $state}';
  }
}
