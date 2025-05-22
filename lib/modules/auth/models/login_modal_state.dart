class LoginModalState {
  // final String email;
  // final String password;
  final bool isLoading;
  final String? error;

  LoginModalState({
    // this.email = '',
    // this.password = '',
    this.isLoading = false,
    this.error,
  });

  LoginModalState copyWith({
    // String? email,
    // String? password,
    bool? isLoading,
    String? error,
  }) {
    return LoginModalState(
      // email: email ?? this.email,
      // password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
