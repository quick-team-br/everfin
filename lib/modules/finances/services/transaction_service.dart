import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/core/services/network/dio_client.dart';
import 'package:desenrolai/modules/finances/models/transaction_category.dart';
import 'package:desenrolai/modules/finances/models/transaction_category_limit.dart';
import 'package:desenrolai/modules/finances/models/transactions_balance.dart';
import 'package:desenrolai/shared/models/service_response.dart';

import '../models/transaction_model.dart';

class TransactionService {
  final Dio _dio;

  TransactionService(this._dio);

  Future<ServiceResponse<List<Transaction>>> fetchTransactionsByMonth(
    int month,
    int limit,
    String userId,
  ) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, month, 1).toIso8601String();
    final endDate =
        DateTime(now.year, month + 1, 0, 23, 59, 59, 999).toIso8601String();

    try {
      final response = await _dio.get(
        '/v1/transactions?user_id=$userId&start_date=${startDate}Z&end_date=${endDate}Z',
      );

      return ServiceResponse.success(
        List<Transaction>.from(
          (response.data['data']).map(
            (transaction) => Transaction.fromJson(transaction),
          ),
        ),
      );
    } on Exception catch (e) {
      print("Error fetching transactions: $e");
      return ServiceResponse.failure("Error fetching transactions");
    }
  }

  Future<ServiceResponse<String>> addTransaction(
    String description,
    int amount,
    String categoryId,
    TransactionType type,
  ) async {
    try {
      final response = await _dio.post(
        '/v1/transactions',
        data: {
          'title': description,
          'amount': amount,
          'category_id': categoryId,
          'type': type.name,
          'date': '${DateTime.now().toIso8601String()}Z',
          'source': "app",
          'user_id': "01974291-c929-7c9d-ba32-e56769228bf4",
        },
      );

      return ServiceResponse.success(
        response.data['data']['transaction']['id'],
      );
    } catch (e) {
      print("Error creating transaction: $e");
      return ServiceResponse.failure("Error creating transaction");
    }
  }

  Future<ServiceResponse<String>> editTransaction(Transaction t) async {
    try {
      final response = await _dio.patch(
        '/v1/transactions/${t.id}?user_id=01974291-c929-7c9d-ba32-e56769228bf4',
        data: {
          'title': t.description,
          'amount': t.amount,
          'category_id': t.categoryId,
          'type': t.type.name,
          'date': '${DateTime.now().toIso8601String()}Z',
          'source': "app",
        },
      );

      return ServiceResponse.success(
        response.data['data']['transaction']['id'],
      );
    } catch (e) {
      print("Error editing transaction: $e");
      return ServiceResponse.failure("Error editing transaction");
    }
  }

  Future<ServiceResponse<String>> deleteTransaction(String id) async {
    print("id: $id");
    try {
      // final response = await _dio.delete(
      //   '/v1/transactions/$id?user_id=01974291-c929-7c9d-ba32-e56769228bf4',
      // );

      // print("response: $response");

      // return ServiceResponse.success(id);
      return ServiceResponse.failure("Error deleting transaction");
    } catch (e) {
      print("Error deleting transaction: $e");
      return ServiceResponse.failure("Error deleting transaction");
    }
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
      final response = await _dio.get('/v1/categories');

      return List<TransactionCategory>.from(
        (response.data['data']).map((cat) => TransactionCategory.fromJson(cat)),
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

final transactionServiceProvider = Provider<TransactionService>((ref) {
  final dio = ref.read(dioClientProvider);
  return TransactionService(dio);
});
