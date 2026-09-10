import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/database/database_provider.dart';
import '../../data/repositories/business_repository.dart';
import '../../data/repositories/settings_repository.dart';

final businessRepositoryProvider = Provider<BusinessRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return BusinessRepository(db);
});

final businessProfileProvider = StreamProvider<BusinessProfileData>((ref) {
  return ref.watch(businessRepositoryProvider).watchProfile();
});

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return SettingsRepository(db);
});

final appSettingsProvider = StreamProvider<AppSettingsData>((ref) {
  return ref.watch(settingsRepositoryProvider).watchSettings();
});

