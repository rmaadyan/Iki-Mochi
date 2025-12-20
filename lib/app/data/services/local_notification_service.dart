import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<LocalNotificationService> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    // 🔔 MINTA IZIN NOTIFIKASI (ANDROID 13+)
    await _requestPermission();

    return this;
  }

  /// === REQUEST PERMISSION ===
  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      // Android 13+ (API 33) BUTUH REQUEST RUNTIME
      await androidPlugin?.requestNotificationsPermission();
    }
  }

  /// === SHOW NOTIFICATION ===
  Future<void> showOrderSuccess() async {
    const androidDetails = AndroidNotificationDetails(
      'order_channel',
      'Order Notification',
      channelDescription: 'Notifikasi pesanan',
      importance: Importance.max,
      priority: Priority.high,
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      'Order Up! 🎉',
      'Sip, Pesananmu Udah Tercatat',
      notificationDetails,
    );
  }
}
