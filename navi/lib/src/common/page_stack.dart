import 'package:flutter/widgets.dart';

abstract class PageStack<State> extends ChangeNotifier {
  PageStack({String? name, required State initialState})
      : _name = name,
        _state = initialState;

  final String? _name;

  String? get name => _name;

  State _state;

  State get state => _state;

  @protected
  set state(State newState) {
    _state = newState;
    notifyListeners();
  }

  List<Page> pages(BuildContext context);

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

  void beforePop(BuildContext context, Route route, dynamic result) {}

  @override
  String toString() {
    return '$runtimeType{name: $name, state: $state}';
  }
}
