import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router/app_router.dart';
import 'core/services/auth_storage.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await AuthStorage.init(); // Initialize SharedPreferences once in memory

  // Allow all orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(
    const ProviderScope(
      child: RaagBillingApp(),
    ),
  );
}

class RaagBillingApp extends ConsumerWidget {
  const RaagBillingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final settingsAsync = ref.watch(appSettingsProvider);
    final themeMode = settingsAsync.maybeWhen(
      data: (s) {
        if (s.themeMode == 'dark') return ThemeMode.dark;
        if (s.themeMode == 'light') return ThemeMode.light;
        return ThemeMode.system;
      },
      orElse: () => ThemeMode.system,
    );

    return MaterialApp.router(
      title: 'Raag Billing',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
