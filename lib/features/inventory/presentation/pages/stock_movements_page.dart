import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:raag_billing/core/database/app_database.dart';
import '../providers/inventory_providers.dart';

class StockMovementsPage extends ConsumerWidget {
  final Product product;

  const StockMovementsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movementsAsync = ref.watch(stockMovementsProvider(product.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${product.name} - Stock History'),
      ),
      body: movementsAsync.when(
        data: (movements) {
          if (movements.isEmpty) {
            return const Center(child: Text('No stock movements found.'));
          }
          return ListView.builder(
            itemCount: movements.length,
            itemBuilder: (context, index) {
              final m = movements[index];
              final isPositive = m.quantity > 0;
              
              return ListTile(
                leading: Icon(
                  isPositive ? Icons.add_circle_outline : Icons.remove_circle_outline,
                  color: isPositive ? Colors.green : Colors.red,
                ),
                title: Text('${m.type}: ${isPositive ? '+' : ''}${m.quantity} ${product.unit}'),
                subtitle: Text(m.reason ?? ''),
                trailing: Text(DateFormat('dd MMM yyyy, hh:mm a').format(m.date)),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAdjustmentDialog(context, ref),
        label: const Text('Adjust Stock'),
        icon: const Icon(Icons.edit),
      ),
    );
  }

  void _showAdjustmentDialog(BuildContext context, WidgetRef ref) {
    final qtyController = TextEditingController();
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Manual Stock Adjustment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: qtyController,
              decoration: const InputDecoration(
                labelText: 'Quantity (use negative for removal)',
                hintText: 'e.g., 10 or -5',
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: true),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(labelText: 'Reason (e.g., Damaged, Found)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final qty = double.tryParse(qtyController.text) ?? 0;
              if (qty == 0) return;

              await ref.read(inventoryRepositoryProvider).adjustStock(
                productId: product.id,
                quantity: qty,
                reason: reasonController.text,
                type: 'Manual Adjustment',
              );
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

