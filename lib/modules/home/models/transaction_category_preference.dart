class ExpenseCategoryPreference {
  final String id;
  final int limit;

  const ExpenseCategoryPreference({required this.id, required this.limit});

  factory ExpenseCategoryPreference.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryPreference(id: json['id'], limit: json["amount"]);
  }
}
