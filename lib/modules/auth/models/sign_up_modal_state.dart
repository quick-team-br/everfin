class SignUpModalState {
  // final String email;
  // final String password;
  // final String phone;
  final bool isLoading;
  final String? error;

  SignUpModalState({
    // this.email = '',
    // this.password = '',
    // this.phone = '',
    this.isLoading = false,
    this.error,
  });

  SignUpModalState copyWith({
    // String? email,
    // String? password,
    // String? phone,
    bool? isLoading,
    String? error,
  }) {
    return SignUpModalState(
      // email: email ?? this.email,
      // password: password ?? this.password,
      // phone: phone ?? this.phone,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
