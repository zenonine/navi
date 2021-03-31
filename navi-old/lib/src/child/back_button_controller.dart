import 'package:flutter/foundation.dart';

class BackButtonController extends ChangeNotifier {
  bool _takePriority = true;

  bool get priority => _takePriority;

  void takePriority() {
    _takePriority = true;
    notifyListeners();
  }

  void removePriority() {
    _takePriority = false;
    notifyListeners();
  }
}
