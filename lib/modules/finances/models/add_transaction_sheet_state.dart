import 'package:desenrolai/modules/finances/models/transaction_category.dart';
import 'package:desenrolai/modules/finances/models/transaction_model.dart';

class AddTransactionSheetState {
  final TransactionType selectedType;
  final TransactionCategory? category;
  final bool isLoading;
  final List<TransactionCategory> availableCategories;
  final bool isValid;

  static const _unset = Object();

  const AddTransactionSheetState({
    this.selectedType = TransactionType.income,
    this.category,
    this.isLoading = false,
    this.availableCategories = const [],
    this.isValid = false,
  });

  AddTransactionSheetState copyWith({
    TransactionType? selectedType,
    Object? category = _unset,
    bool? isLoading,
    List<TransactionCategory>? availableCategories,
    bool? isValid,
  }) {
    return AddTransactionSheetState(
      selectedType: selectedType ?? this.selectedType,
      category:
          category == _unset ? this.category : category as TransactionCategory?,
      isLoading: isLoading ?? this.isLoading,
      availableCategories: availableCategories ?? this.availableCategories,
      isValid: isValid ?? this.isValid,
    );
  }
}
