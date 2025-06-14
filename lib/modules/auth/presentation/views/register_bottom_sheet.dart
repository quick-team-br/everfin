import 'package:flutter/material.dart';

import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/core/theme/app_gradients.dart';
import 'package:desenrolai/modules/auth/presentation/view_models/register_modal_viewmodel.dart';
import 'package:desenrolai/shared/widgets/custom_textfield.dart';
import 'package:desenrolai/shared/widgets/gradient_button.dart';

class RegisterBottomSheet extends ConsumerStatefulWidget {
  const RegisterBottomSheet({super.key});

  @override
  ConsumerState<RegisterBottomSheet> createState() =>
      _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends ConsumerState<RegisterBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(signUpModalViewModelProvider);
    final notifier = ref.read(signUpModalViewModelProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 32,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
                margin: const EdgeInsets.symmetric(vertical: 24),
              ),
              Text(
                "Criar conta",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text("Insira seus dados para criar sua conta"),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Nome',
                validator: notifier.validateName,
                onChanged: notifier.setName,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'E-mail',
                validator: notifier.validateEmail,
                onChanged: notifier.setEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Senha',
                validator: notifier.validatePassword,
                onChanged: notifier.setPassword,
                obscureText: true,
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'Telefone',
                validator: notifier.validatePhone,
                onChanged: notifier.setPhone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  PhoneInputFormatter(defaultCountryCode: 'BR'),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 24),
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
                        icon:
                            viewModel.isLoading
                                ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 1,
                                  ),
                                )
                                : null,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            final success = await notifier.register();
                            if (success) {
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    viewModel.error ?? 'Erro desconhecido',
                                  ),
                                ),
                              );
                            }
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
