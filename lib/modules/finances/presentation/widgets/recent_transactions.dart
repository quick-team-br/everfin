import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:desenrolai/modules/finances/models/transaction_model.dart';
import 'package:desenrolai/modules/finances/presentation/view_models/home_viewmodel.dart';
import 'package:desenrolai/modules/finances/presentation/view_models/month_selector_viewmodel.dart';
import 'package:desenrolai/modules/finances/presentation/views/transaction_edit_bottom_sheet.dart';
import 'package:desenrolai/modules/finances/presentation/widgets/transaction_item.dart';
import 'package:desenrolai/shared/widgets/empty_transaction_list.dart';

import 'section_header.dart';

class RecentTransactions extends ConsumerWidget {
  const RecentTransactions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(homeProvider).lastTransactions;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: 'Transações recentes',
            buttonText: 'Ver mais',
            onButtonPressed: () {
              context.go("/home/transactionsDetails");
            },
            showButton: transactions.isNotEmpty,
          ),
          const SizedBox(height: 12),
          transactions.isEmpty
              ? const EmptyTransactionList()
              : Stack(
                children: [
                  Column(
                    spacing: 16,
                    children: [
                      ...transactions.map((transaction) {
                        return TransactionItem(
                          transaction: transaction,
                          onTap: () async {
                            final result = await showModalBottomSheet<
                              (Transaction?, String?)
                            >(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return TransactionEditBottomSheet(
                                  transactionItem: transaction,
                                );
                              },
                            );

                            if (result != null) {
                              if (result.$1 != null) {
                                ref
                                    .read(homeProvider.notifier)
                                    .loadHomeTransactionsData(
                                      ref.read(monthSelectorProvider) + 1,
                                    );
                              }
                            }
                          },
                        );
                      }),
                    ],
                  ),
                  if (transactions.length > 2)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 124,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(
                                context,
                              ).scaffoldBackgroundColor.withAlpha(0),
                              Theme.of(context).scaffoldBackgroundColor,
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
        ],
      ),
    );
  }
}
