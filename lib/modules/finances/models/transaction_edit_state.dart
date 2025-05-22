import 'package:everfin/modules/finances/models/transaction_category.dart';
import 'package:everfin/modules/finances/models/transaction_model.dart';

enum TransactionEditFormState { idle, loadingCategories, saving }

class TransactionEditSheetState {
  final List<TransactionCategory> availableCategories;
  final TransactionEditFormState formState;
  final Transaction? currentTransaction;

  const TransactionEditSheetState({
    this.availableCategories = const [],
    this.formState = TransactionEditFormState.loadingCategories,
    this.currentTransaction,
  });

  TransactionEditSheetState copyWith({
    List<TransactionCategory>? availableCategories,
    TransactionEditFormState? formState,
    Transaction? currentTransaction,
  }) {
    return TransactionEditSheetState(
      availableCategories: availableCategories ?? this.availableCategories,
      formState: formState ?? this.formState,
      currentTransaction: currentTransaction ?? this.currentTransaction,
    );
  }
}
