import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';

class BusinessRepository {
  final AppDatabase _db;

  BusinessRepository(this._db);

  Future<BusinessProfileData> getProfile() async {
    final profile = await (_db.select(_db.businessProfile)..limit(1)).getSingleOrNull();
    if (profile == null) {
      // Create default profile if none exists
      final id = await _db.into(_db.businessProfile).insert(
        const BusinessProfileCompanion(
          name: Value('My Business'),
          invoicePrefix: Value('RB'),
          currencySymbol: Value('Rs'),
        ),
      );
      return (await (_db.select(_db.businessProfile)..where((t) => t.id.equals(id))).getSingle());
    }
    return profile;
  }

  Stream<BusinessProfileData> watchProfile() {
    return (_db.select(_db.businessProfile)..limit(1)).watch().map((rows) {
      if (rows.isEmpty) {
        // This is a fallback, getProfile() usually handles this
        return const BusinessProfileData(
          id: 0,
          name: 'My Business',
          invoicePrefix: 'RB',
          currencySymbol: 'Rs',
          defaultTaxPercentage: 0.0,
          shopCategory: 'General',
        );
      }
      return rows.first;
    });
  }

  Future<void> updateProfile(BusinessProfileData profile) {
    return _db.update(_db.businessProfile).replace(profile);
  }
}

