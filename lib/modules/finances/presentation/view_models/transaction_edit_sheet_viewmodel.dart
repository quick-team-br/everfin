import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/modules/finances/models/transaction_category.dart';
import 'package:desenrolai/modules/finances/models/transaction_edit_state.dart';
import 'package:desenrolai/modules/finances/models/transaction_model.dart';
import 'package:desenrolai/modules/finances/services/transaction_service.dart';

class TransactionEditSheetViewModel
    extends StateNotifier<TransactionEditSheetState> {
  final TransactionService transactionService;

  TransactionEditSheetViewModel(this.transactionService)
    : super(TransactionEditSheetState()) {
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

  void setCategory(TransactionCategory? newCategory) {
    state = state.copyWith(
      currentTransaction: state.currentTransaction?.copyWith(
        categoryId: newCategory?.id,
        categoryName: newCategory?.description,
      ),
    );
  }

  void initState(Transaction t) {
    originalTransaction = t;

    state = state.copyWith(currentTransaction: t);
  }

  Future<void> loadCategories() async {
    final categories = await transactionService.fetchCategories();

    state = state.copyWith(
      formState: TransactionEditFormState.idle,
      availableCategories: categories,
    );
  }

  Future<Transaction?> editTransaction() async {
    if (state.currentTransaction == null) return null;

    state = state.copyWith(formState: TransactionEditFormState.saving);

    final serviceResponse = await transactionService.editTransaction(
      state.currentTransaction!,
    );

    if (serviceResponse.success) {
      return state.currentTransaction;
    }

    return null;
  }

  Future<Transaction?> deleteTransaction() async {
    if (state.currentTransaction == null) return null;

    state = state.copyWith(formState: TransactionEditFormState.saving);

    final serviceResponse = await transactionService.deleteTransaction(
      state.currentTransaction!.id,
    );

    if (serviceResponse.success) {
      return state.currentTransaction;
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
    >(
      (ref) =>
          TransactionEditSheetViewModel(ref.read(transactionServiceProvider)),
    );
