import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';

class SettingsRepository {
  final AppDatabase _db;

  SettingsRepository(this._db);

  Future<AppSettingsData> getSettings() async {
    final settings = await (_db.select(_db.appSettings)..limit(1)).getSingleOrNull();
    if (settings != null) return settings;

    // Default settings
    final id = await _db.into(_db.appSettings).insert(
      const AppSettingsCompanion(
        language: Value('en'),
        remindersEnabled: Value(true),
        barcodeBeepEnabled: Value(true),
        hideGstin: Value(false),
        barcodeScanEnabled: Value(true),
        dateFormat: Value('dd/MM/yyyy'),
        timeFormat: Value('hh:mm a'),
        themeMode: Value('light'),
        thankYouNote: Value('Thank you for shopping with us!'),
      ),
    );
    return (await (_db.select(_db.appSettings)..where((t) => t.id.equals(id))).getSingle());
  }

  Stream<AppSettingsData> watchSettings() {
    return (_db.select(_db.appSettings)..limit(1)).watch().map((rows) {
      if (rows.isNotEmpty) return rows.first;
      return const AppSettingsData(
        id: 0,
        language: 'en',
        remindersEnabled: true,
        barcodeBeepEnabled: true,
        hideGstin: false,
        barcodeScanEnabled: true,
        dateFormat: 'dd/MM/yyyy',
        timeFormat: 'hh:mm a',
        themeMode: 'light',
        thankYouNote: 'Thank you for shopping with us!',
      );
    });
  }

  Future<void> updateSettings(AppSettingsData settings) async {
    final existing = await (_db.select(_db.appSettings)..limit(1)).getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.appSettings).insert(
        AppSettingsCompanion(
          language: Value(settings.language),
          remindersEnabled: Value(settings.remindersEnabled),
          barcodeBeepEnabled: Value(settings.barcodeBeepEnabled),
          hideGstin: Value(settings.hideGstin),
          barcodeScanEnabled: Value(settings.barcodeScanEnabled),
          dateFormat: Value(settings.dateFormat),
          timeFormat: Value(settings.timeFormat),
          themeMode: Value(settings.themeMode),
          thankYouNote: Value(settings.thankYouNote),
        ),
      );
    } else {
      final updatedWithRealId = settings.copyWith(id: existing.id);
      await _db.update(_db.appSettings).replace(updatedWithRealId);
    }
  }
}
