import 'package:everfin/modules/home/models/transaction_category.dart';
import 'package:everfin/modules/home/models/transaction_model.dart';

class AddTransactionSheetState {
  final TransactionType selectedType;
  final String? category;
  final bool isLoading;
  final List<TransactionCategory> availableCategories;

  static const _unset = Object();

  const AddTransactionSheetState({
    this.selectedType = TransactionType.income,
    this.category,
    this.isLoading = false,
    this.availableCategories = const [],
  });

  AddTransactionSheetState copyWith({
    TransactionType? selectedType,
    Object? category = _unset,
    bool? isLoading,
    List<TransactionCategory>? availableCategories,
  }) {
    return AddTransactionSheetState(
      selectedType: selectedType ?? this.selectedType,
      category: category == _unset ? this.category : category as String?,
      isLoading: isLoading ?? this.isLoading,
      availableCategories: availableCategories ?? this.availableCategories,
    );
  }
}
