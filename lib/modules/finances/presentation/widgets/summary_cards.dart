import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:desenrolai/core/extensions/int_extensions.dart';
import 'package:desenrolai/core/theme/app_colors.dart';
import 'package:desenrolai/modules/finances/presentation/view_models/home_viewmodel.dart';

class SummaryCards extends ConsumerWidget {
  const SummaryCards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsBalance = ref.read(homeProvider.notifier).balance;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          _SummaryCard.income(
            title: 'Entradas',
            amount: transactionsBalance.totalIncome,
          ),
          const SizedBox(width: 12),
          _SummaryCard.expense(
            title: 'Saídas',
            amount: transactionsBalance.totalExpense,
          ),
        ],
      ),
    );
  }
}

enum SummaryCardType { income, expense }

class _SummaryCard extends StatelessWidget {
  final String title;
  final int amount;
  final SummaryCardType type;

  const _SummaryCard.income({required this.title, required this.amount})
    : type = SummaryCardType.income;
  const _SummaryCard.expense({required this.title, required this.amount})
    : type = SummaryCardType.expense;

  @override
  Widget build(BuildContext context) {
    final darkColorIconBox =
        type == SummaryCardType.income ? Color(0xFF0A0A17) : Color(0xFF170A0A);
    final lightColorIconBox =
        type == SummaryCardType.income ? Color(0xFFEEEEFB) : Color(0xFFFBEEEE);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? darkColorIconBox
                        : lightColorIconBox,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Transform.rotate(
                angle:
                    type == SummaryCardType.income
                        ? 0
                        : 3.14159, // 180 degrees in radians
                child: SvgPicture.asset(
                  'assets/svgs/right_up_arrow_icon.svg',
                  width: 24,
                  semanticsLabel: 'Seta apontando na diagonal para cima',
                  colorFilter: ColorFilter.mode(
                    type == SummaryCardType.income
                        ? Theme.of(context).primaryColor
                        : AppColors.red,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 2),
                Text(
                  amount.toBRL(),
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
