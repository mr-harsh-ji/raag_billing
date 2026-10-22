import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/services/api_client.dart';

class BusinessRepository {
  final AppDatabase _db;

  BusinessRepository(this._db);

  Future<void> syncFromCloud() async {
    try {
      final apiClient = ApiClient();
      final res = await apiClient.dio.get('/business-profile');
      if (res.data['success'] == true && res.data['data'] != null) {
        final data = res.data['data'];
        final name = data['business_name']?.toString() ?? 'My Business';
        final ownerName = data['owner_name']?.toString();
        final phone = data['phone']?.toString();
        final email = data['email']?.toString();
        final address = data['address']?.toString();
        final gstin = data['gstin']?.toString();
        final upiId = data['upi_id']?.toString();
        final invoicePrefix = data['invoice_prefix']?.toString() ?? 'RB';
        final currencySymbol = data['currency_symbol']?.toString() ?? 'Rs';
        final defaultTaxPercentage = double.tryParse(data['default_tax_percentage']?.toString() ?? '') ?? 0.0;
        final shopCategory = data['shop_category']?.toString() ?? 'General';
        final bankName = data['bank_name']?.toString();
        final accountNumber = data['account_number']?.toString();
        final ifscCode = data['ifsc_code']?.toString();
        final termsAndConditions = data['terms_and_conditions']?.toString();

        final existing = await (_db.select(_db.businessProfile)..limit(1)).getSingleOrNull();
        if (existing == null) {
          await _db.into(_db.businessProfile).insert(
            BusinessProfileCompanion(
              name: Value(name),
              ownerName: Value(ownerName),
              phone: Value(phone),
              email: Value(email),
              address: Value(address),
              gstin: Value(gstin),
              upiId: Value(upiId),
              invoicePrefix: Value(invoicePrefix),
              currencySymbol: Value(currencySymbol),
              defaultTaxPercentage: Value(defaultTaxPercentage),
              shopCategory: Value(shopCategory),
              bankName: Value(bankName),
              accountNumber: Value(accountNumber),
              ifscCode: Value(ifscCode),
              termsAndConditions: Value(termsAndConditions),
            ),
          );
        } else {
          await _db.update(_db.businessProfile).replace(
            existing.copyWith(
              name: name,
              ownerName: Value(ownerName),
              phone: Value(phone),
              email: Value(email),
              address: Value(address),
              gstin: Value(gstin),
              upiId: Value(upiId),
              invoicePrefix: invoicePrefix,
              currencySymbol: currencySymbol,
              defaultTaxPercentage: defaultTaxPercentage,
              shopCategory: shopCategory,
              bankName: Value(bankName),
              accountNumber: Value(accountNumber),
              ifscCode: Value(ifscCode),
              termsAndConditions: Value(termsAndConditions),
            ),
          );
        }
      }
    } catch (e) {
      // ignore: avoid_print
      print('⚠️ [BUSINESS REPO] Sync Error: $e');
    }
  }

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

  Future<void> updateProfile(BusinessProfileData profile) async {
    final existing = await (_db.select(_db.businessProfile)..limit(1)).getSingleOrNull();
    if (existing == null) {
      await _db.into(_db.businessProfile).insert(profile);
    } else {
      final updatedWithRealId = profile.copyWith(id: existing.id);
      await _db.update(_db.businessProfile).replace(updatedWithRealId);
    }
  }
}
