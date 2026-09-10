import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/core/database/database_provider.dart';
import '../../data/repositories/report_repository.dart';

final reportRepositoryProvider = Provider<ReportRepository>((ref) {
  final db = ref.watch(databaseProvider);
  return ReportRepository(db);
});

final dateRangeProvider = StateProvider<DateTimeRange?>((ref) => null);

final totalSalesProvider = FutureProvider<double>((ref) {
  final range = ref.watch(dateRangeProvider);
  return ref.watch(reportRepositoryProvider).getTotalSales(
    start: range?.start,
    end: range?.end,
  );
});

final totalPurchasesProvider = FutureProvider<double>((ref) {
  final range = ref.watch(dateRangeProvider);
  return ref.watch(reportRepositoryProvider).getTotalPurchases(
    start: range?.start,
    end: range?.end,
  );
});

final totalDueProvider = FutureProvider<double>((ref) {
  return ref.watch(reportRepositoryProvider).getTotalDue();
});

final lowStockCountProvider = FutureProvider<int>((ref) async {
  final products = await ref.watch(reportRepositoryProvider).getLowStockProducts();
  return products.length;
});

