import '../../../../core/database/app_database.dart';

class ProductRepository {
  final AppDatabase _db;

  ProductRepository(this._db);

  // Categories
  Future<List<Category>> getAllCategories() => _db.select(_db.categories).get();
  
  Stream<List<Category>> watchAllCategories() => _db.select(_db.categories).watch();

  Future<int> addCategory(CategoriesCompanion category) =>
      _db.into(_db.categories).insert(category);

  Future<bool> updateCategory(Category category) =>
      _db.update(_db.categories).replace(category);

  Future<int> deleteCategory(int id) =>
      (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();

  // Products
  Future<List<Product>> getAllProducts() => _db.select(_db.products).get();

  Stream<List<Product>> watchAllProducts() => _db.select(_db.products).watch();
  
  Stream<List<Product>> watchProductsByCategory(int? categoryId) {
    if (categoryId == null) return watchAllProducts();
    return (_db.select(_db.products)..where((t) => t.categoryId.equals(categoryId))).watch();
  }

  Future<int> addProduct(ProductsCompanion product) =>
      _db.into(_db.products).insert(product);

  Future<bool> updateProduct(Product product) =>
      _db.update(_db.products).replace(product);

  Future<void> deleteProduct(int id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.stockMovements)..where((t) => t.productId.equals(id))).go();
      await (_db.delete(_db.invoiceItems)..where((t) => t.productId.equals(id))).go();
      await (_db.delete(_db.purchaseItems)..where((t) => t.productId.equals(id))).go();
      await (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();
    });
  }

  Future<int> deleteProductRaw(int id) =>
      (_db.delete(_db.products)..where((t) => t.id.equals(id))).go();
      
  Future<Product?> getProductById(int id) =>
      (_db.select(_db.products)..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<Product?> getProductByBarcode(String barcode) =>
      (_db.select(_db.products)..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
}
