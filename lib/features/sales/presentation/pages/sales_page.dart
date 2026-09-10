import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:raag_billing/features/billing/presentation/providers/billing_providers.dart';
import 'package:raag_billing/features/customers/presentation/providers/customer_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';
import 'invoice_details_page.dart';

class SalesPage extends ConsumerStatefulWidget {
  const SalesPage({super.key});

  @override
  ConsumerState<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends ConsumerState<SalesPage> {
  String _selectedPaymentMethod = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesStreamProvider);
    final customersAsync = ref.watch(filteredCustomersProvider);
    final businessAsync = ref.watch(businessProfileProvider);

    final currency = businessAsync.when(
      data: (d) => d.currencySymbol,
      loading: () => 'Rs',
      error: (_, __) => 'Rs',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales History'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (val) => setState(() => _selectedPaymentMethod = val),
            itemBuilder: (context) => ['All', 'Cash', 'UPI', 'Card', 'Bank Transfer']
                .map((e) => PopupMenuItem(value: e, child: Text(e)))
                .toList(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Bill No. or Customer Phone...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty 
                  ? IconButton(icon: const Icon(Icons.clear), onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    })
                  : null,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
            ),
          ),
          Expanded(
            child: invoicesAsync.when(
              data: (invoices) {
                final filteredInvoices = invoices.where((inv) {
                  final matchesMethod = _selectedPaymentMethod == 'All' || inv.paymentMethod == _selectedPaymentMethod;
                  
                  final customer = customersAsync.value?.firstWhere((c) => c.id == inv.customerId);
                  final matchesSearch = inv.invoiceNumber.toLowerCase().contains(_searchQuery) ||
                      (customer?.phone?.toLowerCase().contains(_searchQuery) ?? false);
                  
                  return matchesMethod && matchesSearch;
                }).toList();

                if (filteredInvoices.isEmpty) {
                  return const Center(child: Text('No sales found for selected filter.'));
                }
                return ListView.builder(
                  itemCount: filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = filteredInvoices[index];
                    final customer = customersAsync.value?.firstWhere((c) => c.id == invoice.customerId);
                    
                    return ListTile(
                      title: Text(invoice.invoiceNumber, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('${customer?.name ?? 'Loading...'} | ${DateFormat('dd MMM yyyy, hh:mm a').format(invoice.date)}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Container(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text('$currency ${invoice.grandTotal.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            if (invoice.dueAmount > 0)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text('Due: $currency ${invoice.dueAmount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontSize: 12)),
                              ),
                          ],
                        ),
                      ),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => InvoiceDetailsPage(invoice: invoice, customer: customer)),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
