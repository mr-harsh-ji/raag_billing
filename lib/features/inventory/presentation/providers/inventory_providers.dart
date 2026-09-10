import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/database/database_provider.dart';
import '../../data/repositories/inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return InventoryRepository(db);
});

final stockMovementsProvider = StreamProvider.family<List<StockMovement>, int>((ref, productId) {
  return ref.watch(inventoryRepositoryProvider).watchMovements(productId);
});

final purchasesProvider = StreamProvider<List<Purchase>>((ref) {
  return ref.watch(inventoryRepositoryProvider).watchAllPurchases();
});

