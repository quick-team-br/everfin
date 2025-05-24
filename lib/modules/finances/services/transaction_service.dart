import 'package:desenrolai/modules/finances/models/transaction_category.dart';
import 'package:desenrolai/modules/finances/models/transaction_category_limit.dart';
import 'package:desenrolai/modules/finances/models/transactions_balance.dart';

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
      return List<Transaction>.from(
        ([]).map((transaction) => Transaction.fromJson(transaction)),
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
      return null;
    } catch (e) {
      print("Error creating transaction: $e");
    }
    return null;
  }

  Future<String?> editTransaction(Transaction t) async {
    try {
      return null;
    } catch (e) {
      print("Error editing transaction: $e");
    }
    return null;
  }

  Future<String?> deleteTransaction(String id) async {
    try {
      return null;
    } catch (e) {
      print("Error deleting transaction: $e");
    }
    return null;
  }

  Future<TransactionsBalance> getBalance(int month) async {
    try {
      final data = {'totalIncome': 0, 'totalExpense': 0, 'total': 0};
      return TransactionsBalance.fromJson(data);
    } catch (e) {
      print("Error fetching balance: $e");
    }
    return TransactionsBalance(totalIncome: 0, totalExpense: 0, total: 0);
  }

  Future<List<TransactionCategory>> fetchCategories() async {
    try {
      return List<TransactionCategory>.from(
        ([]).map((cat) => TransactionCategory.fromJson(cat)),
      );
    } catch (e) {
      print("Error fetching categories: $e");
    }
    return [];
  }

  Future<List<ExpenseCategoryLimit>> fetchExpenseCategoryLimitsByMonth(
    int month,
  ) async {
    try {
      return List<ExpenseCategoryLimit>.from(
        ([]).map((preference) => ExpenseCategoryLimit.fromJson(preference)),
      );
    } catch (e) {
      print("Error fetching expense preferences: $e");
      return [];
    }
  }
}
