import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/modules/auth/controller/auth_controller.dart';
import 'package:desenrolai/modules/auth/models/login_modal_state.dart';

class LoginModalViewModel extends StateNotifier<LoginModalState> {
  final Ref ref;

  LoginModalViewModel(this.ref) : super(LoginModalState());

  String _email = '';
  String _password = '';

  void setEmail(String value) => _email = value;
  void setPassword(String value) => _password = value;

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira seu email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira sua senha';
    return null;
  }

  Future<String?> submit() async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await ref
        .read(authControllerProvider.notifier)
        .login(_email, _password);

    if (response.success) {
      state = state.copyWith(isLoading: false, error: null);
      return null;
    }

    state = state.copyWith(isLoading: false, error: response.error);
    return response.error;
  }
}

final loginModalViewModelProvider =
    StateNotifierProvider.autoDispose<LoginModalViewModel, LoginModalState>(
      (ref) => LoginModalViewModel(ref),
    );
