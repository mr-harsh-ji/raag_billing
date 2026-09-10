import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raag_billing/core/database/app_database.dart' as db;
import 'package:raag_billing/features/products/presentation/providers/product_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';
import 'add_edit_product_page.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final businessAsync = ref.watch(businessProfileProvider);
    
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;

    final currency = businessAsync.when(
      data: (d) => d.currencySymbol,
      loading: () => 'Rs',
      error: (_, __) => 'Rs',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            onPressed: () => context.push('/categories'),
            tooltip: 'Manage Categories',
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withAlpha(230),
              ),
              onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Category Filter Chips
          categoriesAsync.when(
            data: (categories) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: selectedCategoryId == null,
                    onSelected: (_) => ref.read(selectedCategoryIdProvider.notifier).state = null,
                  ),
                  const SizedBox(width: 8),
                  ...categories.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(category.name),
                      selected: selectedCategoryId == category.id,
                      onSelected: (_) => ref.read(selectedCategoryIdProvider.notifier).state = category.id,
                    ),
                  )),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return const Center(child: Text('No products found. Add your first product!'));
                }
                
                if (isTablet) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 2.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) => _ProductGridCard(
                      product: products[index],
                      currency: currency,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    final isLowStock = product.currentStock <= product.minimumStock;
                    return ListTile(
                      title: Text(product.name),
                      subtitle: Row(
                        children: [
                          Text('Stock: ${product.currentStock} ${product.unit}'),
                          if (isLowStock)
                            const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Icon(Icons.warning, color: Colors.orange, size: 16),
                            ),
                          const Spacer(),
                          Text('Price: $currency ${product.sellingPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditProductPage(product: product),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddEditProductPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  final db.Product product;
  final String currency;

  const _ProductGridCard({required this.product, required this.currency});

  @override
  Widget build(BuildContext context) {
    final isLowStock = product.currentStock <= product.minimumStock;
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddEditProductPage(product: product)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Price: $currency ${product.sellingPrice}', style: const TextStyle(color: Colors.blue)),
                  if (isLowStock) const Icon(Icons.warning, color: Colors.orange, size: 16),
                ],
              ),
              Text('Stock: ${product.currentStock} ${product.unit}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
