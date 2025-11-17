// lib/app/services/theme_toggle_service.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeToggleService extends GetxService {
  final _isDark = false.obs;

  bool get isDark => _isDark.value;

  Future<ThemeToggleService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool('isDarkTheme') ?? false;
    _isDark.value = saved;

    // apply theme saat startup
    Get.changeThemeMode(saved ? ThemeMode.dark : ThemeMode.light);

    return this;
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final newVal = !_isDark.value;
    _isDark.value = newVal;

    await prefs.setBool('isDarkTheme', newVal);

    Get.changeThemeMode(newVal ? ThemeMode.dark : ThemeMode.light);
  }
}
