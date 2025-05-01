class TransactionsBalance {
  final int totalIncome;
  final int totalExpense;
  final int total;

  const TransactionsBalance({
    required this.totalIncome,
    required this.totalExpense,
    required this.total,
  });

  factory TransactionsBalance.fromJson(Map<String, dynamic> json) {
    return TransactionsBalance(
      totalIncome: json['total_income']?.toInt() ?? 0,
      totalExpense: json['total_expense']?.toInt() ?? 0,
      total: json['balance']?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'balance': total,
    };
  }
}
