import 'package:flutter/foundation.dart';

class BackButtonController extends ChangeNotifier {
  bool _takePriority = true;

  bool get priority => _takePriority;

  void takePriority() {
    this._takePriority = true;
    notifyListeners();
  }

  void removePriority() {
    this._takePriority = false;
    notifyListeners();
  }
}
