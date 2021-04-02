import 'package:flutter/widgets.dart';

class StackController<T> extends ChangeNotifier {
  StackController({bool activated = true})
      : _activationController = StackActivationController(activated: activated);

  final StackActivationController _activationController;

  StackActivationController get activationController => _activationController;

  late T _state;

  bool _initialized = false;

  T get state {
    assert(_initialized, 'Accessing uninitialized stack state.');
    return _state;
  }

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

  @override
  void dispose() {
    _activationController.dispose();
    super.dispose();
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