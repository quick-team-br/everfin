// home_view.dart

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/modules/auth/controller/auth_controller.dart';
import 'package:everfin/modules/home/models/transaction_model.dart';
import 'package:everfin/modules/home/presentation/view_models/add_transaction_sheet_viewmodel.dart';
import 'package:everfin/modules/home/presentation/view_models/home_viewmodel.dart';
import 'package:everfin/modules/home/presentation/views/add_transaction_bottom_sheet.dart';
import 'package:everfin/modules/home/presentation/widgets/balance_card.dart';
import 'package:everfin/modules/home/presentation/widgets/month_selector.dart';
import 'package:everfin/modules/home/presentation/widgets/recent_transactions.dart';
import 'package:everfin/modules/home/presentation/widgets/summary_cards.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeProvider);

    final user = ref.watch(authControllerProvider).user;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            BalanceCard(
              balance: ref.read(homeProvider.notifier).balance.total,
              headerActionLeft: const CircleAvatar(radius: 20),
              headerTitle: Text.rich(
                TextSpan(
                  text: 'Olá, ',
                  style: TextStyle(fontWeight: FontWeight.w300),
                  children: [
                    TextSpan(
                      text: user?.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.titleSmall?.color,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              headerActionRight: IconButton.outlined(
                icon: Icon(Icons.arrow_back_outlined),
                onPressed: ref.watch(authControllerProvider.notifier).logout,
              ),
            ),
            const SizedBox(height: 28),
            MonthSelector(
              onChange: (monthIndex) {
                ref
                    .watch(homeProvider.notifier)
                    .loadHomeTransactionsData(monthIndex + 1);
              },
            ),
            if (homeState.isLoading) ...[
              const SizedBox(height: 200),
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1.4,
                ),
              ),
            ] else ...[
              const SizedBox(height: 28),
              SummaryCards(),
              const SizedBox(height: 28),
              RecentTransactions(),
              const SizedBox(height: 100),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTransaction = await showModalBottomSheet<Transaction?>(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return const AddTransactionBottomSheet();
            },
          ).whenComplete(() {
            ref.read(addTransactionSheetViewModelProvider.notifier).reset();
          });

          if (newTransaction != null) {
            ref
                .watch(homeProvider.notifier)
                .updateLastTransactions(newTransaction);
          }
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
