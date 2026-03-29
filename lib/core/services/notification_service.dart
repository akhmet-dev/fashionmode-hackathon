import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationDetails _androidDetails =
      AndroidNotificationDetails(
        'avishu_orders',
        'Order Updates',
        channelDescription: 'Notifications for order status changes',
        importance: Importance.max,
        priority: Priority.high,
      );
  static const DarwinNotificationDetails _iosDetails =
      DarwinNotificationDetails();
  static const NotificationDetails _details = NotificationDetails(
    android: _androidDetails,
    iOS: _iosDetails,
  );

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'avishu_orders',
            'Order Updates',
            description: 'Notifications for order status changes',
            importance: Importance.max,
          ),
        );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  Future<void> showRemoteMessage(RemoteMessage message) async {
    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if ((title == null || title.isEmpty) && (body == null || body.isEmpty)) {
      return;
    }

    final notificationId = message.messageId?.hashCode.abs() ??
        DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await _plugin.show(notificationId, title, body, _details);
  }

  Future<void> showUpdate({
    required String title,
    required String body,
    int? id,
  }) async {
    final notificationId =
        id ?? DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await _plugin.show(notificationId, title, body, _details);
  }

  Future<void> clearPresentedNotifications() async {
    await _plugin.cancelAll();
  }
}
