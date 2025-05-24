import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/modules/auth/models/auth_state.dart';

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

  Future<void> login(String email, String password) async {
    final user = await _authService.login(email, password);
    if (user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> registerAndLogin(
    String name,
    String email,
    String password,
    int phone,
  ) async {
    print("Registering and logging in...");
    try {
      await _authService.register(name, email, password, phone);
      final user = await _authService.login(email, password);
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    } catch (e, st) {
      print('Error during registration and login: $e');
      print('Stack trace: $st');
      state = AuthState.unauthenticated();
    }
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
