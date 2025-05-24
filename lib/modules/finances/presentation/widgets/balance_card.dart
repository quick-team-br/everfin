import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/core/extensions/int_extensions.dart';

class BalanceCard extends ConsumerWidget {
  const BalanceCard({
    required this.headerTitle,
    required this.headerActionLeft,
    required this.headerActionRight,
    required this.balance,
    this.balanceDescription,
    this.primaryColor,
    super.key,
  });

  final Widget headerTitle;
  final Widget headerActionLeft;
  final Widget headerActionRight;
  final int balance;
  final String? balanceDescription;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final transactionsBalanceSplit = balance.toBRL().split(',');
    final currentPrimaryColor = primaryColor ?? Theme.of(context).primaryColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          gradient: LinearGradient(
            colors: [
              currentPrimaryColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            stops: [0.0, .65],
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: statusBarHeight),
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(31.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: 429,
                  height: 429,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        currentPrimaryColor.withAlpha(40),
                        Theme.of(context).scaffoldBackgroundColor.withAlpha(0),
                      ],
                      radius: .7,
                      center: const Alignment(0, -0.15),
                      stops: const [0.0, .7],
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).scaffoldBackgroundColor.withAlpha(2),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      headerActionLeft,
                      headerTitle,
                      headerActionRight,
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    balanceDescription ?? 'Saldo do Mês',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.titleSmall?.color?.withAlpha(153),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text.rich(
                    TextSpan(
                      text: transactionsBalanceSplit.first,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: ',${transactionsBalanceSplit.last}',
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
