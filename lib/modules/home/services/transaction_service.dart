import 'dart:convert';

import 'package:everfin/modules/home/models/transaction_category.dart';
import 'package:everfin/modules/home/models/transaction_category_limit.dart';
import 'package:everfin/modules/home/models/transactions_balance.dart';
import 'package:everfin/services/http/auth_interceptor.dart';

import '../models/transaction_model.dart';

class TransactionService {
  Future<List<Transaction>> fetchTransactionsForMonth(
    int month,
    int limit,
  ) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, month, 1).toUtc().toIso8601String();
    final endDate = DateTime.now().toUtc().toIso8601String();

    try {
      final response = await authenticatedPost(
        Uri.parse(
          'https://api.quickteam.com.br/api/v1/users/7743c387-c950-4192-829e-322df9f24810/transactions',
        ),
        body: jsonEncode({
          "start_date": startDate,
          "end_date": endDate,
          "transaction_types": ["income", "expense"],
          "limit": limit,
          "offset": 0,
        }),
      );

      return List<Transaction>.from(
        (jsonDecode(response.body)["transactions"] ?? []).map(
          (transaction) => Transaction.fromJson(transaction),
        ),
      );
    } on Exception catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

  Future<String?> addTransaction(
    String description,
    int amount,
    String categoryId,
    TransactionType type,
  ) async {
    try {
      final response = await authenticatedPost(
        Uri.parse(
          'https://api.quickteam.com.br/api/v1/users/7743c387-c950-4192-829e-322df9f24810/transactions/${type.name}',
        ),
        body: jsonEncode({
          "description": description,
          "amount": amount,
          "category_id": categoryId,
        }),
      );

      return jsonDecode(response.body)["transaction"]["id"];
    } catch (e) {
      print("Error creating transaction: $e");
    }
    return null;
  }

  Future<TransactionsBalance> getBalance(int month) async {
    try {
      final response = await authenticatedGet(
        Uri.parse(
          'https://api.quickteam.com.br/api/v1/users/7743c387-c950-4192-829e-322df9f24810/month-balance?month=$month',
        ),
      );

      final data = jsonDecode(response.body);

      return TransactionsBalance.fromJson(data);
    } catch (e) {
      print("Error fetching balance: $e");
    }
    return TransactionsBalance(totalIncome: 0, totalExpense: 0, total: 0);
  }

  Future<List<TransactionCategory>> fetchCategories() async {
    try {
      final response = await authenticatedGet(
        Uri.parse('https://api.quickteam.com.br/api/v1/categories'),
      );

      return List<TransactionCategory>.from(
        jsonDecode(
          response.body,
        )["categories"].map((cat) => TransactionCategory.fromJson(cat)),
      );
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return [];
  }

  Future<List<ExpenseCategoryLimit>> fetchExpenseCategoryLimits() async {
    try {
      final response = await authenticatedGet(
        Uri.parse(
          'https://api.quickteam.com.br/api/v1/users/7743c387-c950-4192-829e-322df9f24810/category-preferences',
        ),
      );

      return List<ExpenseCategoryLimit>.from(
        jsonDecode(response.body)["preferences"].map(
          (preference) => ExpenseCategoryLimit.fromJson(preference),
        ),
      );
    } catch (e) {
      print("Error fetching expense preferences: $e");
      return [];
    }
  }
}
