import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/core/theme/app_colors.dart';
import 'package:desenrolai/modules/finances/models/add_transaction_sheet_state.dart';
import 'package:desenrolai/modules/finances/models/transaction_category.dart';
import 'package:desenrolai/modules/finances/services/transaction_service.dart';

import '../../models/transaction_model.dart';

class AddTransactionSheetViewModel
    extends StateNotifier<AddTransactionSheetState> {
  final TransactionService transactionService;

  AddTransactionSheetViewModel(this.transactionService)
    : super(AddTransactionSheetState()) {
    loadCategories();
  }
  int amount = 0;
  String description = "";

  void validateTransaction() {
    final isValid =
        amount != 0 && description.isNotEmpty && state.category != null;

    if (state.isValid != isValid) {
      state = state.copyWith(isValid: isValid);
    }
  }

  void setType(TransactionType newSelectedType) {
    state = state.copyWith(selectedType: newSelectedType, category: null);
  }

  void setCategory(TransactionCategory? newCategory) {
    state = state.copyWith(category: newCategory);
    validateTransaction();
  }

  void setAmount(int newAmount) {
    amount = newAmount;
    validateTransaction();
  }

  void setDescription(String desc) {
    description = desc;
    validateTransaction();
  }

  void reset() {
    amount = 0;
    description = "";
    state = state.copyWith(category: null);
  }

  Future<Transaction?> addNewTransaction() async {
    state = state.copyWith(isLoading: true);

    final serviceResponse = await transactionService.addTransaction(
      description,
      amount,
      state.category!.id,
      state.selectedType,
    );

    state = state.copyWith(isLoading: false);

    if (serviceResponse.success) {
      return Transaction(
        id: serviceResponse.data!,
        description: description,
        categoryId: state.category!.id,
        categoryName: state.category!.description,
        type: state.selectedType,
        amount: amount,
      );
    }

    return null;
  }

  Color getGradientColor(BuildContext context) {
    switch (state.selectedType) {
      case TransactionType.income:
        return Theme.of(context).colorScheme.primary;
      case TransactionType.expense:
        return AppColors.red;
    }
  }

  Future<void> loadCategories() async {
    state = state.copyWith(isLoading: true);

    final categories = await transactionService.fetchCategories();

    state = state.copyWith(isLoading: false, availableCategories: categories);
  }

  List<TransactionCategory> get filteredCategories =>
      state.availableCategories
          .where((category) => category.type == state.selectedType)
          .toList();
}

final addTransactionSheetViewModelProvider = StateNotifierProvider.autoDispose<
  AddTransactionSheetViewModel,
  AddTransactionSheetState
>((ref) => AddTransactionSheetViewModel(ref.read(transactionServiceProvider)));
