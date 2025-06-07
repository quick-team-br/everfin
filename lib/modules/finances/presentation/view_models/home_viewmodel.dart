import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/modules/auth/controller/auth_controller.dart';
import 'package:desenrolai/modules/finances/models/home_state.dart';
import 'package:desenrolai/modules/finances/models/transaction_model.dart';
import 'package:desenrolai/modules/finances/models/transactions_balance.dart';

import '../../services/transaction_service.dart';

import 'month_selector_viewmodel.dart';

final homeProvider =
    StateNotifierProvider.autoDispose<HomeViewModel, HomeState>(
      (ref) => HomeViewModel(ref, ref.read(transactionServiceProvider)),
    );

class HomeViewModel extends StateNotifier<HomeState> {
  final Ref ref;
  final TransactionService transactionService;

  HomeViewModel(this.ref, this.transactionService) : super(HomeState()) {
    final selectedMonth = ref.read(monthSelectorProvider) + 1;
    loadHomeTransactionsData(selectedMonth);
  }

  TransactionsBalance balance = TransactionsBalance(
    totalIncome: 0,
    totalExpense: 0,
    total: 0,
  );

  Future<void> loadHomeTransactionsData(int monthIndex) async {
    state = state.copyWith(isLoading: true);

    balance = await transactionService.getBalance(monthIndex);

    final serviceResponse = await transactionService.fetchTransactionsByMonth(
      monthIndex,
      4,
      ref.watch(authControllerProvider).user!.id,
    );

    state = state.copyWith(
      isLoading: false,
      lastTransactions: serviceResponse.data,
      error: serviceResponse.error,
    );
  }

  void updateLastTransactions(Transaction newTransaction) {
    final currentTransactions = List<Transaction>.from(state.lastTransactions);

    currentTransactions.insert(0, newTransaction);

    if (currentTransactions.length > 4) {
      currentTransactions.removeLast();
    }

    if (newTransaction.type == TransactionType.expense) {
      balance = TransactionsBalance(
        totalIncome: balance.totalIncome,
        totalExpense: balance.totalExpense + newTransaction.amount,
        total: balance.total - newTransaction.amount,
      );
    } else {
      balance = TransactionsBalance(
        totalIncome: balance.totalIncome + newTransaction.amount,
        totalExpense: balance.totalExpense,
        total: balance.total + newTransaction.amount,
      );
    }

    state = state.copyWith(lastTransactions: currentTransactions, error: null);
  }
}
