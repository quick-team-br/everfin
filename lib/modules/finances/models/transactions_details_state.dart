import 'package:everfin/modules/finances/models/transaction_model.dart';
import 'package:everfin/modules/finances/models/transactions_balance.dart';

class TransactionsDetailsState {
  final bool isLoading;
  final List<Transaction> transactions;
  final TransactionType? filterType;

  static const _unset = Object();

  TransactionsDetailsState({
    this.isLoading = false,
    this.transactions = const [],
    this.filterType,
  });

  TransactionsDetailsState copyWith({
    bool? isLoading,
    List<Transaction>? transactions,
    TransactionsBalance? balance,
    Object? filterType = _unset,
  }) {
    return TransactionsDetailsState(
      isLoading: isLoading ?? this.isLoading,
      transactions: transactions ?? this.transactions,
      filterType:
          filterType == _unset
              ? this.filterType
              : filterType as TransactionType?,
    );
  }
}
