import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../modules/auth/controller/auth_change_notifier.dart';
import '../../modules/auth/controller/auth_controller.dart';
import '../../modules/auth/presentation/views/login_view.dart';
import '../../modules/home/presentation/views/home_view.dart';
import '../../modules/home/presentation/views/transactions_details_view.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final notifier = ref.watch(authChangeNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
      final isAuth = authState.status == AuthStatus.authenticated;
      final isLoggingIn = state.matchedLocation == '/login';

      if (!isAuth) {
        return isLoggingIn ? null : '/login';
      } else {
        return isLoggingIn ? '/home' : null;
      }
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginView()),
      GoRoute(path: '/home', builder: (context, state) => const HomeView()),
      GoRoute(
        path: '/home/transactionsDetails',
        builder: (context, state) => const TransactionDetailsView(),
      ),
    ],
  );
});
