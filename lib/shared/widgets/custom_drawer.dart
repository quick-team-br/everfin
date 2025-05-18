import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import 'package:everfin/modules/auth/controller/auth_controller.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
                    semanticsLabel: 'Logo everfin',
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Everfin",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.titleSmall?.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        ),
      ),
    );
  }
}
