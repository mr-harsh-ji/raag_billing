import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/services/invoice_pdf_service.dart';
import 'package:raag_billing/features/billing/presentation/providers/billing_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';
import 'package:raag_billing/features/products/presentation/providers/product_providers.dart';

class InvoiceDetailsPage extends ConsumerWidget {
  final Invoice invoice;
  final Customer? customer;

  const InvoiceDetailsPage({super.key, required this.invoice, this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(invoiceItemsProvider(invoice.id));
    final businessAsync = ref.watch(businessProfileProvider);
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    final currency = businessAsync.when(
      data: (d) => d.currencySymbol,
      loading: () => 'Rs',
      error: (_, __) => 'Rs',
    );

    final settingsAsync = ref.watch(appSettingsProvider);
    final dFormat = settingsAsync.maybeWhen(data: (s) => s.dateFormat, orElse: () => 'dd MMM yyyy');
    final tFormat = settingsAsync.maybeWhen(data: (s) => s.timeFormat, orElse: () => 'hh:mm a');

    return Scaffold(
      appBar: AppBar(
        title: Text(invoice.invoiceNumber),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () async {
              final items = await ref.read(billingRepositoryProvider).getInvoiceItems(invoice.id);
              final business = await ref.read(businessRepositoryProvider).getProfile();
              final settings = await ref.read(settingsRepositoryProvider).getSettings();
              final products = await ref.read(productRepositoryProvider).getAllProducts();
              await InvoicePdfService.shareInvoice(invoice, items, customer, business, settings, products: products);
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () async {
              final items = await ref.read(billingRepositoryProvider).getInvoiceItems(invoice.id);
              final business = await ref.read(businessRepositoryProvider).getProfile();
              final settings = await ref.read(settingsRepositoryProvider).getSettings();
              final products = await ref.read(productRepositoryProvider).getAllProducts();
              await InvoicePdfService.printInvoice(invoice, items, customer, business, settings, products: products);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bill To:', style: Theme.of(context).textTheme.bodySmall),
                      Text(customer?.name ?? 'Unknown', 
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 20, 
                          fontWeight: FontWeight.bold
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (customer?.phone != null) Text(customer!.phone!, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Date:', style: Theme.of(context).textTheme.bodySmall),
                    Text(DateFormat(dFormat).format(invoice.date), style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(DateFormat(tFormat).format(invoice.date), style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),
            Text('Items', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            itemsAsync.when(
              data: (items) => Column(
                children: items.map((item) {
                  final isJewellery = item.grossWeight != null;
                  final subtitle = isJewellery
                      ? 'Wt: ${item.grossWeight}g | Rate: $currency ${item.rate} | Mkg: ${item.makingCharges}'
                      : '${item.quantity} x $currency ${item.unitPrice}';
                      
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(item.productName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(subtitle),
                        if (isJewellery) Text('Purity: ${item.purity} | HSN: ${item.hsnCode}', style: const TextStyle(fontSize: 11)),
                      ],
                    ),
                    trailing: Text('$currency ${item.total.toStringAsFixed(2)}'),
                  );
                }).toList(),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const Text('Error loading items'),
            ),
            const Divider(height: 32),
            _buildSummaryRow('Subtotal', invoice.subtotal, currency),
            _buildSummaryRow('Tax', invoice.taxAmount, currency),
            _buildSummaryRow('Discount', -invoice.discountAmount, currency),
            const Divider(),
            _buildSummaryRow('Grand Total', invoice.grandTotal, currency, isBold: true),
            _buildSummaryRow('Paid Amount', invoice.paidAmount, currency, color: Colors.green),
            _buildSummaryRow('Due Amount', invoice.dueAmount, currency, color: Colors.red, isBold: true),
            
            if (invoice.dueAmount > 0) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showPaymentDialog(context, ref, currency);
                },
                icon: const Icon(Icons.payment),
                label: const Text('Record Payment'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, String currency, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal))),
          Text(
            '$currency ${value.toStringAsFixed(2)}', 
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref, String currency) {
    final amountController = TextEditingController(text: invoice.dueAmount.toStringAsFixed(2));
    String method = 'Cash';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Record Payment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Amount Paid'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: method,
                items: ['Cash', 'UPI', 'Card', 'Bank Transfer']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => method = val ?? 'Cash',
                decoration: const InputDecoration(labelText: 'Payment Method'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              HapticFeedback.mediumImpact();
              final amount = double.tryParse(amountController.text) ?? 0;
              if (amount <= 0) return;

              await ref.read(billingRepositoryProvider).recordPayment(
                invoiceId: invoice.id,
                amount: amount,
                method: method,
                customerId: invoice.customerId,
              );
              
              if (context.mounted) {
                Navigator.pop(context, true);
              }
            },
            child: const Text('Record'),
          ),
        ],
      ),
    ).then((success) {
      if (success == true && context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment recorded!')),
        );
      }
    });
  }
}
