import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/auth_service.dart';
import 'package:pokemu_basic_mobile/services/token_storage_service.dart';

import '../models/auth.dart';

class CreateAccountVm extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final TokenStorageService _tokenStorageService = TokenStorageService();

  bool _isLoading = false;
  String? _errorMessage;
  AuthInfo? _authInfo;
  bool _isPassword = true;
  bool _isPassword2 = true;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  AuthInfo? get authInfo => _authInfo;
  bool get isAuthenticated => _authInfo != null; // getter tiện lợi
  bool get isPassword => _isPassword;
  bool get isPassword2 => _isPassword2;

  void _setState({
    bool? loading,
    String? errorMessage,
    AuthInfo? authInfo,
    bool? isPassword,
    bool? isPassword2,
  }) {
    _isLoading = loading ?? _isLoading;
    _errorMessage = errorMessage;
    _authInfo = authInfo;
    _isPassword = isPassword ?? _isPassword;
    _isPassword2 = isPassword2 ?? _isPassword2;
    notifyListeners();
  }

  Future<bool> createAccount(RegisterRequest registerRequest) async {
    _setState(loading: true, errorMessage: null);

    final res = await _authService.createAccount(registerRequest);

    if (res.statusCode == 200) {
      _setState(loading: false);
      return true;
    } else {
      _setState(loading: false, errorMessage: res.message ?? 'Creating account failed');
      return false;
    }
  }

  void toggleShowHidePassword() {
    _setState(isPassword: !isPassword);
  }

  void toggleShowHidePassword2() {
    _setState(isPassword2: !isPassword2);
  }
}