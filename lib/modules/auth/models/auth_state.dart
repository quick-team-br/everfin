import 'package:everfin/modules/auth/models/user_model.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;

  const AuthState._({required this.status, this.user});

  factory AuthState.loading() => const AuthState._(status: AuthStatus.loading);
  factory AuthState.authenticated(User user) =>
      AuthState._(status: AuthStatus.authenticated, user: user);
  factory AuthState.unauthenticated() =>
      const AuthState._(status: AuthStatus.unauthenticated);
}
