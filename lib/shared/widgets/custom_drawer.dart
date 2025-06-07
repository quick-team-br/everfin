import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:desenrolai/main.dart';
import 'package:desenrolai/modules/auth/controller/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDark = themeNotifier.value == ThemeMode.dark;

    return Drawer(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svgs/logo_icon.svg',
                    width: 32,
                    semanticsLabel: 'Logo desenrolai',
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Desenrola AI",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon:
                        isDark
                            ? SvgPicture.asset(
                              'assets/svgs/sun_icon.svg',
                              width: 24,
                              semanticsLabel: 'Icone de sol',
                            )
                            : SvgPicture.asset(
                              'assets/svgs/moon_icon.svg',
                              width: 24,
                              semanticsLabel: 'Icone de lua',
                              colorFilter: ColorFilter.mode(
                                Theme.of(context).textTheme.bodyMedium?.color ??
                                    Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                    tooltip: 'Alternar tema',
                    onPressed: () {
                      Navigator.of(context).pop();

                      Future.delayed(Duration(milliseconds: 300), () {
                        themeNotifier.value =
                            isDark ? ThemeMode.light : ThemeMode.dark;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Divider(color: Theme.of(context).dividerColor),
              const SizedBox(height: 20),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: Consumer(
                  builder:
                      (context, ref, _) => OutlinedButton(
                        onPressed:
                            ref.watch(authControllerProvider.notifier).logout,
                        child: const Text("Sair da conta"),
                      ),
                ),
              ),
              if (Theme.of(context).platform == TargetPlatform.android)
                const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
