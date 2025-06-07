class LoginResponse {
  final bool success;
  final LoginData data;

  LoginResponse({required this.success, required this.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['success'],
      data: LoginData.fromJson(json['data']),
    );
  }
}

class LoginData {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final String tokenType;

  LoginData({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.tokenType,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
    );
  }
}
