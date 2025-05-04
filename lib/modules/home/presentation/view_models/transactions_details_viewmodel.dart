import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/core/extensions/list_extensions.dart';
import 'package:everfin/modules/home/models/transaction_category_limit.dart';
import 'package:everfin/modules/home/models/transaction_model.dart';
import 'package:everfin/modules/home/models/transactions_balance.dart';
import 'package:everfin/modules/home/models/transactions_details_state.dart';
import 'package:everfin/modules/home/presentation/widgets/categories_summary.dart';

import '../../services/transaction_service.dart';

import 'month_selector_viewmodel.dart';

final transactionsDetailsProvider = StateNotifierProvider.autoDispose<
  TransactionsDetails,
  TransactionsDetailsState
>((ref) => TransactionsDetails(ref));

class TransactionsDetails extends StateNotifier<TransactionsDetailsState> {
  final Ref ref;
  TransactionsBalance balance = TransactionsBalance(
    totalIncome: 0,
    totalExpense: 0,
    total: 0,
  );
  List<ExpenseCategoryLimit> expenseCategoryLimits = [];

  TransactionsDetails(this.ref) : super(TransactionsDetailsState()) {
    final selectedMonth = ref.read(monthSelectorProvider) + 1;

    state = state.copyWith(isLoading: true);
    loadPreferences();
    loadAllTransactionsData(selectedMonth);
  }

  Future<void> loadAllTransactionsData(int monthIndex) async {
    state = state.copyWith(isLoading: true);

    balance = await TransactionService().getBalance(monthIndex);

    final transactions = await TransactionService().fetchTransactionsForMonth(
      monthIndex,
      100,
    );

    state = state.copyWith(isLoading: false, transactions: transactions);
  }

  Future<void> loadPreferences() async {
    expenseCategoryLimits =
        await TransactionService().fetchExpenseCategoryLimits();
  }

  void setFilterType(TransactionType? type) {
    state = state.copyWith(filterType: type);
  }

  get filteredTransactions {
    if (state.filterType == null) {
      return state.transactions;
    }
    return state.transactions
        .where((transaction) => transaction.type == state.filterType)
        .toList();
  }

  List<SummaryRowData> get chartCategories {
    if (state.filterType == null) {
      return [
        SummaryRowData(
          name: "Entradas",
          color: Colors.lightBlue,
          value: balance.totalIncome,
        ),
        SummaryRowData(
          name: "Saídas",
          color: Colors.redAccent,
          value: balance.totalExpense,
        ),
      ];
    }
    return _groupTransactionsByType(state.filterType!);
  }

  List<SummaryRowData> _groupTransactionsByType(TransactionType type) {
    final incomeTransactions = state.transactions
        .where((t) => t.type == type)
        .groupBy((t) => t.categoryId);

    return incomeTransactions.entries.map((entry) {
      final categoryTotal = entry.value.fold(0, (sum, t) => sum + t.amount);
      final categoryName = entry.value.first.categoryName;
      final categoryId = entry.value.first.categoryId;

      return SummaryRowData(
        name: categoryName,
        color: Colors.lightBlue,
        value: categoryTotal,
        limit:
            expenseCategoryLimits
                .firstWhere((catLimit) => catLimit.id == categoryId)
                .limit,
      );
    }).toList();
  }
}
