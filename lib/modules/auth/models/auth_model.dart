class AuthToken {
  final String accessToken;
  final String? refreshToken;
  final String? tokenType;
  final String? idToken;

  AuthToken({
    required this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.idToken,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      tokenType: json['token_type'],
      idToken: json['id_token'],
    );
  }
}
