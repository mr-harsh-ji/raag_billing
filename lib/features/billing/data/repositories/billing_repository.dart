import 'dart:async';
import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/services/api_client.dart';

class BillingRepository {
  final AppDatabase _db;
  final ApiClient _apiClient = ApiClient();

  BillingRepository(this._db);

  Future<void> syncFromCloud() async {
    try {
      final res = await _apiClient.dio.get('/invoices');

      if (res.data['success'] == true) {
        final List invoicesJson = res.data['data'] ?? [];

        for (var inv in invoicesJson) {
          final id = int.tryParse(inv['id']?.toString() ?? '') ?? 0;
          if (id == 0) continue;
          final invoiceNumber = inv['invoice_number']?.toString() ?? 'RB-$id';
          final customerId = int.tryParse(inv['customer_id']?.toString() ?? '') ?? 1;
          final subtotal = double.tryParse(inv['subtotal']?.toString() ?? '') ?? 0.0;
          final taxAmount = double.tryParse(inv['tax_amount']?.toString() ?? '') ?? 0.0;
          final discountAmount = double.tryParse(inv['discount_amount']?.toString() ?? '') ?? 0.0;
          final grandTotal = double.tryParse(inv['grand_total']?.toString() ?? '') ?? 0.0;
          final paidAmount = double.tryParse(inv['paid_amount']?.toString() ?? '') ?? 0.0;
          final dueAmount = double.tryParse(inv['due_amount']?.toString() ?? '') ?? 0.0;
          final paymentMethod = inv['payment_method']?.toString() ?? 'Cash';
          final date = inv['date'] != null ? DateTime.parse(inv['date'].toString()) : DateTime.now();

          // 1. Ensure customer exists in local SQLite to satisfy Foreign Key constraint
          final customerExists = await (_db.select(_db.customers)..where((t) => t.id.equals(customerId))).getSingleOrNull();
          if (customerExists == null) {
            await _db.into(_db.customers).insertOnConflictUpdate(
              CustomersCompanion(
                id: Value(customerId),
                name: Value('Customer #$customerId'),
              ),
            );
          }

          // 2. Insert or update invoice in local SQLite
          await _db.into(_db.invoices).insertOnConflictUpdate(
            InvoicesCompanion(
              id: Value(id),
              invoiceNumber: Value(invoiceNumber),
              customerId: Value(customerId),
              date: Value(date),
              subtotal: Value(subtotal),
              taxAmount: Value(taxAmount),
              discountAmount: Value(discountAmount),
              grandTotal: Value(grandTotal),
              paidAmount: Value(paidAmount),
              dueAmount: Value(dueAmount),
              paymentMethod: Value(paymentMethod),
            ),
          );

          // 3. Sync Invoice Items if present
          if (inv['items'] != null && inv['items'] is List) {
            for (var item in inv['items']) {
              final itemId = int.tryParse(item['id']?.toString() ?? '') ?? 0;
              final productId = int.tryParse(item['product_id']?.toString() ?? '') ?? 1;
              final productName = item['product_name']?.toString() ?? 'Item';
              final quantity = double.tryParse(item['quantity']?.toString() ?? '') ?? 1.0;
              final unitPrice = double.tryParse(item['unit_price']?.toString() ?? '') ?? 0.0;
              final taxPercentage = double.tryParse(item['tax_percentage']?.toString() ?? '') ?? 0.0;
              final total = double.tryParse(item['total']?.toString() ?? '') ?? (quantity * unitPrice);

              final productExists = await (_db.select(_db.products)..where((t) => t.id.equals(productId))).getSingleOrNull();
              if (productExists == null) {
                await _db.into(_db.products).insertOnConflictUpdate(
                  ProductsCompanion(
                    id: Value(productId),
                    name: Value(productName),
                    sellingPrice: Value(unitPrice),
                  ),
                );
              }

              await _db.into(_db.invoiceItems).insertOnConflictUpdate(
                InvoiceItemsCompanion(
                  id: Value(itemId),
                  invoiceId: Value(id),
                  productId: Value(productId),
                  productName: Value(productName),
                  quantity: Value(quantity),
                  unitPrice: Value(unitPrice),
                  taxPercentage: Value(taxPercentage),
                  total: Value(total),
                ),
              );
            }
          }
        }
      }
    } catch (_) {}
  }

  Future<int> createInvoice(InvoicesCompanion invoice, List<InvoiceItemsCompanion> items) async {
    // 1. Save locally in SQLite Database immediately (0ms UI latency)
    final invoiceId = await _db.transaction(() async {
      final id = await _db.into(_db.invoices).insertOnConflictUpdate(invoice);
      
      for (var item in items) {
        await _db.into(_db.invoiceItems).insertOnConflictUpdate(item.copyWith(invoiceId: Value(id)));
        
        final product = await (_db.select(_db.products)..where((t) => t.id.equals(item.productId.value))).getSingleOrNull();
        if (product != null) {
          await _db.update(_db.products).replace(product.copyWith(
            currentStock: product.currentStock - item.quantity.value,
          ));
        }

        await _db.into(_db.stockMovements).insertOnConflictUpdate(StockMovementsCompanion.insert(
          productId: item.productId.value,
          quantity: -item.quantity.value,
          type: 'Sale',
          referenceId: Value(id),
          reason: Value('Invoice #$id'),
        ));
      }
      return id;
    });

    // 2. Post to Cloud MySQL in background without blocking UI
    unawaited(_syncInvoiceToCloud(invoiceId, invoice, items));

    return invoiceId;
  }

  Future<void> _syncInvoiceToCloud(int localInvoiceId, InvoicesCompanion invoice, List<InvoiceItemsCompanion> items) async {
    try {
      final itemsPayload = items.map((i) => {
        'productId': i.productId.value,
        'productName': i.productName.value,
        'quantity': i.quantity.value,
        'unitPrice': i.unitPrice.value,
        'taxPercentage': i.taxPercentage.value,
        'total': i.total.value,
      }).toList();

      final res = await _apiClient.dio.post('/invoices', data: {
        'customerId': invoice.customerId.value,
        'subtotal': invoice.subtotal.value,
        'taxAmount': invoice.taxAmount.value,
        'discountAmount': invoice.discountAmount.value,
        'grandTotal': invoice.grandTotal.value,
        'paidAmount': invoice.paidAmount.value,
        'dueAmount': invoice.dueAmount.value,
        'paymentMethod': invoice.paymentMethod.value,
        'items': itemsPayload,
      });

      if (res.data['success'] == true && res.data['data'] != null) {
        final cloudInvoiceId = int.tryParse(res.data['data']['id']?.toString() ?? '') ?? 0;
        if (cloudInvoiceId > 0 && cloudInvoiceId != localInvoiceId) {
          await (_db.delete(_db.invoices)..where((t) => t.id.equals(localInvoiceId))).go();
          await _db.into(_db.invoices).insertOnConflictUpdate(invoice.copyWith(id: Value(cloudInvoiceId)));
        }
      }
    } catch (_) {}
  }

  Future<String> generateInvoiceNumber() async {
    final results = await (_db.select(_db.invoices)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(1))
        .get();
    
    final business = await (_db.select(_db.businessProfile)..limit(1)).getSingleOrNull();
    final prefix = business?.invoicePrefix ?? 'RB';
    
    final lastInvoice = results.isNotEmpty ? results.first : null;
    final nextId = (lastInvoice?.id ?? 0) + 1;
    return '$prefix-${nextId.toString().padLeft(6, '0')}';
  }

  Stream<List<Invoice>> watchAllInvoices() => (_db.select(_db.invoices)..orderBy([(t) => OrderingTerm.desc(t.date)])).watch();

  Future<List<Invoice>> getAllInvoices() => (_db.select(_db.invoices)..orderBy([(t) => OrderingTerm.desc(t.date)])).get();

  Future<Invoice> getInvoiceById(int id) => (_db.select(_db.invoices)..where((t) => t.id.equals(id))).getSingle();

  Future<List<InvoiceItem>> getInvoiceItems(int invoiceId) => 
    (_db.select(_db.invoiceItems)..where((t) => t.invoiceId.equals(invoiceId))).get();

  Future<void> recordPayment({
    required int invoiceId,
    required double amount,
    required String method,
    required int customerId,
    String? notes,
  }) async {
    return _db.transaction(() async {
      await _db.into(_db.payments).insertOnConflictUpdate(PaymentsCompanion.insert(
        invoiceId: Value(invoiceId),
        customerId: customerId,
        amount: amount,
        method: method,
        notes: Value(notes),
      ));

      final invoice = await getInvoiceById(invoiceId);
      final newPaidAmount = invoice.paidAmount + amount;
      final newDueAmount = invoice.grandTotal - newPaidAmount;

      await _db.update(_db.invoices).replace(invoice.copyWith(
        paidAmount: newPaidAmount,
        dueAmount: newDueAmount,
      ));
    });
  }

  Stream<List<Payment>> watchPaymentsByInvoice(int invoiceId) {
    return (_db.select(_db.payments)..where((t) => t.invoiceId.equals(invoiceId))).watch();
  }
}
