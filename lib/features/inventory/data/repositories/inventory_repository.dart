import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/services/api_client.dart';

class InventoryRepository {
  final AppDatabase _db;
  final ApiClient _apiClient = ApiClient();

  InventoryRepository(this._db);

  Future<void> syncFromCloud() async {
    try {
      final res = await _apiClient.dio.get('/purchases');
      if (res.data['success'] == true) {
        final List purchasesJson = res.data['data'] ?? [];
        for (var p in purchasesJson) {
          final id = p['id'] is int ? p['id'] : int.parse(p['id'].toString());
          final purchaseNumber = p['purchase_number']?.toString() ?? 'PUR-$id';
          final supplierName = p['supplier_name']?.toString();
          final totalAmount = (p['total_amount'] as num?)?.toDouble() ?? 0.0;
          final date = p['date'] != null ? DateTime.parse(p['date'].toString()) : DateTime.now();

          final existing = await (_db.select(_db.purchases)..where((t) => t.id.equals(id))).getSingleOrNull();
          if (existing == null) {
            await _db.into(_db.purchases).insert(
              PurchasesCompanion(
                id: Value(id),
                purchaseNumber: Value(purchaseNumber),
                supplierName: Value(supplierName),
                date: Value(date),
                totalAmount: Value(totalAmount),
              ),
            );
          }
        }
      }
    } catch (_) {}
  }

  Future<void> adjustStock({
    required int productId,
    required double quantity,
    required String reason,
    required String type,
  }) async {
    return _db.transaction(() async {
      final product = await (_db.select(_db.products)..where((t) => t.id.equals(productId))).getSingleOrNull();
      if (product != null) {
        await _db.update(_db.products).replace(product.copyWith(
          currentStock: product.currentStock + quantity,
        ));
      }

      await _db.into(_db.stockMovements).insert(StockMovementsCompanion.insert(
        productId: productId,
        quantity: quantity,
        type: type,
        reason: Value(reason),
      ));
    });
  }

  Future<int> createPurchase(PurchasesCompanion purchase, List<PurchaseItemsCompanion> items) async {
    int cloudPurchaseId = 0;
    try {
      final itemsPayload = items.map((i) => {
        'productId': i.productId.value,
        'productName': i.productName.value,
        'quantity': i.quantity.value,
        'purchasePrice': i.purchasePrice.value,
        'total': i.total.value,
      }).toList();

      final res = await _apiClient.dio.post('/purchases', data: {
        'supplierName': purchase.supplierName.value,
        'totalAmount': purchase.totalAmount.value,
        'items': itemsPayload,
      });

      if (res.data['success'] == true && res.data['data'] != null) {
        cloudPurchaseId = res.data['data']['id'] is int
            ? res.data['data']['id']
            : int.parse(res.data['data']['id'].toString());
      }
    } catch (_) {}

    return _db.transaction(() async {
      final purchaseToInsert = cloudPurchaseId > 0
          ? purchase.copyWith(id: Value(cloudPurchaseId))
          : purchase;

      final purchaseId = await _db.into(_db.purchases).insert(purchaseToInsert);
      
      for (var item in items) {
        await _db.into(_db.purchaseItems).insert(item.copyWith(purchaseId: Value(purchaseId)));
        
        final product = await (_db.select(_db.products)..where((t) => t.id.equals(item.productId.value))).getSingleOrNull();
        if (product != null) {
          await _db.update(_db.products).replace(product.copyWith(
            currentStock: product.currentStock + item.quantity.value,
          ));
        }

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
