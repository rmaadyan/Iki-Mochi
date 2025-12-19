// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/services/theme_toggle_service.dart';
import 'app/data/services/supabase_service.dart';
import 'app/data/services/local_notification_service.dart';
import 'app/data/providers/auth_provider.dart';
import 'app/routes/app_pages.dart';
import 'app/core/app_lifecycle_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // === INIT SERVICES ===
  final supabase = await Get.putAsync<SupabaseService>(
    () => SupabaseService().init(),
  );

  await Get.putAsync<LocalNotificationService>(
    () => LocalNotificationService().init(),
  );

  Get.put<ThemeToggleService>(ThemeToggleService());
  Get.put<AuthProvider>(AuthProvider());

  // 👁️ PASANG LIFECYCLE OBSERVER
  WidgetsBinding.instance.addObserver(AppLifecycleObserver());

  // 🔐 ROUTE AWAL (SELALU LOGIN KALAU SESSION SUDAH DIBERSIHKAN)
  final String initialRoute = supabase.currentUser == null
      ? Routes.LOGIN
      : Routes.MAIN;

  runApp(MochiApp(initialRoute: initialRoute));
}

class MochiApp extends StatelessWidget {
  final String initialRoute;

  const MochiApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeToggleService>();

    return Obx(() {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Iki Mochi',

        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeService.isDark.value ? ThemeMode.dark : ThemeMode.light,

        initialRoute: initialRoute,
        getPages: AppPages.routes,
      );
    });
  }
}
