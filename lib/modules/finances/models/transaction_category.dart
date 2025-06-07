import 'dart:ui';

import 'package:desenrolai/modules/finances/models/transaction_model.dart';

class TransactionCategory {
  final String description;
  final String id;
  final TransactionType type;
  final Color? color;
  final int? limit;

  const TransactionCategory({
    required this.description,
    required this.id,
    required this.type,
    this.limit,
    this.color,
  });

  factory TransactionCategory.fromJson(Map<String, dynamic> json) {
    return TransactionCategory(
      id: json['id'],
      // type: TransactionType.values.firstWhere(
      //   (e) => e.toString() == 'TransactionType.${json['type']}',
      // ),
      type: TransactionType.expense,
      description: json['name'],
    );
  }
}
