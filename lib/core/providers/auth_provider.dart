import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthProvider with ChangeNotifier {
  final _storage = const FlutterSecureStorage();
  String? _token;

  String? get token => _token;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _tryAutoLogin();
  }

  Future<void> _tryAutoLogin() async {
    _token = await _storage.read(key: 'access_token');
    notifyListeners();
  }

  Future<void> login(String token) async {
    _token = token;
    await _storage.write(key: 'access_token', value: token);
    notifyListeners();
  }

  Future<void> logout() async {
    _token = null;
    await _storage.delete(key: 'access_token');
    notifyListeners();
  }
}