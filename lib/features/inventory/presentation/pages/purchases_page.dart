import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:raag_billing/features/products/presentation/providers/product_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';

class PurchasesPage extends ConsumerStatefulWidget {
  const PurchasesPage({super.key});

  @override
  ConsumerState<PurchasesPage> createState() => _PurchasesPageState();
}

class _PurchasesPageState extends ConsumerState<PurchasesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final purchasesAsync = ref.watch(purchasesProvider);
    final businessAsync = ref.watch(businessProfileProvider);

    final currency = businessAsync.when(
      data: (d) => d.currencySymbol,
      loading: () => 'Rs',
      error: (_, __) => 'Rs',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchases History'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter by supplier...',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white.withAlpha(230),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
        ),
      ),
      body: purchasesAsync.when(
        data: (purchases) {
          final filtered = purchases.where((p) => 
            (p.supplierName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? true)
          ).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('No purchase records found.'));
          }
          return ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final p = filtered[index];
              return ListTile(
                title: Text(p.purchaseNumber),
                subtitle: Text('${p.supplierName ?? 'Direct Purchase'} | ${DateFormat('dd MMM yyyy, hh:mm a').format(p.date)}'),
                trailing: Text('$currency ${p.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPurchaseDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddPurchaseDialog(BuildContext context, WidgetRef ref) {
    final supplierController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    Product? selectedProduct;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Add Purchase (Stock In)', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _ProductDropdown(onSelected: (p) => setState(() => selectedProduct = p)),
              const SizedBox(height: 16),
              TextField(
                controller: supplierController,
                decoration: const InputDecoration(labelText: 'Supplier Name'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: qtyController,
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: 'Purchase Price'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: selectedProduct == null ? null : () async {
                  final qty = double.tryParse(qtyController.text) ?? 0;
                  final price = double.tryParse(priceController.text) ?? 0;
                  
                  final purchase = PurchasesCompanion.insert(
                    purchaseNumber: 'PUR-${DateTime.now().millisecondsSinceEpoch}',
                    supplierName: drift.Value(supplierController.text.isEmpty ? null : supplierController.text),
                    totalAmount: qty * price,
                    date: drift.Value(DateTime.now()),
                  );

                  final item = PurchaseItemsCompanion.insert(
                    purchaseId: 0, // Handled by repo
                    productId: selectedProduct!.id,
                    productName: selectedProduct!.name,
                    quantity: qty,
                    purchasePrice: price,
                    total: qty * price,
                  );

                  await ref.read(inventoryRepositoryProvider).createPurchase(purchase, [item]);
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchase recorded and stock updated!')));
                  }
                },
                child: const Text('Save Purchase'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductDropdown extends ConsumerWidget {
  final Function(Product) onSelected;

  const _ProductDropdown({required this.onSelected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productsStreamProvider);

    return productsAsync.when(
      data: (products) => DropdownButtonFormField<Product>(
        decoration: const InputDecoration(labelText: 'Select Product'),
        items: products.map((p) => DropdownMenuItem(value: p, child: Text(p.name))).toList(),
        onChanged: (p) {
          if (p != null) onSelected(p);
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('Error loading products'),
    );
  }
}
