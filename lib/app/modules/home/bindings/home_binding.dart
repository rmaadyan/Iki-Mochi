import 'package:get/get.dart';
import 'package:mochi/app/modules/home/controllers/home_controller.dart';
import 'package:mochi/app/data/services/mochi_service.dart';
import 'package:mochi/app/modules/cart/controllers/cart_controller.dart';
import 'package:mochi/app/modules/favorite/controllers/favorite_controller.dart'; 

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(FavoriteController(), permanent: true);

    // ================= SERVICE =================
    Get.lazyPut<MochiService>(
      () => MochiService(),
      fenix: true,
    );

    // ================= CART CONTROLLER (INI YANG KURANG) =================
    Get.lazyPut<CartController>(
      () => CartController(),
      fenix: true,
    );

    // ================= HOME CONTROLLER =================
    Get.lazyPut<HomeController>(
      () => HomeController(
        mochiService: Get.find<MochiService>(),
      ),
      fenix: true,
    );
  }
}
