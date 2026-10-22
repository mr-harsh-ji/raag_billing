import 'package:drift/drift.dart';
import 'package:raag_billing/core/database/app_database.dart';
import 'package:raag_billing/core/services/api_client.dart';

class CloudReportSummary {
  final int todayInvoicesCount;
  final double todayTotalSales;
  final double todayPaidRevenue;
  final double totalPendingDues;
  final int totalProducts;
  final int lowStockCount;
  final int totalCustomers;

  CloudReportSummary({
    required this.todayInvoicesCount,
    required this.todayTotalSales,
    required this.todayPaidRevenue,
    required this.totalPendingDues,
    required this.totalProducts,
    required this.lowStockCount,
    required this.totalCustomers,
  });
}

class ReportRepository {
  final AppDatabase _db;
  final ApiClient _apiClient = ApiClient();

  ReportRepository(this._db);

  Future<CloudReportSummary?> getSummaryFromCloud() async {
    try {
      final res = await _apiClient.dio.get('/reports/summary');
      if (res.data['success'] == true && res.data['data'] != null) {
        final d = res.data['data'];
        return CloudReportSummary(
          todayInvoicesCount: int.tryParse(d['todayInvoicesCount']?.toString() ?? '') ?? 0,
          todayTotalSales: double.tryParse(d['todayTotalSales']?.toString() ?? '') ?? 0.0,
          todayPaidRevenue: double.tryParse(d['todayPaidRevenue']?.toString() ?? '') ?? 0.0,
          totalPendingDues: double.tryParse(d['totalPendingDues']?.toString() ?? '') ?? 0.0,
          totalProducts: int.tryParse(d['totalProducts']?.toString() ?? '') ?? 0,
          lowStockCount: int.tryParse(d['lowStockCount']?.toString() ?? '') ?? 0,
          totalCustomers: int.tryParse(d['totalCustomers']?.toString() ?? '') ?? 0,
        );
      }
    } catch (_) {}
    return null;
  }

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

    return query.get();
  }

  Future<List<TypedResult>> getSalesOverTime({required DateTime start, required DateTime end}) async {
     return []; 
  }
}
