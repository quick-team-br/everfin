import 'package:flutter/material.dart';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:desenrolai/core/theme/app_colors.dart';
import 'package:desenrolai/core/theme/app_gradients.dart';
import 'package:desenrolai/modules/finances/models/transaction_category.dart';
import 'package:desenrolai/modules/finances/models/transaction_model.dart';
import 'package:desenrolai/modules/finances/presentation/view_models/transaction_edit_sheet_viewmodel.dart';
import 'package:desenrolai/shared/widgets/custom_dropdown.dart';
import 'package:desenrolai/shared/widgets/custom_textfield.dart';
import 'package:desenrolai/shared/widgets/flip_undo_button.dart';
import 'package:desenrolai/shared/widgets/gradient_button.dart';
import 'package:desenrolai/shared/widgets/modey_text_field.dart';

class TransactionEditBottomSheet extends ConsumerStatefulWidget {
  final Transaction transactionItem;

  const TransactionEditBottomSheet({super.key, required this.transactionItem});

  @override
  ConsumerState<TransactionEditBottomSheet> createState() =>
      _TransactionEditBottomSheetState();
}

class _TransactionEditBottomSheetState
    extends ConsumerState<TransactionEditBottomSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(transactionDetailSheetViewModelProvider.notifier)
          .initState(widget.transactionItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.read(
      transactionDetailSheetViewModelProvider.notifier,
    );
    final state = ref.watch(transactionDetailSheetViewModelProvider);

    final primaryColor =
        widget.transactionItem.type == TransactionType.expense
            ? AppColors.red
            : Theme.of(context).primaryColor;

    final availableCategories =
        state.availableCategories
            .where((category) => category.type == widget.transactionItem.type)
            .toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(31.5),
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 0.7,
          colors: [
            primaryColor.withAlpha(36),
            Theme.of(context).cardColor.withAlpha(0),
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
              Container(
                height: 4,
                width: 32,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.symmetric(vertical: 24),
              ),
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleSmall,
                  children: [
                    const TextSpan(text: "Editar "),
                    TextSpan(
                      text:
                          widget.transactionItem.type == TransactionType.expense
                              ? "saída"
                              : "entrada",
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text("Edite ou exclua sua movimentação"),
              const SizedBox(height: 24),
              CustomTextField(
                label: "Descrição",
                defaultValue: widget.transactionItem.description,
                onChanged: viewModel.setDescription,
              ),
              const SizedBox(height: 20),
              MoneyTextField(
                label: "Valor",
                defaultValue: widget.transactionItem.amount,
                onChanged: viewModel.setAmount,
              ),
              const SizedBox(height: 20),
              viewModel.isLoadingCategories
                  ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 1.4),
                      ),
                    ),
                  )
                  : CustomDropdown<TransactionCategory>(
                    items: availableCategories,
                    label: "Categoria",
                    defaultValue: availableCategories.firstWhere(
                      (category) =>
                          category.id == widget.transactionItem.categoryId,
                      orElse: () => availableCategories.first,
                    ),
                    onChanged: viewModel.setCategory,
                    itemToString: (item) => item.description,
                  ),
              const SizedBox(height: 24),
              FlipUndoButton(
                undoLabel: "Desfazer",
                onConfirmed: () async {
                  final transaction = await viewModel.deleteTransaction();

                  if (context.mounted && transaction != null) {
                    Navigator.pop(context, (transaction, "delete"));
                  }
                },
                front: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    radius: Radius.circular(12),
                    color: Theme.of(context).colorScheme.outline,
                    strokeWidth: 1,
                    dashPattern: [8, 8],
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 8,
                      children: [
                        Text(
                          "Excluir",
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        SvgPicture.asset(
                          'assets/svgs/trash_icon.svg',
                          width: 20,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).textTheme.labelMedium?.color ??
                                Colors.black,
                            BlendMode.srcIn,
                          ),
                          semanticsLabel: "Icone de lixeira",
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 24),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            viewModel.isSaving
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
                            widget.transactionItem.type ==
                                    TransactionType.expense
                                ? AppGradients.red
                                : AppGradients.primary,
                        icon:
                            viewModel.isSaving
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
                            viewModel.isSaving ||
                                    !viewModel.isDirty ||
                                    viewModel.isLoadingCategories ||
                                    !viewModel.isValid
                                ? null
                                : () async {
                                  final transaction =
                                      await viewModel.editTransaction();

                                  if (context.mounted && transaction != null) {
                                    Navigator.pop(context, (
                                      transaction,
                                      "edited",
                                    ));
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
