import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:everfin/core/theme/app_gradients.dart';
import 'package:everfin/modules/auth/presentation/view_models/login_view_model.dart';
import 'package:everfin/shared/widgets/gradient_button.dart';

import '../../../../core/theme/app_colors.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(loginViewProvider).isLoading;
    final authNotifier = ref.read(loginViewProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 429,
                    height: 429,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withAlpha(30),
                          Colors.transparent,
                        ],
                        radius: .6,
                        focal: Alignment.center,
                        focalRadius: 0.1,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/svgs/everfin_logo_art.svg',
                    width: MediaQuery.of(context).size.width,
                    semanticsLabel: 'Everfin Logo',
                  ),
                ],
              ),
            ),
            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 52, left: 24, right: 24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Everfin',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Seu dinheiro +Inteligente',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Controle de gastos pelo WhatsApp, metas financeiras, aporte inteligente e muito mais!',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),

                  GradientButton(
                    onPressed: isLoading ? null : () => authNotifier.login(),
                    text: isLoading ? "Fazendo login" : "Fazer login",
                    gradient: AppGradients.primary,
                    icon:
                        isLoading
                            ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 1,
                                ),
                              ),
                            )
                            : SvgPicture.asset(
                              'assets/svgs/right_up_arrow_icon.svg',
                              width: 24,
                              semanticsLabel:
                                  'Seta apontando na diagonal para cima',
                            ),
                  ),
                  const SizedBox(height: 20),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      label: const Text('Criar uma conta'),
                      icon: SvgPicture.asset(
                        'assets/svgs/right_up_arrow_icon.svg',
                        width: 24,
                        semanticsLabel: 'Seta apontando na diagonal para cima',
                        colorFilter: ColorFilter.mode(
                          Theme.of(context).textTheme.titleLarge?.color ??
                              Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
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
