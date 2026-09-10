import '../../../../core/database/app_database.dart';

class CustomerRepository {
  final AppDatabase _db;

  CustomerRepository(this._db);

  Future<List<Customer>> getAllCustomers() => _db.select(_db.customers).get();

  Stream<List<Customer>> watchAllCustomers() => _db.select(_db.customers).watch();

  Future<int> addCustomer(CustomersCompanion customer) =>
      _db.into(_db.customers).insert(customer);

  Future<bool> updateCustomer(Customer customer) =>
      _db.update(_db.customers).replace(customer);

  Future<void> deleteCustomer(int id) async {
    await _db.transaction(() async {
      // Manual delete dependencies to ensure it works even if migration is pending
      await (_db.delete(_db.payments)..where((t) => t.customerId.equals(id))).go();
      await (_db.delete(_db.invoices)..where((t) => t.customerId.equals(id))).go();
      await (_db.delete(_db.customers)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<Customer?> getCustomerById(int id) =>
      (_db.select(_db.customers)..where((t) => t.id.equals(id))).getSingleOrNull();
}
