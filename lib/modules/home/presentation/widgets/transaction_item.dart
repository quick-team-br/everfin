import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

import 'package:everfin/core/extensions/int_extensions.dart';
import 'package:everfin/core/theme/app_colors.dart';
import 'package:everfin/modules/home/models/transaction_model.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final Function()? onTap;

  const TransactionItem({super.key, this.onTap, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 12, right: 16),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          transaction.description,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Transform.rotate(
                          angle: -math.pi / 2.0, // 90 degrees in radians
                          child: SvgPicture.asset(
                            'assets/svgs/arrow_with_shadow_icon.svg',
                            width: 20,
                            semanticsLabel: "Abrir",
                            colorFilter: ColorFilter.mode(
                              Theme.of(context).textTheme.bodyMedium?.color ??
                                  Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ],
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
        ),
      ),
    );
  }
}
