import 'package:flutter/widgets.dart';

abstract class PageStack<State> extends ChangeNotifier {
  PageStack({required State initialState}) : _state = initialState;

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
      Navigator.of(context).pop(result);
      return false;
    }

    beforePop(context, route, result);
    return true;
  }

  void beforePop(BuildContext context, Route route, dynamic result) {}
}
