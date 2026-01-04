import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/services/supabase_service.dart';
import 'app/data/services/local_notification_service.dart';
import 'app/data/services/theme_toggle_service.dart';
import 'app/data/providers/auth_provider.dart';
import 'app/routes/app_pages.dart';

import 'app/modules/favorite/controllers/favorite_controller.dart';
import 'app/modules/admin/controllers/admin_order_controller.dart'; 

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ================= INIT SERVICES =================
  final supabase = await Get.putAsync<SupabaseService>(
    () => SupabaseService().init(),
  );

  await Get.putAsync<LocalNotificationService>(
    () => LocalNotificationService().init(),
  );

  Get.put<AuthProvider>(AuthProvider());
  Get.put<ThemeToggleService>(ThemeToggleService());

  // ================= FAVORITE CONTROLLER =================
  Get.put<FavoriteController>(FavoriteController(), permanent: true);

  // ================= ADMIN ORDER CONTROLLER =================
  Get.put<AdminOrderController>(AdminOrderController(), permanent: true);

  // ================= AUTH STATE LISTENER =================
  supabase.authStateChanges.listen((event) {
    final session = event.session;

    if (session == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.MAIN);
    }
  });

  // ================= INITIAL ROUTE =================
  final String initialRoute = supabase.currentSession == null
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

    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Iki Mochi',

        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: themeService.isDark.value ? ThemeMode.dark : ThemeMode.light,

        initialRoute: initialRoute,
        getPages: AppPages.routes,
      ),
    );
  }
}
