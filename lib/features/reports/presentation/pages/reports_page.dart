import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:raag_billing/features/reports/presentation/providers/report_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);
    final totalSales = ref.watch(totalSalesProvider);
    final totalPurchases = ref.watch(totalPurchasesProvider);
    final totalDue = ref.watch(totalDueProvider);
    final lowStockCount = ref.watch(lowStockCountProvider);
    final businessAsync = ref.watch(businessProfileProvider);
    
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 360;

    final currency = businessAsync.when(
      data: (d) => d.currencySymbol,
      loading: () => 'Rs',
      error: (_, __) => 'Rs',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Reports'),
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: dateRange,
              );
              if (picked != null) {
                ref.read(dateRangeProvider.notifier).state = picked;
              }
            },
          ),
          if (dateRange != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => ref.read(dateRangeProvider.notifier).state = null,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(totalSalesProvider);
          ref.invalidate(totalPurchasesProvider);
          ref.invalidate(totalDueProvider);
          ref.invalidate(lowStockCountProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (dateRange != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  'Showing data from ${DateFormat('dd MMM').format(dateRange.start)} to ${DateFormat('dd MMM yyyy').format(dateRange.end)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ),
            
            GridView.count(
              crossAxisCount: screenSize.width > 600 ? 4 : 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: screenSize.width > 600 ? 1.5 : 1.2,
              children: [
                _ReportCard(
                  title: 'Total Sales',
                  value: totalSales.when(
                    data: (v) => '$currency ${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.green,
                  icon: Icons.trending_up,
                ),
                _ReportCard(
                  title: 'Total Purchases',
                  value: totalPurchases.when(
                    data: (v) => '$currency ${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.orange,
                  icon: Icons.shopping_cart,
                ),
                _ReportCard(
                  title: 'Total Receivable',
                  value: totalDue.when(
                    data: (v) => '$currency ${v.toStringAsFixed(2)}',
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.red,
                  icon: Icons.account_balance_wallet,
                ),
                _ReportCard(
                  title: 'Low Stock Items',
                  value: lowStockCount.when(
                    data: (v) => v.toString(),
                    loading: () => '...',
                    error: (_, __) => 'Error',
                  ),
                  color: Colors.purple,
                  icon: Icons.inventory_2,
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            Text('Profit Summary (Estimate)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Gross Profit', style: TextStyle(fontSize: 18)),
                    totalSales.when(
                      data: (sales) => totalPurchases.when(
                        data: (purchases) {
                          final profit = sales - purchases;
                          return Text(
                            '$currency ${profit.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: profit >= 0 ? Colors.green : Colors.red,
                            ),
                          );
                        },
                        loading: () => const CircularProgressIndicator(),
                        error: (_, __) => const Text('Error'),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('Error'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  final IconData icon;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              title, 
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.bottomLeft,
              child: Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
