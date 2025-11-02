class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}

class LoginResponse {
  final String accessToken;
  final String expiresAt;
  final String refreshToken;
  final AuthInfo authInfo;

  LoginResponse({
    required this.accessToken,
    required this.expiresAt,
    required this.refreshToken,
    required this.authInfo,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(accessToken: json['accessToken'], expiresAt: json['expiresAt'], refreshToken: json['refreshToken'], authInfo: AuthInfo.fromJson(json['authInfo']));
  }
}

class AuthInfo {
  final int id;
  final String username;
  final String fullName;
  final int coinBalance;
  final String? avatar;

  AuthInfo({
    required this.id,
    required this.username,
    required this.fullName,
    required this.coinBalance,
    this.avatar 
  });

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    return AuthInfo(id: json['id'], username: json['username'], fullName: json['fullName'], coinBalance: json['coinBalance'], avatar: json['avatar'] ?? 'https://pub-b4691ef8f7464ccbb84fb1e456fb214a.r2.dev/user-contents/default_avatar.png');
  }
}

class RefreshTokenRequest {
  final String refreshToken;

  RefreshTokenRequest({required this.refreshToken});

  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken,
    };
  }
}

class RegisterRequest {
  final String username;
  final String fullName;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.username,
    required this.fullName,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'fullName': fullName,
      'password': password,
      'confirmPassword': confirmPassword,
    };
  }
}
