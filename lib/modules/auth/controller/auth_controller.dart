import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/modules/auth/models/auth_state.dart';
import 'package:desenrolai/modules/auth/models/user_model.dart';
import 'package:desenrolai/shared/models/service_response.dart';

import '../services/auth_service.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(AuthState.loading()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _authService.getToken();
    final user = await _authService.getCurrentUser();

    if (token != null && user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<ServiceResponse<User?>> login(String email, String password) async {
    final response = await _authService.login(email, password);
    if (response.success) {
      state = AuthState.authenticated(response.data!);
    } else {
      state = AuthState.unauthenticated();
    }
    return response;
  }

  Future<ServiceResponse<User?>> registerAndLogin(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    final response = await _authService.register(name, email, password, phone);
    if (response.success) {
      state = AuthState.authenticated(response.data!);
    } else {
      state = AuthState.unauthenticated();
    }
    return response;
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.unauthenticated();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final service = ref.read(authServiceProvider);
    return AuthController(service);
  },
);
