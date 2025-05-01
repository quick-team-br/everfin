import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/core/theme/app_gradients.dart';
import 'package:everfin/shared/widgets/gradient_button.dart';
import 'package:everfin/shared/widgets/modey_text_field.dart';

class EditLimitsBottomSheet extends ConsumerWidget {
  const EditLimitsBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31.5),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1,
          colors: [
            Theme.of(context).primaryColor.withAlpha(36),
            Colors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 4,
              width: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.symmetric(vertical: 24),
            ),
            Text(
              "Editar limites",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 6),
            Text("Altere os limites que deseja por categoria"),
            const SizedBox(height: 24),
            MoneyTextField(label: "Valor", onChanged: (_) {}),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(top: 32, bottom: 24),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Voltar"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GradientButton(
                      text: "Confirmar",
                      gradient: AppGradients.primary,
                      // icon:
                      //     state.isLoading
                      //         ? SizedBox(
                      //           width: 16,
                      //           height: 16,
                      //           child: CircularProgressIndicator(
                      //             color: Colors.white,
                      //             strokeWidth: 1,
                      //           ),
                      //         )
                      //         : null,
                      onPressed: null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
