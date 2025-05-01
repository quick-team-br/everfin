import 'package:flutter/material.dart';

import 'package:everfin/core/extensions/int_extensions.dart';
import 'package:everfin/core/theme/app_colors.dart';
import 'package:everfin/modules/home/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(top: 12, bottom: 12, right: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 28,
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color:
                  transaction.type == TransactionType.income
                      ? Theme.of(context).primaryColor
                      : AppColors.red,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(transaction.categoryName),
                    Text(
                      transaction.type == TransactionType.income
                          ? '+ ${transaction.amount.toBRL()}'
                          : '- ${transaction.amount.toBRL()}',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
