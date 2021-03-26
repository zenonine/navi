import 'package:flutter/foundation.dart';

class _AuthService extends ChangeNotifier {
  bool _authenticated = false;

  bool get authenticated => _authenticated;

  Future<void> login(String username, String password) async {
    if (username == 'user' && password == 'user') {
      _authenticated = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _authenticated = false;
    notifyListeners();
  }
}

final authService = _AuthService();
