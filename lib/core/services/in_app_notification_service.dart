import 'package:flutter_riverpod/flutter_riverpod.dart';

class InAppNotification {
  final int id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  InAppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}

class InAppNotificationNotifier extends StateNotifier<List<InAppNotification>> {
  InAppNotificationNotifier() : super([]);

  void addNotification({required int id, required String title, required String body}) {
    // Prevent duplicate notifications with same ID if they are very recent
    final existing = state.where((n) => n.id == id).toList();
    if (existing.isNotEmpty) {
      final last = existing.last;
      if (DateTime.now().difference(last.timestamp).inMinutes < 60) {
        return; 
      }
    }

    final newNotification = InAppNotification(
      id: id,
      title: title,
      body: body,
      timestamp: DateTime.now(),
    );
    state = [...state, newNotification];
  }

  void markAsRead(int id) {
    state = [
      for (final n in state)
        if (n.id == id)
          InAppNotification(id: n.id, title: n.title, body: n.body, timestamp: n.timestamp, isRead: true)
        else
          n
    ];
  }

  void markAllAsRead() {
    state = [
      for (final n in state)
        InAppNotification(id: n.id, title: n.title, body: n.body, timestamp: n.timestamp, isRead: true)
    ];
  }

  void clear() {
    state = [];
  }
  
  int get unreadCount => state.where((n) => !n.isRead).length;
}

final inAppNotificationsProvider = StateNotifierProvider<InAppNotificationNotifier, List<InAppNotification>>((ref) {
  return InAppNotificationNotifier();
});
