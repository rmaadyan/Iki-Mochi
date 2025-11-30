// app/data/services/theme_toggle_service.dart
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeToggleService extends GetxService {
  final RxBool _isDark = false.obs;
  late SharedPreferences _prefs;

  bool get isDark => _isDark.value;      // buat dipakai di main.dart
  RxBool get isDarkObs => _isDark;       // buat Obx di widget

  Future<ThemeToggleService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDark.value = _prefs.getBool('isDarkTheme') ?? false;
    return this;
  }

  Future<void> toggleTheme() async {
    _isDark.value = !_isDark.value;
    await _prefs.setBool('isDarkTheme', _isDark.value);
  }
}
