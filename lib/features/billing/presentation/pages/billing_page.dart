import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' as drift;
import 'package:intl/intl.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/services/invoice_pdf_service.dart';
import 'package:raag_billing/core/widgets/barcode_scanner_widget.dart';
import 'package:raag_billing/features/products/presentation/providers/product_providers.dart';
import 'package:raag_billing/features/customers/presentation/providers/customer_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';
import 'package:raag_billing/features/billing/presentation/providers/billing_providers.dart';

import '../../../../core/services/notification_checker.dart';

class BillingPage extends ConsumerWidget {
  const BillingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final businessAsync = ref.watch(businessProfileProvider);
    final currency = businessAsync.when(
      data: (d) => d.currencySymbol,
      loading: () => 'Rs',
      error: (_, __) => 'Rs',
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Bill'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {
              HapticFeedback.heavyImpact();
              ref.read(cartProvider.notifier).clear();
            },
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isLandscape = constraints.maxWidth > 600;
          
          if (isLandscape) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      const _CustomerSelector(),
                      const Divider(height: 1),
                      const _ProductSearchField(),
                      Expanded(child: _CartItemList(currency: currency)),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                SizedBox(
                  width: 320,
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: _BillingSummary(currency: currency),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return Column(
            children: [
              const _CustomerSelector(),
              const Divider(),
              const _ProductSearchField(),
              Expanded(child: _CartItemList(currency: currency)),
              _BillingSummary(currency: currency),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: cart.items.isEmpty || cart.customer == null 
              ? null 
              : () {
                  HapticFeedback.mediumImpact();
                  _checkout(context, ref, currency);
                },
            child: const Text('Proceed to Payment'),
          ),
        ),
      ),
    );
  }

  void _checkout(BuildContext context, WidgetRef ref, String currency) async {
     final repo = ref.read(billingRepositoryProvider);
     final invoiceNo = await repo.generateInvoiceNumber();
     
     if (context.mounted) _showPaymentDialog(context, ref, invoiceNo, currency);
  }

  void _showPaymentDialog(BuildContext context, WidgetRef ref, String invoiceNo, String currency) {
    final cart = ref.read(cartProvider);
    final paidController = TextEditingController(text: cart.grandTotal.toStringAsFixed(2));
    String paymentMethod = 'Cash';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 16, right: 16, top: 16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Complete Sale', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              Text('Invoice No: $invoiceNo'),
              Text('Grand Total: $currency ${cart.grandTotal.toStringAsFixed(2)}'),
              const SizedBox(height: 16),
              TextField(
                controller: paidController,
                decoration: const InputDecoration(labelText: 'Paid Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: paymentMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: ['Cash', 'UPI', 'Card', 'Bank Transfer']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => paymentMethod = val ?? 'Cash',
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  HapticFeedback.mediumImpact();
                  final paid = double.tryParse(paidController.text) ?? 0.0;
                  final due = cart.grandTotal - paid;
                  
                  final invoice = InvoicesCompanion.insert(
                    invoiceNumber: invoiceNo,
                    customerId: cart.customer!.id,
                    subtotal: drift.Value(cart.subtotal),
                    taxAmount: drift.Value(cart.totalTax),
                    discountAmount: drift.Value(cart.discountAmount),
                    discountPercentage: drift.Value(cart.discountPercentage),
                    grandTotal: drift.Value(cart.grandTotal),
                    paidAmount: drift.Value(paid),
                    dueAmount: drift.Value(due),
                    paymentMethod: drift.Value(paymentMethod),
                    cgst: drift.Value(cart.totalTax / 2),
                    sgst: drift.Value(cart.totalTax / 2),
                    roundOff: drift.Value(cart.roundOff),
                  );

                  final items = cart.items.map((item) => InvoiceItemsCompanion.insert(
                    invoiceId: 0, 
                    productId: item.product.id,
                    productName: item.product.name,
                    quantity: item.quantity,
                    unitPrice: item.product.sellingPrice,
                    taxPercentage: item.product.taxPercentage,
                    total: item.totalWithTax,
                    hsnCode: drift.Value(item.hsnCode),
                    purity: drift.Value(item.purity),
                    grossWeight: drift.Value(item.grossWeight),
                    stoneWeight: drift.Value(item.stoneWeight),
                    makingCharges: drift.Value(item.makingCharges),
                    netWeight: drift.Value(item.netWeight),
                    rate: drift.Value(item.rate),
                    taxableValue: drift.Value(item.taxableValue),
                    batchNumber: drift.Value(item.batchNumber),
                    expiryDate: drift.Value(item.expiryDate),
                    manufacturingDate: drift.Value(item.manufacturingDate),
                  )).toList();

                  final invoiceId = await ref.read(billingRepositoryProvider).createInvoice(invoice, items);
                  
                  // Check for notifications after sale
                  NotificationChecker.checkAll(ref);

                  final savedInvoice = await ref.read(billingRepositoryProvider).getInvoiceById(invoiceId);
                  final savedItems = await ref.read(billingRepositoryProvider).getInvoiceItems(invoiceId);
                  final business = await ref.read(businessRepositoryProvider).getProfile();
                  final currentProducts = cart.items.map((i) => i.product).toList();

                  ref.read(cartProvider.notifier).clear();
                  
                  if (context.mounted) {
                    Navigator.pop(context); // Close payment dialog
                    
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Invoice Saved!'),
                        content: const Text('What would you like to do next?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Done'),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final settings = await ref.read(settingsRepositoryProvider).getSettings();
                              await InvoicePdfService.shareInvoice(savedInvoice, savedItems, cart.customer, business, settings, products: currentProducts);
                            },
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () async {
                              final settings = await ref.read(settingsRepositoryProvider).getSettings();
                              await InvoicePdfService.printInvoice(savedInvoice, savedItems, cart.customer, business, settings, products: currentProducts);
                            },
                            icon: const Icon(Icons.print),
                            label: const Text('Print'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                child: const Text('Save & Finish'),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomerSelector extends ConsumerWidget {
  const _CustomerSelector();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCustomer = ref.watch(cartProvider).customer;
    
    return ListTile(
      leading: const Icon(Icons.person_outline),
      title: Text(selectedCustomer?.name ?? 'Select Customer'),
      subtitle: Text(selectedCustomer?.phone ?? 'Walk-in Customer'),
      trailing: const Icon(Icons.search),
      onTap: () => _showCustomerSearch(context, ref),
    );
  }

  void _showCustomerSearch(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const _CustomerSearchSheet(),
    );
  }
}

class _CustomerSearchSheet extends ConsumerWidget {
  const _CustomerSearchSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customersAsync = ref.watch(filteredCustomersProvider);
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: const InputDecoration(hintText: 'Search customer...', prefixIcon: Icon(Icons.search)),
            onChanged: (val) => ref.read(customerSearchQueryProvider.notifier).state = val,
          ),
        ),
        Expanded(
          child: customersAsync.when(
            data: (customers) => ListView.builder(
              itemCount: customers.length,
              itemBuilder: (context, index) {
                final c = customers[index];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.phone ?? ''),
                  onTap: () {
                    ref.read(cartProvider.notifier).setCustomer(c);
                    Navigator.pop(context);
                  },
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Error'),
          ),
        ),
      ],
    );
  }
}

class _ProductSearchField extends ConsumerWidget {
  const _ProductSearchField();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.0, 
        vertical: isLandscape ? 8.0 : 16.0
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search product to add...',
                prefixIcon: const Icon(Icons.add_shopping_cart),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onTap: () => _showProductSearch(context, ref),
              readOnly: true,
            ),
          ),
          const SizedBox(width: 8),
          Consumer(
            builder: (context, ref, child) {
              final scanEnabled = ref.watch(appSettingsProvider).maybeWhen(
                data: (s) => s.barcodeScanEnabled,
                orElse: () => true,
              );
              if (!scanEnabled) return const SizedBox();
              
              return IconButton.filledTonal(
                onPressed: () => _openScanner(context, ref),
                icon: const Icon(Icons.qr_code_scanner),
                tooltip: 'Scan Barcode',
              );
            },
          ),
        ],
      ),
    );
  }

  void _openScanner(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BarcodeScannerWidget(
          onDetect: (barcode) async {
            final product = await ref.read(productRepositoryProvider).getProductByBarcode(barcode);
            if (product != null) {
              if (context.mounted) {
                final business = ref.read(businessProfileProvider).value;
                final shopCategory = business?.shopCategory ?? 'General';
                
                if (shopCategory == 'Jewellery') {
                  _showJewelleryItemDialog(context, ref, product);
                } else if (shopCategory == 'Pharmacy') {
                  _showPharmacyItemDialog(context, ref, product);
                } else {
                  ref.read(cartProvider.notifier).addItem(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added ${product.name}'), duration: const Duration(seconds: 1)),
                  );
                }
              }
            } else {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Product not found!')),
                );
              }
            }
          },
        ),
      ),
    );
  }

  void _showProductSearch(BuildContext context, WidgetRef ref) async {
    final business = ref.read(businessProfileProvider).value;
    final shopCategory = business?.shopCategory ?? 'General';
    final isJewellery = shopCategory == 'Jewellery';
    final isPharmacy = shopCategory == 'Pharmacy';

    final product = await showModalBottomSheet<Product>(
      context: context,
      isScrollControlled: true,
      builder: (context) => FractionallySizedBox(
        heightFactor: 0.8,
        child: _ProductSearchSheet(isJewellery: isJewellery),
      ),
    );

    if (product != null && context.mounted) {
      if (isJewellery) {
        _showJewelleryItemDialog(context, ref, product);
      } else if (isPharmacy) {
        _showPharmacyItemDialog(context, ref, product);
      } else {
        ref.read(cartProvider.notifier).addItem(product);
      }
    }
  }
}

class _ProductSearchSheet extends ConsumerWidget {
  final bool isJewellery;
  const _ProductSearchSheet({required this.isJewellery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);
    final businessAsync = ref.watch(businessProfileProvider);
    final currency = businessAsync.when(data: (d) => d.currencySymbol, loading: () => 'Rs', error: (_, __) => 'Rs');
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Search product...', prefixIcon: Icon(Icons.search)),
            onChanged: (val) => ref.read(searchQueryProvider.notifier).state = val,
          ),
        ),
        Expanded(
          child: productsAsync.when(
            data: (products) => ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final p = products[index];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text(isJewellery 
                    ? 'HSN: ${p.hsnCode ?? 'N/A'} | Purity: ${p.purity ?? 'N/A'}'
                    : '$currency ${p.sellingPrice} | Stock: ${p.currentStock}'),
                  onTap: () {
                    Navigator.pop(context, p);
                  },
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Text('Error'),
          ),
        ),
      ],
    );
  }
}

void _showJewelleryItemDialog(BuildContext context, WidgetRef ref, Product product) {
  final weightController = TextEditingController();
  final stoneController = TextEditingController(text: '0');
  final chargesController = TextEditingController(text: '0');
  final rateController = TextEditingController();
  final purityController = TextEditingController(text: product.purity ?? '22K');
  final hsnController = TextEditingController(text: product.hsnCode ?? '');
  final formKey = GlobalKey<FormState>();

  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 360;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        double calculateTotal() {
          final gw = double.tryParse(weightController.text) ?? 0.0;
          final sw = double.tryParse(stoneController.text) ?? 0.0;
          final mc = double.tryParse(chargesController.text) ?? 0.0;
          final rate = double.tryParse(rateController.text) ?? 0.0;
          final netWt = gw - sw;
          return (netWt * rate) + mc;
        }

        return AlertDialog(
          title: Text('Add ${product.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 16 : 18)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: screenSize.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: weightController,
                            decoration: const InputDecoration(labelText: 'Gross Wt', border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Req' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: stoneController,
                            decoration: const InputDecoration(labelText: 'Stone Wt', border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: rateController,
                            decoration: const InputDecoration(labelText: 'Rate', border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                            validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Req' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: chargesController,
                            decoration: const InputDecoration(labelText: 'Mkg Chg', border: OutlineInputBorder()),
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: purityController,
                            decoration: const InputDecoration(labelText: 'Purity', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: hsnController,
                            decoration: const InputDecoration(labelText: 'HSN', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Value:', style: TextStyle(fontWeight: FontWeight.bold)),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text('₹ ${calculateTotal().toStringAsFixed(2)}', 
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 16 : 20, color: Colors.blue)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade800, 
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 12 : 24, vertical: 12),
              ),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final gw = double.tryParse(weightController.text) ?? 0.0;
                  final sw = double.tryParse(stoneController.text) ?? 0.0;
                  final mc = double.tryParse(chargesController.text) ?? 0.0;
                  final rate = double.tryParse(rateController.text) ?? 0.0;
                  
                  ref.read(cartProvider.notifier).addItem(
                    product,
                    grossWeight: gw,
                    stoneWeight: sw,
                    makingCharges: mc,
                    rate: rate,
                    purity: purityController.text,
                    hsnCode: hsnController.text,
                  );
                  
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${product.name} added to bill'),
                        backgroundColor: Colors.green,
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                }
              }, 
              child: const Text('Confirm & Add Item'),
            ),
          ],
        );
      }
    ),
  );
}

void _showPharmacyItemDialog(BuildContext context, WidgetRef ref, Product product) {
  final batchController = TextEditingController(text: product.batchNumber ?? '');
  final quantityController = TextEditingController(text: '1');
  DateTime? mfgDate = product.manufacturingDate;
  DateTime? expiryDate = product.expiryDate;
  final formKey = GlobalKey<FormState>();

  final screenSize = MediaQuery.of(context).size;
  final isSmallScreen = screenSize.width < 360;

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Text('Add ${product.name}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 16 : 18)),
          content: Form(
            key: formKey,
            child: SizedBox(
              width: screenSize.width * 0.9,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: batchController,
                      decoration: const InputDecoration(labelText: 'Batch No.*', border: OutlineInputBorder()),
                      validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: mfgDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (picked != null) setState(() => mfgDate = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'MFG Date*', border: OutlineInputBorder()),
                              child: Text(mfgDate == null ? 'Select' : DateFormat('dd/MM/yyyy').format(mfgDate!)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: expiryDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) setState(() => expiryDate = picked);
                            },
                            child: InputDecorator(
                              decoration: const InputDecoration(labelText: 'Expiry Date*', border: OutlineInputBorder()),
                              child: Text(expiryDate == null ? 'Select' : DateFormat('dd/MM/yyyy').format(expiryDate!)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: quantityController,
                      decoration: const InputDecoration(labelText: 'Quantity', border: OutlineInputBorder()),
                      keyboardType: TextInputType.number,
                      validator: (v) => (double.tryParse(v ?? '') ?? 0) <= 0 ? 'Req' : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  if (mfgDate == null || expiryDate == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Dates are mandatory')),
                    );
                    return;
                  }
                  
                  ref.read(cartProvider.notifier).addItem(
                    product,
                    quantity: double.tryParse(quantityController.text) ?? 1,
                    batchNumber: batchController.text,
                    manufacturingDate: mfgDate,
                    expiryDate: expiryDate,
                  );
                  
                  Navigator.pop(context);
                }
              }, 
              child: const Text('Add Item'),
            ),
          ],
        );
      }
    ),
  );
}

class _CartItemList extends ConsumerWidget {
  final String currency;
  const _CartItemList({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final businessAsync = ref.watch(businessProfileProvider);
    final shopCategory = businessAsync.maybeWhen(data: (d) => d.shopCategory, orElse: () => 'General');
    final isJewellery = shopCategory == 'Jewellery';
    final isPharmacy = shopCategory == 'Pharmacy';

    if (cart.items.isEmpty) {
      return const Center(child: Text('No items in cart'));
    }

    return ListView.builder(
      itemCount: cart.items.length,
      itemBuilder: (context, index) {
        final item = cart.items[index];
        String subtitle = isJewellery 
            ? 'Wt: ${item.grossWeight}g | Rate: $currency ${item.rate} | Mkg: ${item.makingCharges}'
            : '$currency ${item.product.sellingPrice} x ${item.quantity}';
        
        if (isPharmacy && item.batchNumber != null) {
          subtitle += '\nBatch: ${item.batchNumber} | Exp: ${item.expiryDate != null ? DateFormat('MM/yy').format(item.expiryDate!) : 'N/A'}';
        }

        return ListTile(
          title: Text(item.product.name),
          isThreeLine: isPharmacy,
          subtitle: Text(subtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isJewellery) ...[
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity - 1),
                ),
                Text('${item.quantity}'),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => ref.read(cartProvider.notifier).updateQuantity(item.product.id, item.quantity + 1),
                ),
              ] else
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => ref.read(cartProvider.notifier).removeItem(item.product.id),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BillingSummary extends ConsumerWidget {
  final String currency;
  const _BillingSummary({required this.currency});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    return Container(
      padding: EdgeInsets.all(isLandscape ? 12 : 16),
      color: Colors.grey.shade100,
      child: Column(
        children: [
          _SummaryRow(label: 'Subtotal', value: '$currency ${cart.subtotal.toStringAsFixed(2)}'),
          _SummaryRow(label: 'Tax', value: '$currency ${cart.totalTax.toStringAsFixed(2)}'),
          _SummaryRow(
            label: 'Discount (${cart.discountPercentage}%)', 
            value: '$currency ${cart.discountAmount.toStringAsFixed(2)}',
            onTap: () => _showDiscountDialog(context, ref, currency),
          ),
          const Divider(),
          _SummaryRow(
            label: 'Grand Total', 
            value: '$currency ${cart.grandTotal.toStringAsFixed(2)}', 
            isBold: true,
          ),
        ],
      ),
    );
  }

  void _showDiscountDialog(BuildContext context, WidgetRef ref, String currency) {
    final controller = TextEditingController(text: ref.read(cartProvider).discountPercentage.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply Discount'),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Discount Percentage (%)', suffixText: '%'),
          keyboardType: TextInputType.number,
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              ref.read(cartProvider.notifier).setDiscountPercentage(double.tryParse(controller.text) ?? 0.0);
              Navigator.pop(context);
            }, 
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final VoidCallback? onTap;

  const _SummaryRow({required this.label, required this.value, this.isBold = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label, 
                style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value, 
              style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal, 
                color: onTap != null ? Colors.blue : null
              ),
            ),
          ],
        ),
      ),
    );
  }
}
