import 'package:desenrolai/modules/finances/models/transaction_model.dart';
// import 'package:desenrolai/modules/finances/models/transactions_balance.dart';

class HomeState {
  final bool isLoading;
  final List<Transaction> lastTransactions;
  final String? error;

  HomeState({
    this.isLoading = false,
    this.lastTransactions = const [],
    this.error,
  });

  HomeState copyWith({
    bool? isLoading,
    List<Transaction>? lastTransactions,
    String? error,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      lastTransactions: lastTransactions ?? this.lastTransactions,
      error: error ?? this.error,
    );
  }
}
