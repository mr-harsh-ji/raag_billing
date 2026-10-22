import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import 'business_profile_page.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings & More')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Sales History'),
            onTap: () => context.push('/sales'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Purchase History'),
            onTap: () => context.push('/purchases'),
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Business Reports'),
            onTap: () => context.push('/reports'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Business Profile'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BusinessProfilePage()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('App Settings'),
            onTap: () => context.push('/settings/app'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            onTap: () {
              showDialog(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Logout'),
                  content: const Text('Are you sure you want to log out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                        ref.read(authProvider.notifier).logout();
                      },
                      child: const Text('Logout', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
