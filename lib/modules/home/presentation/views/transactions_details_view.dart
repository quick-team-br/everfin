import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import 'package:everfin/core/theme/app_colors.dart';
import 'package:everfin/modules/home/models/transaction_model.dart';
import 'package:everfin/modules/home/presentation/view_models/add_transaction_sheet_viewmodel.dart';
import 'package:everfin/modules/home/presentation/view_models/transactions_details_viewmodel.dart';
import 'package:everfin/modules/home/presentation/views/add_transaction_bottom_sheet.dart';
import 'package:everfin/modules/home/presentation/views/edit_limits_bottom_sheet.dart';
import 'package:everfin/modules/home/presentation/widgets/balance_card.dart';
import 'package:everfin/modules/home/presentation/widgets/categories_summary.dart';
import 'package:everfin/modules/home/presentation/widgets/month_selector.dart';
import 'package:everfin/modules/home/presentation/widgets/transaction_item.dart';
import 'package:everfin/shared/helpers/dashed_outline_border.dart';
import 'package:everfin/shared/widgets/custom_tab_selector.dart';

class TransactionDetailsView extends ConsumerWidget {
  const TransactionDetailsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsDetailsState = ref.watch(transactionsDetailsProvider);
    final filteredTransactions =
        ref.read(transactionsDetailsProvider.notifier).filteredTransactions;
    final chartCategories =
        ref.read(transactionsDetailsProvider.notifier).chartCategories;
    final primaryColor =
        transactionsDetailsState.filterType == TransactionType.expense
            ? AppColors.red
            : Theme.of(context).colorScheme.primary;
    final filterType = transactionsDetailsState.filterType;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            BalanceCard(
              primaryColor: primaryColor,
              balanceDescription:
                  filterType == null
                      ? "Saldo do mês"
                      : filterType == TransactionType.income
                      ? "Total de entradas"
                      : "Total de saídas",
              balance:
                  ref.read(transactionsDetailsProvider.notifier).balance.total,
              headerActionLeft: IconButton.outlined(
                icon: SvgPicture.asset(
                  'assets/svgs/left_arrow_icon.svg',
                  width: 24,
                  semanticsLabel: 'Seta apontando para esquerda',
                ),
                onPressed: () {
                  context.go("/home");
                },
              ),
              headerTitle: Text(
                "Movimentações",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              headerActionRight: IconButton.outlined(
                icon: SvgPicture.asset(
                  'assets/svgs/search_icon.svg',
                  width: 24,
                  semanticsLabel: 'Lupa de pesquisa',
                ),
                onPressed: () {},
              ),
            ),
            const SizedBox(height: 28),
            MonthSelector(
              onChange: (monthIndex) {
                ref
                    .read(transactionsDetailsProvider.notifier)
                    .loadAllTransactionsData(monthIndex + 1);
              },
            ),
            const SizedBox(height: 28),
            if (transactionsDetailsState.isLoading) ...[
              const SizedBox(height: 200),
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor,
                  strokeWidth: 1.4,
                ),
              ),
            ] else ...[
              CategoriesSummary(items: chartCategories),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomTabSelector(
                  containerDecoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  tabs: ['Visão Geral', 'Entrada', 'Saída'],
                  primaryColor: primaryColor,
                  initialIndex: 0,
                  onTabChanged: (index) {
                    if (index == 0) {
                      ref
                          .read(transactionsDetailsProvider.notifier)
                          .setFilterType(null);
                    } else if (index == 1) {
                      ref
                          .read(transactionsDetailsProvider.notifier)
                          .setFilterType(TransactionType.income);
                    } else if (index == 2) {
                      ref
                          .read(transactionsDetailsProvider.notifier)
                          .setFilterType(TransactionType.expense);
                    }
                  },
                ),
              ),
              const SizedBox(height: 28),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: DashedOutlineBorder(
                              borderRadius: BorderRadius.circular(12),
                              dashPattern: 8,
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.outline,
                                width: 1,
                              ),
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) {
                                return const AddTransactionBottomSheet();
                              },
                            ).whenComplete(() {
                              ref
                                  .read(
                                    addTransactionSheetViewModelProvider
                                        .notifier,
                                  )
                                  .reset();
                            });
                          },
                          icon: Icon(Icons.add),
                          label: Text("Adicionar"),
                        ),
                      ),
                    ),
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          shape: DashedOutlineBorder(
                            borderRadius: BorderRadius.circular(12),
                            dashPattern: 8,
                            side: BorderSide(
                              color: Theme.of(context).colorScheme.outline,
                              width: 1,
                            ),
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return EditLimitsBottomSheet(
                                categoryLimits:
                                    ref
                                        .read(
                                          transactionsDetailsProvider.notifier,
                                        )
                                        .expenseCategoryLimits,
                              );
                            },
                          );
                        },
                        icon: SvgPicture.asset(
                          'assets/svgs/edit_icon.svg',
                          width: 24,
                          semanticsLabel: "Icone de edição",
                        ),
                        label: Text("Limite"),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    ...filteredTransactions.map((transaction) {
                      return TransactionItem(transaction: transaction);
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ],
        ),
      ),
    );
  }
}
