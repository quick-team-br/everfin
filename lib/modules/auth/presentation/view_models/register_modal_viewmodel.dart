import 'package:flutter_multi_formatter/formatters/formatter_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/modules/auth/controller/auth_controller.dart';
import 'package:everfin/modules/auth/models/sign_up_modal_state.dart';

class RegisterModalViewModel extends StateNotifier<SignUpModalState> {
  final Ref ref;

  RegisterModalViewModel(this.ref) : super(SignUpModalState());

  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';

  void setEmail(String value) => _email = value;
  void setPassword(String value) => _password = value;
  void setPhone(String value) => _phone = value;
  void setName(String value) => _name = value;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Por favor, insira seu nome';
    return null;
  }

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

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira seu telefone';
    }

    // Remove non-digit characters
    final digits = value.replaceAll(RegExp(r'\D'), '');

    // Check if it has the correct length (10 or 11 digits)
    if (digits.length < 10 || digits.length > 11) {
      return 'Telefone inválido';
    }

    // Check if DDD is valid (10-99)
    final ddd = int.tryParse(digits.substring(0, 2)) ?? 0;
    if (ddd < 10 || ddd > 99) {
      return 'DDD inválido';
    }

    return null;
  }

  Future<bool> register() async {
    state = state.copyWith(isLoading: true, error: null);

    print("register: $_name, $_email, $_password, $_phone");

    try {
      await ref
          .read(authControllerProvider.notifier)
          .registerAndLogin(
            _name,
            _email,
            _password,
            int.parse(toNumericString(_phone)),
          );

      state = state.copyWith(isLoading: false, error: null);
      return true;
    } catch (e) {
      print('Error during registration: $e');
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

final signUpModalViewModelProvider =
    StateNotifierProvider.autoDispose<RegisterModalViewModel, SignUpModalState>(
      (ref) => RegisterModalViewModel(ref),
    );
