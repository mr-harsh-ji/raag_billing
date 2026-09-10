import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:raag_billing/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:raag_billing/features/products/presentation/pages/products_page.dart';
import 'package:raag_billing/features/categories/presentation/pages/categories_page.dart';
import 'package:raag_billing/features/customers/presentation/pages/customers_page.dart';
import 'package:raag_billing/features/billing/presentation/pages/billing_page.dart';
import 'package:raag_billing/features/sales/presentation/pages/sales_page.dart';
import 'package:raag_billing/features/inventory/presentation/pages/purchases_page.dart';
import 'package:raag_billing/features/reports/presentation/pages/reports_page.dart';
import 'package:raag_billing/features/settings/presentation/pages/settings_page.dart';
import 'package:raag_billing/features/settings/presentation/pages/app_settings_page.dart';
import 'package:raag_billing/core/widgets/app_shell.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> shellNavigatorKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  initialLocation: '/',
  navigatorKey: _rootNavigatorKey,
  routes: [
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

