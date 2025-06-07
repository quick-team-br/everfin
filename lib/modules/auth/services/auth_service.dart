import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'package:desenrolai/core/services/network/dio_client.dart';
import 'package:desenrolai/core/services/storage/secure_storage_service.dart';
import 'package:desenrolai/modules/auth/models/login_response_model.dart';
import 'package:desenrolai/modules/auth/models/user_model.dart';
import 'package:desenrolai/shared/models/service_response.dart';

class AuthService {
  final Dio _dio;
  final SecureStorageService _storage;

  static const _userStorageKey = 'user_data';
  static const _tokenStorageKey = 'access_token';
  static const _refreshTokenStorageKey = 'refresh_token';

  AuthService(this._storage, this._dio);

  Future<ServiceResponse<User?>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        '/v1/auth/login',
        data: {'email': email, 'password': password},
      );

      final loginResponse = LoginResponse.fromJson(response.data);

      await _storage.write(_tokenStorageKey, loginResponse.data.accessToken);
      await _storage.write(
        _refreshTokenStorageKey,
        loginResponse.data.refreshToken,
      );

      final user = extractUserFromToken(loginResponse.data.accessToken);
      await _storage.write(_userStorageKey, jsonEncode(user.toJson()));

      return ServiceResponse.success(user);
    } on DioException catch (e) {
      print('DioError type: ${e.type}, response: ${e.response}');
      return ServiceResponse.failure("Usuário ou senha inválidos");
    } catch (e) {
      return ServiceResponse.failure("Usuário ou senha inválidos");
    }
  }

  Future<ServiceResponse<User>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/users',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'phone_number': "+55$phone",
          'role': "user",
        },
      );

      print("Register response: ${response.data}");

      // final token = response.data['token'];
      // await _storage.write(_tokenStorageKey, token);

      // final user = extractUserFromToken(token);
      // await _storage.write(_userStorageKey, jsonEncode(user.toJson()));

      return ServiceResponse.failure("Erro ao fazer registro");
    } on DioException catch (e) {
      print('Register failed: ${e.message}');
      print('DioError type: ${e.type}, response: ${e.response}');
      return ServiceResponse.failure("Erro ao fazer registro");
    } catch (e) {
      print('Register failed: $e');
      return ServiceResponse.failure("Erro ao fazer registro");
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

    if (decodedToken['user_id'] == null ||
        // decodedToken['name'] == null ||
        decodedToken['email'] == null) {
      throw Exception('Token inválido');
    }

    return User(
      id: decodedToken['user_id']!,
      name: decodedToken['name'] ?? 'Sem nome',
      email: decodedToken['email']!,
    );
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final dio = ref.read(dioClientProvider);
  final storage = ref.read(secureStorageProvider);
  return AuthService(storage, dio);
});
