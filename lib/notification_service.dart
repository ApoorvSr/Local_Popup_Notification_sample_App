import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notificationsPlugin.initialize(initSettings);
  }

  static Future<void> showNotification({
    int id = 0,
    String title = "Scheduled Alert",
    String body = "This is your 15-minute notification",
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Scheduled Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notifDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(id, title, body, notifDetails);
  }
}
