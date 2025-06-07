enum TransactionType { income, expense }

class Transaction {
  final String id;
  final String description;
  final String categoryId;
  final String categoryName;
  final TransactionType type;
  final int amount;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.categoryId,
    required this.categoryName,
    required this.description,
  });

  Transaction copyWith({
    String? id,
    String? description,
    String? categoryId,
    String? categoryName,
    TransactionType? type,
    int? amount,
  }) {
    return Transaction(
      id: id ?? this.id,
      description: description ?? this.description,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      type: type ?? this.type,
      amount: amount ?? this.amount,
    );
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['title'],
      categoryId: json['category_id'],
      categoryName: json['category_id'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['type']}',
      ),
      amount: json['amount'],
    );
  }
}
