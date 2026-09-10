import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/database/database_provider.dart';
import '../../data/repositories/product_repository.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ProductRepository(db);
});

final categoriesStreamProvider = StreamProvider<List<Category>>((ref) {
  return ref.watch(productRepositoryProvider).watchAllCategories();
});

final productsStreamProvider = StreamProvider<List<Product>>((ref) {
  return ref.watch(productRepositoryProvider).watchAllProducts();
});

final selectedCategoryIdProvider = StateProvider<int?>((ref) => null);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductsProvider = StreamProvider<List<Product>>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  final selectedCategory = ref.watch(selectedCategoryIdProvider);
  final query = ref.watch(searchQueryProvider).toLowerCase();
  
  return repository.watchProductsByCategory(selectedCategory).map((products) {
    if (query.isEmpty) return products;
    return products.where((p) => 
      p.name.toLowerCase().contains(query) || 
      (p.sku?.toLowerCase().contains(query) ?? false) ||
      (p.barcode?.toLowerCase().contains(query) ?? false)
    ).toList();
  });
});

