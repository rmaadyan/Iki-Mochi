// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/data/services/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Get.putAsync(() => SupabaseService().init());
  runApp(const MochiApp());
}

class MochiApp extends StatelessWidget {
  const MochiApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mochi Restaurant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF85A7)),
        scaffoldBackgroundColor: const Color(0xFFFFF7FC),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes

    );
  }
}
