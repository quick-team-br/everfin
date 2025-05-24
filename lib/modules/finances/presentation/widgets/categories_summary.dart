import 'package:flutter/material.dart';

import 'package:desenrolai/core/extensions/int_extensions.dart';

class CategoriesSummary extends StatelessWidget {
  final List<SummaryRowData> items;

  const CategoriesSummary({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final someCategoryHasLimit = items.any(
      (cat) => cat.limit != null && cat.limit != 0,
    );
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Categoria"),
              if (someCategoryHasLimit)
                Text.rich(
                  TextSpan(
                    text: "Valor / ",
                    children: [
                      TextSpan(
                        text: "Limite",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withAlpha(200),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Text("Valor"),
            ],
          ),
          const SizedBox(height: 16),
          ...items.map((item) => _subtitleItem(item, context)),
        ],
      ),
    );
  }

  Padding _subtitleItem(SummaryRowData item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: item.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(item.name),
            ],
          ),
          if (item.limit != null)
            Text.rich(
              TextSpan(
                text: item.value.toBRL(),
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
                children: [
                  TextSpan(text: ' / '),
                  TextSpan(
                    text: item.limit!.toBRL(),
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withAlpha(200),
                    ),
                  ),
                ],
              ),
            )
          else
            Text(
              item.value.toBRL(),
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w400),
            ),
        ],
      ),
    );
  }
}

class SummaryRowData {
  final String name;
  final int value;
  final int? limit;
  final Color color;

  SummaryRowData({
    required this.name,
    required this.value,
    required this.color,
    this.limit,
  });
}
