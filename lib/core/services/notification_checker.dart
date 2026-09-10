import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raag_billing/features/billing/presentation/providers/billing_providers.dart';
import 'package:raag_billing/features/products/presentation/providers/product_providers.dart';
import 'package:raag_billing/features/settings/presentation/providers/settings_providers.dart';
import 'notification_service.dart';
import 'in_app_notification_service.dart';

class NotificationChecker {
  static void checkAll(WidgetRef ref) async {
    final settingsAsync = ref.read(appSettingsProvider);
    final settings = settingsAsync.maybeWhen(data: (d) => d, orElse: () => null);
    
    if (settings == null || !settings.remindersEnabled) return;

    // Check Low Stock
    final products = await ref.read(productRepositoryProvider).getAllProducts();
    for (var p in products) {
      if (p.currentStock <= p.minimumStock && p.minimumStock > 0) {
        final title = 'Low Stock Alert';
        final body = '${p.name} is low on stock (${p.currentStock} ${p.unit} remaining)';
        
        NotificationService.showNotification(id: p.id, title: title, body: body);
        ref.read(inAppNotificationsProvider.notifier).addNotification(id: p.id, title: title, body: body);
      }

      // Check Expiry
      if (p.expiryDate != null) {
        final daysToExpiry = p.expiryDate!.difference(DateTime.now()).inDays;
        if (daysToExpiry <= 7 && daysToExpiry >= 0) {
          final title = 'Expiry Soon';
          final body = '${p.name} will expire in $daysToExpiry days';
          
          NotificationService.showNotification(id: p.id + 10000, title: title, body: body);
          ref.read(inAppNotificationsProvider.notifier).addNotification(id: p.id + 10000, title: title, body: body);
        }
      }
    }

    // Check Pending Dues
    final invoices = await ref.read(billingRepositoryProvider).getAllInvoices();
    final totalDue = invoices.fold(0.0, (sum, item) => sum + item.dueAmount);
    if (totalDue > 0) {
      final title = 'Pending Dues';
      final body = 'Total outstanding dues: ${totalDue.toStringAsFixed(2)}';
      
      NotificationService.showNotification(id: 99999, title: title, body: body);
      ref.read(inAppNotificationsProvider.notifier).addNotification(id: 99999, title: title, body: body);
    }
  }
}
