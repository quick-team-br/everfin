import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:toastification/toastification.dart';

import 'package:desenrolai/core/theme/app_gradients.dart';
import 'package:desenrolai/modules/finances/models/transaction_category.dart';
import 'package:desenrolai/modules/finances/models/transaction_model.dart';
import 'package:desenrolai/shared/widgets/custom_dropdown.dart';
import 'package:desenrolai/shared/widgets/custom_tab_selector.dart';
import 'package:desenrolai/shared/widgets/custom_textfield.dart';
import 'package:desenrolai/shared/widgets/gradient_button.dart';
import 'package:desenrolai/shared/widgets/modey_text_field.dart';

import '../view_models/add_transaction_sheet_viewmodel.dart';

class AddTransactionBottomSheet extends ConsumerWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(addTransactionSheetViewModelProvider.notifier);
    final state = ref.watch(addTransactionSheetViewModelProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31.5),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: .7,
          colors: [
            viewModel.getGradientColor(context).withAlpha(36),
            Colors.transparent,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                height: 4,
                width: 32,
                decoration: BoxDecoration(
                  color: viewModel.getGradientColor(context),
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.symmetric(vertical: 24),
              ),
              Text("Adicionar", style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 6),
              Text("Escolha qual tipo de item deseja adicionar"),
              const SizedBox(height: 24),
              CustomTabSelector(
                tabs: ['Entrada', 'Saída'],
                primaryColor: viewModel.getGradientColor(context),
                initialIndex:
                    state.selectedType == TransactionType.income ? 0 : 1,
                onTabChanged: (index) {
                  viewModel.setType(
                    index == 0
                        ? TransactionType.income
                        : TransactionType.expense,
                  );
                },
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: "Descrição",
                onChanged: viewModel.setDescription,
              ),
              const SizedBox(height: 20),
              MoneyTextField(label: "Valor", onChanged: viewModel.setAmount),
              const SizedBox(height: 20),
              CustomDropdown<TransactionCategory>(
                items: viewModel.filteredCategories,
                label: "Categoria",
                itemToString: (item) => item.description,
                selectedItem: state.category,
                onChanged: viewModel.setCategory,
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            state.isLoading
                                ? null
                                : () => Navigator.pop(context),
                        child: const Text("Voltar"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: GradientButton(
                        text: "Confirmar",
                        gradient:
                            state.selectedType == TransactionType.income
                                ? AppGradients.primary
                                : AppGradients.red,
                        icon:
                            state.isLoading
                                ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1,
                                  ),
                                )
                                : null,
                        onPressed:
                            state.isLoading || !state.isValid
                                ? null
                                : () async {
                                  final transaction =
                                      await viewModel.addNewTransaction();

                                  if (context.mounted && transaction == null) {
                                    toastification.show(
                                      context: context,
                                      type: ToastificationType.error,
                                      style: ToastificationStyle.fillColored,
                                      title: Text("Falha ao adicionar"),
                                      description: Text(
                                        "Estamos com problemas técnicos, tente novamente mais tarde!",
                                      ),
                                      alignment: Alignment.topCenter,
                                      autoCloseDuration: const Duration(
                                        seconds: 5,
                                      ),
                                      borderRadius: BorderRadius.circular(12.0),
                                      dragToClose: true,
                                      showIcon: false,
                                    );
                                  }

                                  if (context.mounted && transaction != null) {
                                    Navigator.pop(context, transaction);
                                  }
                                },
                      ),
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
