import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'business_profile_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }
}

