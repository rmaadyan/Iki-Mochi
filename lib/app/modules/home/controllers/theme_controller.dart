import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final RxBool isDark = false.obs;
  final SharedPreferences prefs;

  ThemeController(this.prefs) {
    isDark.value = prefs.getBool('isDarkTheme') ?? false;
  }

  Future<void> toggleTheme() async {
    isDark.value = !isDark.value;
    await prefs.setBool('isDarkTheme', isDark.value);
  }
}
