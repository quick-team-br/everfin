import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:desenrolai/core/theme/app_gradients.dart';
import 'package:desenrolai/modules/auth/presentation/view_models/login_modal_viewmodel.dart';
import 'package:desenrolai/shared/widgets/custom_textfield.dart';
import 'package:desenrolai/shared/widgets/gradient_button.dart';

class LoginBottomSheet extends ConsumerStatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  ConsumerState<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends ConsumerState<LoginBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginModalViewModelProvider);
    final notifier = ref.read(loginModalViewModelProvider.notifier);

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
                "Fazer login",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text("Insira seus dados para acessar sua conta"),
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
                            final success = await notifier.submit();
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
