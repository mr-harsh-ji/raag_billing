import 'dart:async';
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/services/api_client.dart';

class ProductRepository {
  final AppDatabase _db;
  final ApiClient _apiClient = ApiClient();

  ProductRepository(this._db);

  // Background Non-blocking Cloud Sync
  Future<void> syncFromCloud() async {
    try {
      // 1. Sync Categories
      final catRes = await _apiClient.dio.get('/categories');
      if (catRes.data['success'] == true) {
        final List categoriesJson = catRes.data['data'] ?? [];
        await _db.batch((batch) {
          for (var c in categoriesJson) {
            final id = int.tryParse(c['id']?.toString() ?? '') ?? 0;
            if (id == 0) continue;
            final name = c['name'].toString();
            final desc = c['description']?.toString();

            batch.insert(
              _db.categories,
              CategoriesCompanion(
                id: Value(id),
                name: Value(name),
                description: Value(desc),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }

      // 2. Sync Products
      final prodRes = await _apiClient.dio.get('/products');
      if (prodRes.data['success'] == true) {
        final List productsJson = prodRes.data['data'] ?? [];
        await _db.batch((batch) {
          for (var p in productsJson) {
            final id = int.tryParse(p['id']?.toString() ?? '') ?? 0;
            if (id == 0) continue;
            final name = p['name'].toString();
            final sku = p['sku']?.toString();
            final barcode = p['barcode']?.toString();
            final categoryId = int.tryParse(p['category_id']?.toString() ?? '');
            final purchasePrice = double.tryParse(p['purchase_price']?.toString() ?? '') ?? 0.0;
            final sellingPrice = double.tryParse(p['selling_price']?.toString() ?? '') ?? 0.0;
            final taxPercentage = double.tryParse(p['tax_percentage']?.toString() ?? '') ?? 0.0;
            final currentStock = double.tryParse(p['current_stock']?.toString() ?? '') ?? 0.0;
            final minimumStock = double.tryParse(p['minimum_stock']?.toString() ?? '') ?? 0.0;
            final unit = p['unit']?.toString() ?? 'pcs';
            final description = p['description']?.toString();
            final rackNumber = p['rack_number']?.toString();
            final batchNumber = p['batch_number']?.toString();
            final hsnCode = p['hsn_code']?.toString();
            final purity = p['purity']?.toString();

            batch.insert(
              _db.products,
              ProductsCompanion(
                id: Value(id),
                name: Value(name),
                sku: Value(sku),
                barcode: Value(barcode),
                categoryId: Value(categoryId),
                purchasePrice: Value(purchasePrice),
                sellingPrice: Value(sellingPrice),
                taxPercentage: Value(taxPercentage),
                currentStock: Value(currentStock),
                minimumStock: Value(minimumStock),
                unit: Value(unit),
                description: Value(description),
                rackNumber: Value(rackNumber),
                batchNumber: Value(batchNumber),
                hsnCode: Value(hsnCode),
                purity: Value(purity),
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
      }
    } catch (_) {}
  }

  // Categories
  Future<List<Category>> getAllCategories() => _db.select(_db.categories).get();
  
  Stream<List<Category>> watchAllCategories() => _db.select(_db.categories).watch();

  Future<int> addCategory(CategoriesCompanion category) async {
    final localId = await _db.into(_db.categories).insert(category);
    unawaited(_syncCategoryToCloud(localId, category));
    return localId;
  }

  Future<void> _syncCategoryToCloud(int localId, CategoriesCompanion category) async {
    try {
      final res = await _apiClient.dio.post('/categories', data: {
        'name': category.name.value,
        'description': category.description.value,
      });

      if (res.data['success'] == true && res.data['data'] != null) {
        final cloudId = int.tryParse(res.data['data']['id']?.toString() ?? '') ?? 0;
        if (cloudId > 0 && cloudId != localId) {
          await (_db.delete(_db.categories)..where((t) => t.id.equals(localId))).go();
          await _db.into(_db.categories).insertOnConflictUpdate(
            category.copyWith(id: Value(cloudId)),
          );
        }
      }
    } catch (_) {}
  }

  Future<bool> updateCategory(Category category) async {
    unawaited(Future(() async {
      try {
        await _apiClient.dio.put('/categories/${category.id}', data: {
          'name': category.name,
          'description': category.description,
        });
      } catch (_) {}
    }));
    return _db.update(_db.categories).replace(category);
  }

  Future<int> deleteCategory(int id) async {
    unawaited(Future(() async {
      try {
        await _apiClient.dio.delete('/categories/$id');
      } catch (_) {}
    }));
    return (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();
  }

  // Products
  Future<List<Product>> getAllProducts() => _db.select(_db.products).get();

  Stream<List<Product>> watchAllProducts() => _db.select(_db.products).watch();
  
  Stream<List<Product>> watchProductsByCategory(int? categoryId) {
    if (categoryId == null) return watchAllProducts();
    return (_db.select(_db.products)..where((t) => t.categoryId.equals(categoryId))).watch();
  }

  Future<int> addProduct(ProductsCompanion product) async {
    final localId = await _db.into(_db.products).insert(product);
    unawaited(_syncProductToCloud(localId, product));
    return localId;
  }

  Future<void> _syncProductToCloud(int localId, ProductsCompanion product) async {
    try {
      final payload = {
        'name': product.name.value,
        'sku': product.sku.value,
        'barcode': product.barcode.value,
        'categoryId': product.categoryId.value,
        'purchasePrice': product.purchasePrice.value,
        'sellingPrice': product.sellingPrice.value,
        'taxPercentage': product.taxPercentage.value,
        'currentStock': product.currentStock.value,
        'minimumStock': product.minimumStock.value,
        'unit': product.unit.value,
        'description': product.description.value,
        'rackNumber': product.rackNumber.value,
        'batchNumber': product.batchNumber.value,
        'hsnCode': product.hsnCode.value,
        'purity': product.purity.value,
        'expiryDate': product.expiryDate.value?.toIso8601String(),
        'manufacturingDate': product.manufacturingDate.value?.toIso8601String(),
      };

      final res = await _apiClient.dio.post('/products', data: payload);

      if (res.data['success'] == true && res.data['data'] != null) {
        final cloudId = int.tryParse(res.data['data']['id']?.toString() ?? '') ?? 0;
        if (cloudId > 0 && cloudId != localId) {
          await (_db.delete(_db.products)..where((t) => t.id.equals(localId))).go();
          await _db.into(_db.products).insertOnConflictUpdate(
            product.copyWith(id: Value(cloudId)),
          );
        }
      }
    } catch (_) {}
  }

  Future<bool> updateProduct(Product product) async {
    unawaited(Future(() async {
      try {
        await _apiClient.dio.put('/products/${product.id}', data: {
          'name': product.name,
          'sku': product.sku,
          'barcode': product.barcode,
          'categoryId': product.categoryId,
          'purchasePrice': product.purchasePrice,
          'sellingPrice': product.sellingPrice,
          'taxPercentage': product.taxPercentage,
          'currentStock': product.currentStock,
          'minimumStock': product.minimumStock,
          'unit': product.unit,
          'description': product.description,
          'rackNumber': product.rackNumber,
          'batchNumber': product.batchNumber,
          'hsnCode': product.hsnCode,
          'purity': product.purity,
          'expiryDate': product.expiryDate?.toIso8601String(),
          'manufacturingDate': product.manufacturingDate?.toIso8601String(),
        });
      } catch (_) {}
    }));

    return _db.update(_db.products).replace(product);
  }

  Future<void> deleteProduct(int id) async {
    unawaited(Future(() async {
      try {
        await _apiClient.dio.delete('/products/$id');
      } catch (_) {}
    }));

    await _db.transaction(() async {
      await (_db.delete(_db.stockMovements)..where((t) => t.productId.equals(id))).go();
      await (_db.delete(_db.invoiceItems)..where((t) => t.productId.equals(id))).go();
      await (_db.delete(_db.purchaseItems)..where((t) => t.productId.equals(id))).go();
      await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<Product?> getProductById(int id) =>
      (_db.select(_db.products)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Product?> getProductByBarcode(String barcode) =>
      (_db.select(_db.products)..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
}
