import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';

class ReportRepository {
  final AppDatabase _db;

  ReportRepository(this._db);

  Future<double> getTotalSales({DateTime? start, DateTime? end}) async {
    final query = _db.selectOnly(_db.invoices)..addColumns([_db.invoices.grandTotal.sum()]);
    if (start != null) query.where(_db.invoices.date.isBiggerOrEqualValue(start));
    if (end != null) query.where(_db.invoices.date.isSmallerOrEqualValue(end));
    
    final result = await query.getSingleOrNull();
    return result?.read(_db.invoices.grandTotal.sum()) ?? 0.0;
  }

  Future<double> getTotalPurchases({DateTime? start, DateTime? end}) async {
    final query = _db.selectOnly(_db.purchases)..addColumns([_db.purchases.totalAmount.sum()]);
    if (start != null) query.where(_db.purchases.date.isBiggerOrEqualValue(start));
    if (end != null) query.where(_db.purchases.date.isSmallerOrEqualValue(end));

    final result = await query.getSingleOrNull();
    return result?.read(_db.purchases.totalAmount.sum()) ?? 0.0;
  }

  Future<double> getTotalDue() async {
    final query = _db.selectOnly(_db.invoices)..addColumns([_db.invoices.dueAmount.sum()]);
    final result = await query.getSingleOrNull();
    return result?.read(_db.invoices.dueAmount.sum()) ?? 0.0;
  }

  Future<List<Product>> getLowStockProducts() async {
    return (_db.select(_db.products)..where((t) => t.currentStock.isSmallerOrEqual(t.minimumStock))).get();
  }

  Future<List<TypedResult>> getProductWiseSales({DateTime? start, DateTime? end}) async {
    final query = _db.selectOnly(_db.invoiceItems)
      ..addColumns([
        _db.invoiceItems.productId,
        _db.invoiceItems.productName,
        _db.invoiceItems.quantity.sum(),
        _db.invoiceItems.total.sum(),
      ])
      ..groupBy([_db.invoiceItems.productId, _db.invoiceItems.productName]);
    
    // Filtering by date requires joining with Invoices
    if (start != null || end != null) {
      // Drift join syntax
    }

    return query.get();
  }

  // Simplified daily sales for chart
  Future<List<TypedResult>> getSalesOverTime({required DateTime start, required DateTime end}) async {
     // This is a bit complex for a simple drift query without custom SQL for date grouping
     // For V1, we'll fetch all and group in Dart for simplicity, or use custom SQL
     return []; 
  }
}

