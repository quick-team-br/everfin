import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:everfin/core/routes/app_router.dart';
import 'package:everfin/core/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, currentTheme, _) {
        return MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: currentTheme,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
