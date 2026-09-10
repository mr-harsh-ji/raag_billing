import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';

class InventoryRepository {
  final AppDatabase _db;

  InventoryRepository(this._db);

  Future<void> adjustStock({
    required int productId,
    required double quantity,
    required String reason,
    required String type,
  }) async {
    return _db.transaction(() async {
      final product = await (_db.select(_db.products)..where((t) => t.id.equals(productId))).getSingle();
      
      await _db.update(_db.products).replace(product.copyWith(
        currentStock: product.currentStock + quantity,
      ));

      await _db.into(_db.stockMovements).insert(StockMovementsCompanion.insert(
        productId: productId,
        quantity: quantity,
        type: type,
        reason: Value(reason),
      ));
    });
  }

  Future<int> createPurchase(PurchasesCompanion purchase, List<PurchaseItemsCompanion> items) async {
    return _db.transaction(() async {
      final purchaseId = await _db.into(_db.purchases).insert(purchase);
      
      for (var item in items) {
        await _db.into(_db.purchaseItems).insert(item.copyWith(purchaseId: Value(purchaseId)));
        
        final product = await (_db.select(_db.products)..where((t) => t.id.equals(item.productId.value))).getSingle();
        await _db.update(_db.products).replace(product.copyWith(
          currentStock: product.currentStock + item.quantity.value,
        ));

        await _db.into(_db.stockMovements).insert(StockMovementsCompanion.insert(
          productId: item.productId.value,
          quantity: item.quantity.value,
          type: 'Purchase',
          referenceId: Value(purchaseId),
          reason: Value('Purchase #$purchaseId'),
        ));
      }
      return purchaseId;
    });
  }

  Stream<List<StockMovement>> watchMovements(int productId) {
    return (_db.select(_db.stockMovements)
      ..where((t) => t.productId.equals(productId))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]))
      .watch();
  }

  Stream<List<Purchase>> watchAllPurchases() {
    return (_db.select(_db.purchases)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();
  }
}

