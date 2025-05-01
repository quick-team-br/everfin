import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:everfin/modules/auth/models/user_model.dart';

import '../models/auth_model.dart';

class AuthService {
  final _storage = const FlutterSecureStorage();

  final String _clientId = 'quick-mobile';
  final String _redirectUri = 'everfin://callback';
  final String _authorizationEndpoint =
      'https://auth.quickteam.com.br/dex/auth';
  final String _tokenEndpoint = 'https://auth.quickteam.com.br/dex/token';
  final String _clientSecret = 'quick-mobile-secret';

  String _generateCodeVerifier() {
    final random = Random.secure();
    final values = List<int>.generate(64, (_) => random.nextInt(256));
    return base64UrlEncode(values).replaceAll('=', '');
  }

  String _generateCodeChallenge(String verifier) {
    final bytes = utf8.encode(verifier);
    final digest = sha256.convert(bytes);
    return base64UrlEncode(digest.bytes).replaceAll('=', '');
  }

  Future<AuthToken?> oAuthLogin() async {
    final codeVerifier = _generateCodeVerifier();
    final codeChallenge = _generateCodeChallenge(codeVerifier);

    final url =
        '$_authorizationEndpoint?response_type=code&client_id=$_clientId&redirect_uri=$_redirectUri&scope=openid%20email%20profile&code_challenge=$codeChallenge&code_challenge_method=S256';

    try {
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'everfin',
        options: const FlutterWebAuth2Options(preferEphemeral: false),
      );

      final code = Uri.parse(result).queryParameters['code'];
      if (code == null) throw Exception('Code not found');

      final response = await http.post(
        Uri.parse(_tokenEndpoint),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'grant_type': 'authorization_code',
          'client_id': _clientId,
          'redirect_uri': _redirectUri,
          'code': code,
          'code_verifier': codeVerifier,
          'client_secret': _clientSecret,
        },
      );

      if (response.statusCode == 200) {
        return AuthToken.fromJson(json.decode(response.body));
      } else {
        throw Exception('Token exchange failed: ${response.body}');
      }
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }

  Future<void> saveAuthData(String token, UserModel user) async {
    await _storage.write(key: 'access_token', value: token);
    await _storage.write(key: 'user_data', value: jsonEncode(user.toJson()));
  }

  Future<String?> getToken() async {
    return _storage.read(key: 'access_token');
  }

  Future<UserModel?> getUser() async {
    final data = await _storage.read(key: 'user_data');
    if (data != null) {
      return UserModel.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.deleteAll();
  }

  UserModel extractUserFromToken(String token) {
    final decodedToken = JwtDecoder.decode(token);

    return UserModel(
      name: decodedToken['name'] ?? 'Sem nome',
      email: decodedToken['email'] ?? 'sem@email.com',
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) => AuthService());
