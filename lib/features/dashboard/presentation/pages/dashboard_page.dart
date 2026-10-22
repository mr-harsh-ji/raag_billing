import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:raag_billing/features/billing/presentation/providers/billing_providers.dart';
import 'package:raag_billing/features/products/presentation/providers/product_providers.dart';
import 'package:raag_billing/features/customers/presentation/providers/customer_providers.dart';
import 'package:raag_billing/features/inventory/presentation/providers/inventory_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';
import 'package:raag_billing/core/services/notification_checker.dart';
import 'package:raag_billing/core/services/in_app_notification_service.dart';
import 'package:raag_billing/features/sales/presentation/pages/invoice_details_page.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationChecker.checkAll(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesStreamProvider);
    final customersAsync = ref.watch(filteredCustomersProvider);
    final businessAsync = ref.watch(businessProfileProvider);
    
    final screenSize = MediaQuery.of(context).size;

    final currency = businessAsync.when(
      data: (d) => d.currencySymbol,
      loading: () => 'Rs',
      error: (_, __) => 'Rs',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Raag Billing'),
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final notifications = ref.watch(inAppNotificationsProvider);
              final unreadCount = notifications.where((n) => !n.isRead).length;
              
              return Badge(
                label: Text(unreadCount.toString()),
                isLabelVisible: unreadCount > 0,
                child: IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showNotifications(context, ref);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(businessRepositoryProvider).syncFromCloud();
          await ref.read(productRepositoryProvider).syncFromCloud();
          await ref.read(customerRepositoryProvider).syncFromCloud();
          await ref.read(billingRepositoryProvider).syncFromCloud();
          await ref.read(inventoryRepositoryProvider).syncFromCloud();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('Welcome Back!', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 20),
            
            // Quick Action Grid
            GridView.count(
              crossAxisCount: screenSize.width > 600 ? 8 : 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: [
                _QuickAction(icon: Icons.receipt_long, label: 'New Bill', color: Colors.blue, onTap: () => context.go('/billing')),
                _QuickAction(icon: Icons.add_box, label: 'Product', color: Colors.green, onTap: () => context.go('/products')),
                _QuickAction(icon: Icons.person_add, label: 'Customer', color: Colors.orange, onTap: () => context.go('/customers')),
                _QuickAction(icon: Icons.assessment, label: 'Reports', color: Colors.purple, onTap: () => context.push('/reports')),
              ],
            ),
            
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Overview', style: Theme.of(context).textTheme.titleLarge),
                TextButton(onPressed: () => context.push('/reports'), child: const Text('View All')),
              ],
            ),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _OverviewRow(
                      label: 'Total Sales', 
                      value: invoicesAsync.when(
                        data: (list) => '$currency ${list.fold(0.0, (sum, item) => sum + item.grandTotal).toStringAsFixed(2)}',
                        loading: () => '...',
                        error: (_, __) => 'Error',
                      ),
                      icon: Icons.trending_up,
                      color: Colors.green,
                    ),
                    const Divider(),
                    _OverviewRow(
                      label: 'Total Dues', 
                      value: invoicesAsync.when(
                        data: (list) => '$currency ${list.fold(0.0, (sum, item) => sum + item.dueAmount).toStringAsFixed(2)}',
                        loading: () => '...',
                        error: (_, __) => 'Error',
                      ),
                      icon: Icons.money_off,
                      color: Colors.red,
                    ),
                    const Divider(),
                    _OverviewRow(
                      label: 'Total Customers', 
                      value: customersAsync.when(
                        data: (list) => list.length.toString(),
                        loading: () => '...',
                        error: (_, __) => '0',
                      ),
                      icon: Icons.people,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            Text('Pending Dues', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            invoicesAsync.when(
              data: (list) {
                final dueInvoices = list.where((inv) => inv.dueAmount > 0).toList();
                if (dueInvoices.isEmpty) {
                  return const Center(child: Padding(padding: EdgeInsets.all(16), child: Text('No pending dues!')));
                }
                return Column(
                  children: dueInvoices.take(3).map((inv) {
                    final customer = customersAsync.maybeWhen(
                      data: (clist) => clist.firstWhere((c) => c.id == inv.customerId),
                      orElse: () => null,
                    );
                    return ListTile(
                      title: Text(customer?.name ?? 'Customer #${inv.customerId}', maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('Due: $currency ${inv.dueAmount} | ${DateFormat('dd MMM').format(inv.date)}'),
                      trailing: SizedBox(
                        width: 80,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () {
                            HapticFeedback.lightImpact();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => InvoiceDetailsPage(invoice: inv, customer: customer)),
                            );
                          },
                          child: const Text('Settle', style: TextStyle(fontSize: 11)),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),

            const SizedBox(height: 24),
            Text('Recent Sales', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            invoicesAsync.when(
              data: (list) => list.isEmpty 
                ? const Center(child: Padding(padding: EdgeInsets.all(16), child: Text('No sales yet')))
                : Column(
                    children: list.take(5).map((inv) => ListTile(
                      title: Text(inv.invoiceNumber),
                      subtitle: Text(DateFormat('dd MMM, hh:mm a').format(inv.date)),
                      trailing: Text('$currency ${inv.grandTotal}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () => context.push('/sales'),
                    )).toList(),
                  ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text('Error loading sales'),
            ),
          ],
        ),
      ),
    );
  }

  void _showNotifications(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) => Consumer(
          builder: (context, ref, child) {
            final notifications = ref.watch(inAppNotificationsProvider);
            
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Notifications', style: Theme.of(context).textTheme.titleLarge),
                      if (notifications.isNotEmpty)
                        TextButton(
                          onPressed: () => ref.read(inAppNotificationsProvider.notifier).clear(),
                          child: const Text('Clear All'),
                        ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: notifications.isEmpty
                    ? const Center(child: Text('No notifications'))
                    : ListView.builder(
                        controller: scrollController,
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final n = notifications[notifications.length - 1 - index];
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: n.isRead ? Colors.grey : Colors.blue.withAlpha(50),
                              child: Icon(
                                n.title.contains('Low') ? Icons.warning : Icons.info,
                                color: n.isRead ? Colors.grey : Colors.blue,
                              ),
                            ),
                            title: Text(n.title, style: TextStyle(fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.body),
                                Text(
                                  DateFormat('dd MMM, hh:mm a').format(n.timestamp),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            onTap: () {
                              ref.read(inAppNotificationsProvider.notifier).markAsRead(n.id);
                            },
                          );
                        },
                      ),
                ),
              ],
            );
          },
        ),
      ),
    ).then((_) {
      if (mounted) {
        ref.read(inAppNotificationsProvider.notifier).markAllAsRead();
      }
    });
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            HapticFeedback.mediumImpact();
            onTap();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withAlpha(26), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color),
          ),
        ),
        const SizedBox(height: 4),
        Flexible(
          child: Text(
            label, 
            style: const TextStyle(fontSize: 10),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _OverviewRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _OverviewRow({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 16),
          Text(label, style: const TextStyle(fontSize: 16)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
