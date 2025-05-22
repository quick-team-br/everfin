import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:everfin/core/services/network/dio_client.dart';
import 'package:everfin/core/services/storage/secure_storage_service.dart';
import 'package:everfin/modules/auth/models/user_model.dart';

class AuthService {
  final Dio _dio;
  final SecureStorageService _storage;

  static const _userStorageKey = 'user_data';
  static const _tokenStorageKey = 'access_token';
  static const _refreshTokenStorageKey = 'refresh_token';

  AuthService(this._storage, this._dio);

  Future<User?> login(String email, String password) async {
    try {
      final mockToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJlbWFpbCI6ImpvaG5AZXhhbXBsZS5jb20ifQ.kG6vYXOdNFzHJFNUGY6qFOIQT9h_gKkLnqZrLTDQf8E';

      await _storage.write(_tokenStorageKey, mockToken);

      final user = extractUserFromToken(mockToken);
      await _storage.write(_userStorageKey, jsonEncode(user.toJson()));

      return user;
    } catch (e) {
      print('Login failed: $e');
      return null;
    }
  }

  Future<User?> register(
    String name,
    String email,
    String password,
    int phone,
  ) async {
    try {
      print("object: aaa");
      return User(email: email, name: name);
    } catch (e) {
      print('Register failed: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    return _storage.read(_tokenStorageKey);
  }

  Future<User?> getCurrentUser() async {
    final data = await _storage.read(_userStorageKey);
    if (data != null) {
      return User.fromJson(jsonDecode(data));
    }
    return null;
  }

  Future<void> logout() async {
    await _storage.clear();
  }

  Future<bool> refreshToken() async {
    try {
      final token = await getToken();
      if (token == null) return false;

      final newToken =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1lIjoiSm9obiBEb2UiLCJlbWFpbCI6ImpvaG5AZXhhbXBsZS5jb20ifQ.kG6vYXOdNFzHJFNUGY6qFOIQT9h_gKkLnqZrLTDQf8E';

      return true;
    } catch (e) {
      print('Token refresh failed: $e');
      return false;
    }
  }

  User extractUserFromToken(String token) {
    final decodedToken = JwtDecoder.decode(token);

    return User(
      name: decodedToken['name'] ?? 'Sem nome',
      email: decodedToken['email'] ?? 'sem@email.com',
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioClientProvider);
  final storage = ref.read(secureStorageProvider);
  return AuthService(storage, dio);
});
