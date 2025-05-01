import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final UserModel? user;

  const AuthState._({required this.status, this.user});

  factory AuthState.loading() => const AuthState._(status: AuthStatus.loading);
  factory AuthState.authenticated(UserModel user) =>
      AuthState._(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated() =>
      const AuthState._(status: AuthStatus.unauthenticated);
}

class AuthController extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthController(this._authService) : super(AuthState.loading()) {
    _init();
  }

  Future<void> _init() async {
    final token = await _authService.getToken();
    final user = await _authService.getUser();
    if (token != null && user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<void> login(String token) async {
    final user = _authService.extractUserFromToken(token);
    await _authService.saveAuthData(token, user);
    state = AuthState.authenticated(user);
  }

  Future<void> logout() async {
    await _authService.logout();
    state = AuthState.unauthenticated();
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final service = ref.watch(authServiceProvider);
    return AuthController(service);
  },
);
