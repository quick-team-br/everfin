import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/modules/auth/controller/auth_controller.dart';
import 'package:everfin/modules/auth/models/auth_model.dart';
import 'package:everfin/modules/auth/services/auth_service.dart';

class LoginViewModel extends StateNotifier<AsyncValue<AuthToken?>> {
  final AuthService _authService;
  final Ref ref;

  LoginViewModel(this._authService, this.ref)
    : super(const AsyncValue.data(null));

  Future<void> login() async {
    state = const AsyncValue.loading();
    final authToken = (await _authService.oAuthLogin())?.accessToken;

    if (authToken != null) {
      state = AsyncValue.data(null);

      await ref.read(authControllerProvider.notifier).login(authToken);
    } else {
      state = AsyncValue.error(
        'Falha ao realizar o login.',
        StackTrace.current,
      );
    }
  }
}

extension AuthStateX on AsyncValue<AuthToken?> {
  bool get isLoading => maybeWhen(loading: () => true, orElse: () => false);
}

final loginViewProvider =
    StateNotifierProvider<LoginViewModel, AsyncValue<AuthToken?>>((ref) {
      final authService = ref.read(authServiceProvider);
      return LoginViewModel(authService, ref);
    });
