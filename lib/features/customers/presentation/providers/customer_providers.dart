import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/database/database_provider.dart';
import '../../data/repositories/customer_repository.dart';

final customerRepositoryProvider = Provider<CustomerRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return CustomerRepository(db);
});

final customerSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredCustomersProvider = StreamProvider<List<Customer>>((ref) {
  final repository = ref.watch(customerRepositoryProvider);
  final query = ref.watch(customerSearchQueryProvider).toLowerCase();

  return repository.watchAllCustomers().map((customers) {
    if (query.isEmpty) return customers;
    return customers.where((c) =>
      c.name.toLowerCase().contains(query) ||
      (c.phone?.toLowerCase().contains(query) ?? false) ||
      (c.email?.toLowerCase().contains(query) ?? false)
    ).toList();
  });
});

