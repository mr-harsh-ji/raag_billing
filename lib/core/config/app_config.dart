class AppConfig {
  /// Central Configurable Base URL for Raag Billing SaaS Backend API
  /// Can be overridden at run/build time using `--dart-define=API_BASE_URL=http://...`
  /// Defaults to Android Emulator address (http://10.0.2.2:5000/api)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000/api',
  );

  /// Helper to easily override base URL programmatically if needed during runtime
  static String activeBaseUrl = baseUrl;
}
