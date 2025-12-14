// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/data/services/theme_toggle_service.dart';
import 'app/data/services/supabase_service.dart';
import 'app/data/providers/auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app/data/services/notification_handler.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  await Get.putAsync(() => SupabaseService().init());
  await Get.putAsync(() => ThemeToggleService().init());

  Get.put<AuthProvider>(AuthProvider());

  final notificationhandler = NotificationHandler();
  notificationhandler.initPushNotification;
  notificationhandler.initLocalNotification();

  runApp(const MochiApp());
}

class MochiApp extends StatelessWidget {
  const MochiApp({super.key});

  ThemeData get _lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: const Color(0xFFFF85A7),
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: const Color(0xFFFFF7FC),
  );

  ThemeData get _darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: const Color(0xFFFF85A7),
    fontFamily: 'Poppins',
    scaffoldBackgroundColor: const Color(0xFF0F0F12),
  );

  @override
  Widget build(BuildContext context) {
    final ThemeToggleService themeService = Get.find();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mochi Restaurant',
        theme: _lightTheme,
        darkTheme: _darkTheme,
        themeMode: themeService.isDark ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      );
    });
  }
}
