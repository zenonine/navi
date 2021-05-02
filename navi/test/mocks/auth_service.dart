import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _authenticated = false;

  bool get authenticated => _authenticated;

  Future<bool> login() async {
    if (!_authenticated) {
      _authenticated = true;
      notifyListeners();
    }
    return true;
  }

  Future<void> logout() async {
    if (_authenticated) {
      _authenticated = false;
      notifyListeners();
    }
  }
}
