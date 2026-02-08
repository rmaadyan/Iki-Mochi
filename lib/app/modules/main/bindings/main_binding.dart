// lib/app/modules/main/bindings/main_binding.dart
import 'package:get/get.dart';
import 'package:mochi/app/modules/home/controllers/home_controller.dart';
import 'package:mochi/app/data/services/mochi_service.dart';
import '../../cart/controllers/cart_controller.dart';

// ⬇️ TAMBAHKAN INI
import '../controllers/main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ SUDAH BENAR — JANGAN DIHAPUS
    Get.lazyPut<MochiService>(() => MochiService());

    Get.lazyPut<HomeController>(
      () => HomeController(mochiService: Get.find<MochiService>()),
    );

    Get.put<CartController>(CartController(), permanent: true);

    // ➕ TAMBAHAN (AMAN)
    Get.put<MainController>(MainController(), permanent: true);
  }
}
