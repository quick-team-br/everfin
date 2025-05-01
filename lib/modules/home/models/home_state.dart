import 'package:everfin/modules/home/models/transaction_model.dart';
import 'package:everfin/modules/home/models/transactions_balance.dart';

class HomeState {
  final bool isLoading;
  final List<Transaction> lastTransactions;

  HomeState({this.isLoading = false, this.lastTransactions = const []});

  HomeState copyWith({
    bool? isLoading,
    List<Transaction>? lastTransactions,
    TransactionsBalance? balance,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      lastTransactions: lastTransactions ?? this.lastTransactions,
    );
  }
}
