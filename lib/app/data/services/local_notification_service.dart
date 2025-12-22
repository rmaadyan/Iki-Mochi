import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class LocalNotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // ================= INIT =================
  Future<LocalNotificationService> init() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _plugin.initialize(initSettings);

    await _requestPermission();

    // 🔥 WAJIB DIPANGGIL (INI YANG KEMARIN HILANG)
    await _createAndroidChannels();

    return this;
  }

  // ================= PERMISSION =================
  Future<void> _requestPermission() async {
    if (!Platform.isAndroid) return;

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();
  }

  // ================= CREATE CHANNELS =================
  Future<void> _createAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'login_channel_v3',
        'Login Notification',
        description: 'Notifikasi login user',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('mochi_cat'),
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'logout_channel_v3',
        'Logout Notification',
        description: 'Notifikasi logout user',
        importance: Importance.defaultImportance,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('mochi_cat'),
      ),
    );

    await androidPlugin.createNotificationChannel(
      const AndroidNotificationChannel(
        'order_channel_v3',
        'Order Notification',
        description: 'Notifikasi pesanan berhasil',
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('mochi_cat'),
      ),
    );
  }

  // ================= LOGIN =================
  Future<void> showLoginSuccess({required String userName}) async {
    await _plugin.show(
      10,
      'Login Berhasil 🎉',
      'Selamat datang, $userName',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'login_channel_v3',
          'Login Notification',
        ),
      ),
    );
  }

  // ================= LOGOUT =================
  Future<void> showLogoutSuccess() async {
    await _plugin.show(
      11,
      'Logout',
      'Sampai jumpa lagi 👋',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'logout_channel_v3',
          'Logout Notification',
        ),
      ),
    );
  }

  // ================= ORDER =================
  Future<void> showOrderSuccess() async {
    await _plugin.show(
      100,
      'Order Up! 🎉',
      'Pesanan kamu sudah tercatat',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'order_channel_v3',
          'Order Notification',
        ),
      ),
    );
  }
}
