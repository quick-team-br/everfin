import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/modules/home/models/transaction_edit_state.dart';
import 'package:everfin/modules/home/models/transaction_model.dart';
import 'package:everfin/modules/home/services/transaction_service.dart';

class TransactionEditSheetViewModel
    extends StateNotifier<TransactionEditSheetState> {
  TransactionEditSheetViewModel() : super(TransactionEditSheetState()) {
    loadCategories();
  }
  Transaction? originalTransaction;

  void setAmount(int newAmount) {
    state = state.copyWith(
      currentTransaction: state.currentTransaction?.copyWith(amount: newAmount),
    );
  }

  void setDescription(String newDesc) {
    state = state.copyWith(
      currentTransaction: state.currentTransaction?.copyWith(
        description: newDesc,
      ),
    );
  }

  void setCategory(String? newCategory) {
    final currentCategoryId =
        state.availableCategories
            .firstWhere((category) => category.description == newCategory)
            .id;
    state = state.copyWith(
      currentTransaction: state.currentTransaction?.copyWith(
        categoryId: currentCategoryId,
        categoryName: newCategory,
      ),
    );
  }

  void initState(Transaction t) {
    originalTransaction = t;

    state = state.copyWith(currentTransaction: t);
  }

  Future<void> loadCategories() async {
    final categories = await TransactionService().fetchCategories();

    state = state.copyWith(
      formState: TransactionEditFormState.idle,
      availableCategories: categories,
    );
  }

  Future<Transaction?> editTransaction() async {
    if (state.currentTransaction == null) return null;

    state = state.copyWith(formState: TransactionEditFormState.saving);

    try {
      final transactionId = await TransactionService().editTransaction(
        state.currentTransaction!,
      );

      if (transactionId != null) {
        return state.currentTransaction;
      }
    } catch (e, st) {
      print('Error: $e');
      print('StackTrace: $st');
    }
    return null;
  }

  Future<Transaction?> deleteTransaction() async {
    if (state.currentTransaction == null) return null;

    // state = state.copyWith(formState: TransactionEditFormState.saving);

    try {
      final transactionId = await TransactionService().deleteTransaction(
        state.currentTransaction!.id,
      );

      if (transactionId != null) {
        return state.currentTransaction;
      }
    } catch (e, st) {
      print('Error: $e');
      print('StackTrace: $st');
    }
    return null;
  }

  bool get isSaving => state.formState == TransactionEditFormState.saving;

  bool get isLoadingCategories =>
      state.formState == TransactionEditFormState.loadingCategories;

  bool get isDirty {
    if (originalTransaction == null || state.currentTransaction == null) {
      return false;
    }

    return originalTransaction!.amount != state.currentTransaction!.amount ||
        originalTransaction!.description !=
            state.currentTransaction!.description ||
        originalTransaction!.categoryId != state.currentTransaction!.categoryId;
  }

  bool get isValid {
    if (state.currentTransaction == null) return false;

    return state.currentTransaction!.amount != 0 &&
        state.currentTransaction!.description.isNotEmpty;
  }
}

final transactionDetailSheetViewModelProvider =
    StateNotifierProvider.autoDispose<
      TransactionEditSheetViewModel,
      TransactionEditSheetState
    >((ref) => TransactionEditSheetViewModel());
