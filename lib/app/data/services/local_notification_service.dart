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
    await _requestPermission();
    await _createAndroidChannels();

    return this;
  }

  Future<void> _requestPermission() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  // 🔥 CHANNEL TANPA SOUND
  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'general_channel',
        'General Notification',
        description: 'Notifikasi aplikasi',
        importance: Importance.high,
        playSound: false, // ⬅️ PENTING
      ),
    );
  }

  // ================= LOGIN =================
  Future<void> showLoginSuccess({required String userName}) async {
    await _plugin.show(
      1,
      'Login Berhasil',
      'Selamat datang, $userName',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'general_channel',
          'General Notification',
          playSound: false,
        ),
      ),
    );
  }

  // ================= LOGOUT =================
  Future<void> showLogoutSuccess() async {
    await _plugin.show(
      2,
      'Logout',
      'Sampai jumpa lagi',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'general_channel',
          'General Notification',
          playSound: false,
        ),
      ),
    );
  }

  // ================= ORDER =================
  Future<void> showOrderSuccess() async {
    await _plugin.show(
      3,
      'Order Up!',
      'Pesanan kamu sudah tercatat',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'general_channel',
          'General Notification',
          playSound: false,
        ),
      ),
    );
  }
}
