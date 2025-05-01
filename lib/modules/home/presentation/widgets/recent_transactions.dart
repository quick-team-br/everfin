import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:everfin/modules/home/presentation/view_models/home_viewmodel.dart';
import 'package:everfin/modules/home/presentation/widgets/transaction_item.dart';

import './section_header.dart';

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
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Column(
                children: [
                  ...transactions.map((transaction) {
                    return TransactionItem(transaction: transaction);
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
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Theme.of(context).scaffoldBackgroundColor,
                          Colors.transparent,
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
