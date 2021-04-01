import 'package:flutter/widgets.dart';

class StackController<T> {
  StackController({bool activated = true})
      : _activationController = StackActivationController(activated: activated);

  final _stateController = StackStateController<T>();
  final StackActivationController _activationController;

  StackStateController<T> get stateController => _stateController;

  StackActivationController get activationController => _activationController;

  void dispose() {
    _stateController.dispose();
    _activationController.dispose();
  }
}

class StackStateController<T> extends ChangeNotifier {
  late T _state;

  bool _initialized = false;

  T get state => _state;

  set state(T newState) {
    if (!_initialized) {
      _initialized = true;
      _state = newState;
      notifyListeners();
    } else if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }
}

class StackActivationController extends ChangeNotifier {
  StackActivationController({required bool activated}) : _activated = activated;

  bool _activated;

  bool get activated => _activated;

  void activate() {
    if (!_activated) {
      _activated = true;
      notifyListeners();
    }
  }

  void deactivate() {
    if (_activated) {
      _activated = false;
      notifyListeners();
    }
  }
}
