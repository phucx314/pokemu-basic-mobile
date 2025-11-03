import 'package:flutter/material.dart';
import 'package:pokemu_basic_mobile/services/auth_service.dart';

import '../models/auth.dart';

class CreateAccountVm extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool _isPassword = true;
  bool _isPassword2 = true;
  Map<String, String>? _validationErrors;

  bool get isLoading => _isLoading;
  bool get isPassword => _isPassword;
  bool get isPassword2 => _isPassword2;
  String? get fullNameError => _validationErrors?['FullName'];
  String? get usernameError => _validationErrors?['Username'];
  String? get passwordError => _validationErrors?['Password'];
  String? get confirmPasswordError => _validationErrors?['ConfirmPassword'];
  String? get genericErrorMessage => _validationErrors?['Generic'];

  void _setState({
    bool? loading,
    bool? isPassword,
    bool? isPassword2,
    Map<String, String>? errors,
  }) {
    _isLoading = loading ?? _isLoading;
    _isPassword = isPassword ?? _isPassword;
    _isPassword2 = isPassword2 ?? _isPassword2;
    _validationErrors = errors;
    notifyListeners();
  }

  Future<bool> createAccount(RegisterRequest registerRequest) async {
    _setState(loading: true, errors: null);

    final res = await _authService.createAccount(registerRequest);

    if (res.statusCode == 200) {
      _setState(loading: false);
      return true;
    } else {
      _setState(loading: false, errors: _parseErrors(res.message, res.errors));
      return false;
    }
  }

  void toggleShowHidePassword() {
    _setState(isPassword: !isPassword);
  }

  void toggleShowHidePassword2() {
    _setState(isPassword2: !isPassword2);
  }

  Map<String, String> _parseErrors(String? message, Map<String, List<String>>? errors) {
    Map<String, String> parsedErrors = {};

    if (errors != null && errors.isNotEmpty) {
      // get first err of each text field
      errors.forEach((key, value) {
        if (value.isNotEmpty) {
          parsedErrors[key] = value.first;
        }
      });
    } else if (message != null) {
      parsedErrors['Generic'] = message;
    } else {
      parsedErrors['Generic'] = 'An error occurred';
    }

    return parsedErrors;
  }
}