import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  bool _authenticated = false;

  bool get authenticated => _authenticated;

  Future<void> login() async {
    if (!_authenticated) {
      _authenticated = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    if (_authenticated) {
      _authenticated = false;
      notifyListeners();
    }
  }
}
