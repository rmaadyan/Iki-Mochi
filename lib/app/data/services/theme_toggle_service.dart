import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeToggleService extends GetxService {
  final isDark = false.obs;

  void toggleTheme() {
    isDark.value = !isDark.value;
    Get.changeTheme(isDark.value ? darkTheme : lightTheme);
  }
}

// ===== THEME DEFINITIONS =====

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: const Color(0xFFFFF7FC),
  primaryColor: const Color(0xFF8B4A58),
  fontFamily: 'Poppins',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Color(0xFF8B4A58)),
  ),
);

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF1E1E1E),
  primaryColor: Colors.pinkAccent,
  fontFamily: 'Poppins',
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.pinkAccent),
  ),
);
