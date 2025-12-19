import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/providers/auth_provider.dart';
import '../../../data/services/supabase_service.dart';
import '../../../core/values/app_strings.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  final AuthProvider _authProvider = Get.find();
  final SupabaseService _supabase = Get.find();

  // Observable variables
  final isLoading = false.obs;

  // ================= LIFECYCLE =================
  @override
  void onReady() {
    super.onReady();

    // 🔐 AUTH GUARD — CEK SESSION SAAT APP START / HOT RESTART
    if (_supabase.isLoggedIn) {
      Get.offAllNamed(Routes.MAIN);
    }
  }

  // ================= LOGIN =================
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _authProvider.login(email.trim(), password);

      Get.snackbar(
        'Success',
        AppStrings.loginSuccess,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // ⬅️ MASUK KE ROOT NAVBAR
      Get.offAllNamed(Routes.MAIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        '${AppStrings.loginFailed}: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= REGISTER =================
  Future<void> register(String email, String password) async {
    isLoading.value = true;
    try {
      await _authProvider.register(email.trim(), password);

      Get.snackbar(
        'Success',
        AppStrings.registerSuccess,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );

      // ⬅️ BALIK KE LOGIN (AMAN)
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Error',
        '${AppStrings.registerFailed}: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOGOUT =================
  Future<void> logout() async {
    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: const Text(AppStrings.logout),
        content: const Text(AppStrings.logoutConfirm),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(AppStrings.logout),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authProvider.logout();

      // ⬅️ HAPUS SEMUA STACK + BALIK LOGIN
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  // ================= NAVIGATION =================
  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  void goToLogin() {
    Get.offAllNamed(Routes.LOGIN);
  }

  // ================= VALIDATORS =================
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterEmail;
    }
    if (!value.contains('@')) {
      return AppStrings.pleaseEnterValidEmail;
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseEnterPassword;
    }
    if (value.length < 6) {
      return AppStrings.passwordMinLength;
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return AppStrings.pleaseConfirmPassword;
    }
    if (value != password) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }
}
