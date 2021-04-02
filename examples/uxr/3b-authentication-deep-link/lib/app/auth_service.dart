import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  factory AuthService() => _instance;

  AuthService._internal();

  static final AuthService _instance = AuthService._internal();

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
