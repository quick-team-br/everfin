import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';

class EmptyTransactionList extends StatelessWidget {
  const EmptyTransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/svgs/empty_list_movs_${theme.brightness.name}.svg',
              height: 120,
              semanticsLabel: 'Lista vazia',
            ),
            const SizedBox(height: 32),
            Text(
              'Nenhuma movimentação',
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 8),
                Text('Pressione'),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.add,
                    size: 16,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text('para adicionar entradas e'),
              ],
            ),
            const SizedBox(height: 8),
            Text(' saídas.'),
          ],
        ),
      ),
    );
  }
}
