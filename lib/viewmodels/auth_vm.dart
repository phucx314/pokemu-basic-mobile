import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/models/auth.dart';
import 'package:pokemu_basic_mobile/services/auth_service.dart';
import 'package:pokemu_basic_mobile/services/token_storage_service.dart';

class AuthVm extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  AuthInfo? _currUser;

  AuthInfo? get currUser => _currUser;
  bool get isAuthenticated => _currUser != null;

  void loginSuccess(AuthInfo authInfo) {
    _currUser = authInfo;
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final refreshToken = await _tokenStorageService.getRefreshToken();

    if (refreshToken == null) return false;

    final res = await _authService.getMe();

    if (res.data != null) {
      _currUser = res.data;
      notifyListeners();
      return true;
    }

    return false;
  }

  void onLoginSuccess(AuthInfo authInfo) {
    _currUser = authInfo;
    notifyListeners();
  }

  Future<bool> getMe() async {
    final res = await _authService.getMe();

    if (res.statusCode == 200 && res.data != null) {
      _currUser = res.data;
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    await _authService.logout();
    _currUser = null;
    notifyListeners();
  }
}