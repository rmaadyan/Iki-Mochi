// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/data/services/theme_toggle_service.dart';
import 'app/data/services/supabase_service.dart';
import 'app/data/providers/auth_provider.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) Register SupabaseService first (it initializes dotenv & Supabase)
  //    SupabaseService.init() must return Future<SupabaseService>
  await Get.putAsync(() => SupabaseService().init());

  // 2) Now register auth provider which depends on SupabaseService
  //    If your AuthProvider has its own init(), prefer Get.putAsync(() => AuthProvider().init());
  Get.put<AuthProvider>(AuthProvider());

  // 3) Register ThemeToggleService (reads SharedPreferences internally)
  await Get.putAsync(() => ThemeToggleService().init());

  // 4) run the app
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
