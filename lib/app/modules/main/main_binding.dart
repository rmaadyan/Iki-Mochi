// lib/app/modules/main/bindings/main_binding.dart
import 'package:get/get.dart';
import 'package:mochi/app/modules/home/controllers/home_controller.dart';
import 'package:mochi/app/data/services/mochi_service.dart';
import '../cart/controllers/cart_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    // Register MochiService (langsung, karena ini service konkret)
    Get.lazyPut<MochiService>(() => MochiService());

    // Register HomeController dengan dependency injection
    Get.lazyPut<HomeController>(
      () => HomeController(mochiService: Get.find<MochiService>()),
    );

    Get.put<CartController>(CartController(), permanent: true);
  }
}
