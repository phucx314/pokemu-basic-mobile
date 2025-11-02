import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/models/auth.dart';
import 'package:pokemu_basic_mobile/services/auth_service.dart';
import 'package:pokemu_basic_mobile/services/token_storage_service.dart';

import 'auth_vm.dart';

class LoginPageVm extends ChangeNotifier {
  // di
  final AuthService _authService = AuthService();
  final AuthVm _authVm;

  LoginPageVm({required AuthVm authVm}) : _authVm = authVm;

  // states
  bool _isLoading = false;
  String? _errorMessage;
  // AuthInfo? _authInfo;
  bool _isPassword = true;

  // getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  // AuthInfo? get authInfo => _authInfo;
  // bool get isAuthenticated => _authInfo != null; // getter tiện lợi
  bool get isPassword => _isPassword;

  // setters (to manage states in one fn)
  void _setState({
    bool? loading,
    String? errorMessage,
    // AuthInfo? authInfo,
    bool? isPassword,
  }) {
    _isLoading = loading ?? _isLoading;
    _errorMessage = errorMessage;
    // _authInfo = authInfo;
    _isPassword = isPassword ?? _isPassword;
    notifyListeners();
  }

  // main methods (just login method cuz this is for signin page only)
  Future<bool> login(LoginRequest loginRequest) async {
    _setState(loading: true, errorMessage: null);

    final res = await _authService.login(loginRequest);

    // auth service has saved the tokens when success
    
    if (res.data != null) {
      _authVm.onLoginSuccess(res.data!.authInfo);
      _setState(loading: false);
      return true;
    } else {
      _setState(loading: false, errorMessage: res.message ?? 'Login failed');
      return false;
    }
  }

  void toggleShowHidePassword() {
    _setState(isPassword: !isPassword);
  }
}