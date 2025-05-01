import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/core/theme/app_colors.dart';
import 'package:everfin/modules/home/models/add_transaction_sheet_state.dart';
import 'package:everfin/modules/home/models/transaction_category.dart';
import 'package:everfin/modules/home/services/transaction_service.dart';

import '../../models/transaction_model.dart';

class AddTransactionSheetViewModel
    extends StateNotifier<AddTransactionSheetState> {
  AddTransactionSheetViewModel() : super(AddTransactionSheetState()) {
    loadCategories();
  }
  int amount = 0;
  String description = "";

  void setType(TransactionType newSelectedType) {
    state = state.copyWith(selectedType: newSelectedType, category: null);
  }

  void setCategory(String? newCategory) {
    state = state.copyWith(category: newCategory);
  }

  void setAmount(int newAmount) {
    amount = newAmount;
  }

  void setDescription(String desc) {
    description = desc;
  }

  void reset() {
    amount = 0;
    description = "";
    state = state.copyWith(category: null);
  }

  Future<Transaction?> addNewTransaction() async {
    state = state.copyWith(isLoading: true);
    try {
      final currentCategoryId =
          state.availableCategories
              .firstWhere((category) => category.description == state.category)
              .id;
      final transactionId = await TransactionService().addTransaction(
        description,
        amount,
        currentCategoryId,
        state.selectedType,
      );

      if (transactionId != null) {
        return Transaction(
          id: transactionId,
          description: description,
          categoryId: currentCategoryId,
          categoryName: state.category!,
          type: state.selectedType,
          amount: amount,
        );
      }
    } catch (e, st) {
      print('Error: $e');
      print('StackTrace: $st');
    } finally {
      state = state.copyWith(isLoading: false);
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

    final categories = await TransactionService().fetchCategories();

    state = state.copyWith(isLoading: false, availableCategories: categories);
  }

  List<TransactionCategory> get filteredCategories =>
      state.availableCategories
          .where((category) => category.type == state.selectedType)
          .toList();
}

final addTransactionSheetViewModelProvider = StateNotifierProvider<
  AddTransactionSheetViewModel,
  AddTransactionSheetState
>((ref) => AddTransactionSheetViewModel());
