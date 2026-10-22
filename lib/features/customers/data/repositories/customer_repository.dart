import 'dart:async';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/api_client.dart';

class CustomerRepository {
  final AppDatabase _db;
  final ApiClient _apiClient = ApiClient();

  CustomerRepository(this._db);

  Future<void> syncFromCloud() async {
    try {
      final res = await _apiClient.dio.get('/customers');
      if (res.data['success'] == true) {
        final List customersJson = res.data['data'] ?? [];
        await _db.batch((batch) {
          for (var c in customersJson) {
            final id = int.tryParse(c['id']?.toString() ?? '') ?? 0;
            if (id == 0) continue;
            final name = c['name'].toString();
            final phone = c['phone']?.toString();
            final email = c['email']?.toString();
            final address = c['address']?.toString();
            final openingBalance = double.tryParse(c['opening_balance']?.toString() ?? '') ?? 0.0;
            final notes = c['notes']?.toString();

            batch.insert(
              _db.customers,
              CustomersCompanion(
                id: Value(id),
                name: Value(name),
                phone: Value(phone),
                email: Value(email),
                address: Value(address),
                openingBalance: Value(openingBalance),
                notes: Value(notes),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }
    } catch (_) {}
  }

  Future<List<Customer>> getAllCustomers() => _db.select(_db.customers).get();

  Stream<List<Customer>> watchAllCustomers() => _db.select(_db.customers).watch();

  Future<int> addCustomer(CustomersCompanion customer) async {
    final localId = await _db.into(_db.customers).insert(customer);
    unawaited(_syncCustomerToCloud(localId, customer));
    return localId;
  }

  Future<void> _syncCustomerToCloud(int localId, CustomersCompanion customer) async {
    try {
      final res = await _apiClient.dio.post('/customers', data: {
        'name': customer.name.value,
        'phone': customer.phone.value,
        'email': customer.email.value,
        'address': customer.address.value,
        'opening_balance': customer.openingBalance.value,
        'notes': customer.notes.value,
      });

      if (res.data['success'] == true && res.data['data'] != null) {
        final cloudId = int.tryParse(res.data['data']['id']?.toString() ?? '') ?? 0;
        if (cloudId > 0 && cloudId != localId) {
          await (_db.delete(_db.customers)..where((t) => t.id.equals(localId))).go();
          await _db.into(_db.customers).insertOnConflictUpdate(
            customer.copyWith(id: Value(cloudId)),
          );
        }
      }
    } catch (_) {}
  }

  Future<bool> updateCustomer(Customer customer) async {
    unawaited(Future(() async {
      try {
        await _apiClient.dio.put('/customers/${customer.id}', data: {
          'name': customer.name,
          'phone': customer.phone,
          'email': customer.email,
          'address': customer.address,
          'opening_balance': customer.openingBalance,
          'notes': customer.notes,
        });
      } catch (_) {}
    }));

    return _db.update(_db.customers).replace(customer);
  }

  Future<void> deleteCustomer(int id) async {
    unawaited(Future(() async {
      try {
        await _apiClient.dio.delete('/customers/$id');
      } catch (_) {}
    }));

    await _db.transaction(() async {
      await (_db.delete(_db.payments)..where((t) => t.customerId.equals(id))).go();
      await (_db.delete(_db.invoices)..where((t) => t.customerId.equals(id))).go();
      await (_db.delete(_db.customers)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<Customer?> getCustomerById(int id) =>
      (_db.select(_db.customers)..where((t) => t.id.equals(id))).getSingleOrNull();
}
