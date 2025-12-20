import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/login_view.dart';
import '../modules/auth/views/register_view.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';

import '../modules/location/bindings/location_binding.dart';
import '../modules/location/views/location_view.dart';
import '../modules/location/bindings/network_location_binding.dart';
import '../modules/location/views/network_location_view.dart';
import '../modules/location/bindings/gps_location_binding.dart';
import '../modules/location/views/gps_location_view.dart';

import '../modules/main/main_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  /// ⬅️ PENTING: ROOT APP SEKARANG MAIN
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    // ===== AUTH =====
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),

    // ===== MAIN (BOTTOM NAV ROOT) =====
    GetPage(name: Routes.MAIN, page: () => const MainView()),

    // ===== HOME (CHILD PAGE) =====
    GetPage(
      name: Routes.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    // ===== LOCATION =====
    GetPage(
      name: Routes.LOCATION,
      page: () => const LocationView(),
      binding: LocationBinding(),
    ),
    GetPage(
      name: Routes.NETWORK_LOCATION,
      page: () => const NetworkLocationView(),
      binding: NetworkLocationBinding(),
    ),
    GetPage(
      name: Routes.GPS_LOCATION,
      page: () => const GpsLocationView(),
      binding: GpsLocationBinding(),
    ),
  ];
}
