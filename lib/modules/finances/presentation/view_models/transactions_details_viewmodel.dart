import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/core/extensions/list_extensions.dart';
import 'package:desenrolai/modules/auth/controller/auth_controller.dart';
import 'package:desenrolai/modules/finances/models/transaction_category_limit.dart';
import 'package:desenrolai/modules/finances/models/transaction_model.dart';
import 'package:desenrolai/modules/finances/models/transactions_balance.dart';
import 'package:desenrolai/modules/finances/models/transactions_details_state.dart';
import 'package:desenrolai/modules/finances/presentation/widgets/categories_summary.dart';

import '../../services/transaction_service.dart';

import 'month_selector_viewmodel.dart';

final transactionsDetailsProvider = StateNotifierProvider.autoDispose<
  TransactionsDetails,
  TransactionsDetailsState
>((ref) => TransactionsDetails(ref, ref.read(transactionServiceProvider)));

class TransactionsDetails extends StateNotifier<TransactionsDetailsState> {
  final Ref ref;
  final TransactionService transactionService;

  TransactionsBalance balance = TransactionsBalance(
    totalIncome: 0,
    totalExpense: 0,
    total: 0,
  );
  List<ExpenseCategoryLimit> expenseCategoryLimits = [];
  int lastTabIndex = 0;

  TransactionsDetails(this.ref, this.transactionService)
    : super(TransactionsDetailsState()) {
    final selectedMonth = ref.read(monthSelectorProvider) + 1;

    state = state.copyWith(isLoading: true);
    loadPreferences(selectedMonth);
    loadAllTransactionsData(selectedMonth);
  }

  Future<void> loadAllTransactionsData(int monthIndex) async {
    state = state.copyWith(isLoading: true);

    balance = await transactionService.getBalance(monthIndex);

    final serviceResponse = await transactionService.fetchTransactionsByMonth(
      monthIndex,
      100,
      ref.read(authControllerProvider).user!.id,
    );

    state = state.copyWith(
      isLoading: false,
      transactions: serviceResponse.data,
    );
  }

  Future<void> loadPreferences(int selectedMonth) async {
    expenseCategoryLimits = await transactionService
        .fetchExpenseCategoryLimitsByMonth(selectedMonth);
  }

  void setFilterType(TransactionType? type) {
    state = state.copyWith(filterType: type);
  }

  void onChangeTabFilter(int index) {
    lastTabIndex = index;
    if (index == 0) {
      setFilterType(null);
    } else if (index == 1) {
      setFilterType(TransactionType.income);
    } else if (index == 2) {
      setFilterType(TransactionType.expense);
    }
  }

  get filteredTransactions {
    if (state.filterType == null) {
      return state.transactions;
    }
    return state.transactions
        .where((transaction) => transaction.type == state.filterType)
        .toList();
  }

  get balanceDescription {
    if (state.filterType == null) {
      return "Saldo total";
    } else if (state.filterType == TransactionType.income) {
      return "Entradas";
    } else if (state.filterType == TransactionType.expense) {
      return "Saídas";
    }
  }

  get balanceValueByType {
    if (state.filterType == null) {
      return balance.total;
    } else if (state.filterType == TransactionType.income) {
      return balance.totalIncome;
    } else if (state.filterType == TransactionType.expense) {
      return balance.totalExpense;
    }
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
            type == TransactionType.expense
                ? expenseCategoryLimits
                    .firstWhere(
                      (catLimit) => catLimit.id == categoryId,
                      orElse:
                          () => ExpenseCategoryLimit(
                            id: categoryId,
                            limit: 0,
                            name: categoryName,
                          ),
                    )
                    .limit
                : null,
      );
    }).toList();
  }

  Future<void> addTransaction(Transaction transaction) async {
    state = state.copyWith(transactions: [...state.transactions, transaction]);
  }

  Future<void> editTransaction(Transaction transaction) async {
    state = state.copyWith(
      transactions:
          state.transactions
              .map((t) => t.id == transaction.id ? transaction : t)
              .toList(),
    );
  }

  Future<void> deleteTransaction(Transaction transaction) async {
    state = state.copyWith(
      transactions:
          state.transactions.where((t) => t.id != transaction.id).toList(),
    );
  }
}
