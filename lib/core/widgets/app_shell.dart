import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../router/app_router.dart';

class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter.of(context);
    final String location = GoRouterState.of(context).uri.toString();
    final bool isRoot = location == '/';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final NavigatorState? shellNav = shellNavigatorKey.currentState;
        
        // 1. First, check if there's a pushed route in the inner navigator (Add/Edit pages)
        if (shellNav != null && shellNav.canPop()) {
          shellNav.pop();
          return;
        }

        // 2. If no inner routes, check if GoRouter can go back in its own stack
        if (router.canPop()) {
          router.pop();
          return;
        }

        // 3. If we are on a tab that isn't Dashboard, switch to Dashboard
        if (!isRoot) {
          router.go('/');
          return;
        }

        // 4. Finally, if at Dashboard root, ask to exit
        final shouldClose = await _showExitConfirmation(context);
        if (shouldClose == true && context.mounted) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: child,
        bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) {
          if (_calculateSelectedIndex(context) != index) {
            HapticFeedback.selectionClick();
            _onItemTapped(index, context);
          }
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.dashboard),
            icon: Icon(Icons.dashboard_outlined),
            label: 'Dashboard',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.inventory_2),
            icon: Icon(Icons.inventory_2_outlined),
            label: 'Products',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.receipt),
            icon: Icon(Icons.receipt_outlined),
            label: 'Billing',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.people),
            icon: Icon(Icons.people_outline),
            label: 'Customers',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.more_horiz),
            icon: Icon(Icons.more_horiz_outlined),
            label: 'More',
          ),
        ],
      ),
      )
    );
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/') return 0;
    if (location.startsWith('/products')) return 1;
    if (location.startsWith('/billing')) return 2;
    if (location.startsWith('/customers')) return 3;
    if (location.startsWith('/settings') || location.startsWith('/sales')) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        GoRouter.of(context).go('/products');
        break;
      case 2:
        GoRouter.of(context).go('/billing');
        break;
      case 3:
        GoRouter.of(context).go('/customers');
        break;
      case 4:
        GoRouter.of(context).go('/settings');
        break;
    }
  }

  Future<bool?> _showExitConfirmation(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Exit Raag Billing'),
        content: const Text('Are you sure you want to close the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes, Exit'),
          ),
        ],
      ),
    );
  }
}

