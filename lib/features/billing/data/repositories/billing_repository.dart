import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';

class BillingRepository {
  final AppDatabase _db;

  BillingRepository(this._db);

  Future<int> createInvoice(InvoicesCompanion invoice, List<InvoiceItemsCompanion> items) async {
    return _db.transaction(() async {
      final invoiceId = await _db.into(_db.invoices).insert(invoice);
      
      for (var item in items) {
        await _db.into(_db.invoiceItems).insert(item.copyWith(invoiceId: Value(invoiceId)));
        
        // Decrease stock
        final product = await (_db.select(_db.products)..where((t) => t.id.equals(item.productId.value))).getSingle();
        await _db.update(_db.products).replace(product.copyWith(
          currentStock: product.currentStock - item.quantity.value,
        ));

        // Log Movement
        await _db.into(_db.stockMovements).insert(StockMovementsCompanion.insert(
          productId: item.productId.value,
          quantity: -item.quantity.value,
          type: 'Sale',
          referenceId: Value(invoiceId),
          reason: Value('Invoice #$invoiceId'),
        ));
      }
      
      return invoiceId;
    });
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
      // 1. Create Payment record
      await _db.into(_db.payments).insert(PaymentsCompanion.insert(
        invoiceId: Value(invoiceId),
        customerId: customerId,
        amount: amount,
        method: method,
        notes: Value(notes),
      ));

      // 2. Update Invoice due amount
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

