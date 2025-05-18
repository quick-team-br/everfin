class ExpenseCategoryLimit {
  final String id;
  final String name;
  final int limit;

  const ExpenseCategoryLimit({
    required this.id,
    required this.limit,
    required this.name,
  });

  factory ExpenseCategoryLimit.fromJson(Map<String, dynamic> json) {
    return ExpenseCategoryLimit(
      id: json['category_id'],
      limit: json["monthly_limit"],
      name: json['category_name'],
    );
  }
}
