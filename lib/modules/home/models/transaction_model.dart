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

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      description: json['description'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      type: TransactionType.values.firstWhere(
        (e) => e.toString() == 'TransactionType.${json['type']}',
      ),
      amount: json['amount'],
    );
  }
}
