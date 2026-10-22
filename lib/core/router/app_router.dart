import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/billing/presentation/pages/billing_page.dart';
import '../../features/categories/presentation/pages/categories_page.dart';
import '../../features/customers/presentation/pages/customers_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/inventory/presentation/pages/purchases_page.dart';
import '../../features/products/presentation/pages/products_page.dart';
import '../../features/reports/presentation/pages/reports_page.dart';
import '../../features/sales/presentation/pages/sales_page.dart';
import '../../features/settings/presentation/pages/app_settings_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

/// Listenable adapter that notifies GoRouter when AuthState changes
class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AuthState>(
      authProvider,
      (_, __) => notifyListeners(),
    );
  }
}

final routerNotifierProvider = Provider<RouterNotifier>((ref) {
  return RouterNotifier(ref);
});

final routerProvider = Provider<GoRouter>((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isAuth = authState.isAuthenticated;
      final matchedLocation = state.matchedLocation;

      final isAuthRoute = matchedLocation == '/login' || matchedLocation == '/register';
      final isSplashRoute = matchedLocation == '/splash';

      // 1. Initial Local Auth Loading -> Show Splash Screen
      if (authState.isLoading) {
        return isSplashRoute ? null : '/splash';
      }

      // 2. Unauthenticated user trying to access protected routes -> Redirect to /login
      if (!isAuth && !isAuthRoute) {
        return '/login';
      }

      // 3. Authenticated user trying to access /login, /register, or /splash -> Redirect to Home /
      if (isAuth && (isAuthRoute || isSplashRoute)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductsPage(),
          ),
          GoRoute(
            path: '/categories',
            builder: (context, state) => const CategoriesPage(),
          ),
          GoRoute(
            path: '/customers',
            builder: (context, state) => const CustomersPage(),
          ),
          GoRoute(
            path: '/billing',
            builder: (context, state) => const BillingPage(),
          ),
          GoRoute(
            path: '/sales',
            builder: (context, state) => const SalesPage(),
          ),
          GoRoute(
            path: '/purchases',
            builder: (context, state) => const PurchasesPage(),
          ),
          GoRoute(
            path: '/reports',
            builder: (context, state) => const ReportsPage(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
            routes: [
              GoRoute(
                path: 'app',
                builder: (context, state) => const AppSettingsPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
