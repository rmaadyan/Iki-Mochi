// lib/app/modules/home/bindings/home_binding.dart
import 'package:get/get.dart';
import 'package:mochi/app/modules/home/controllers/home_controller.dart';
import 'package:mochi/app/data/models/mochi_service.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // register service (Dummy untuk sekarang)
    Get.lazyPut<MochiService>(() => DummyMochiService());
    // register controller, inject service
    Get.lazyPut<HomeController>(() => HomeController(mochiService: Get.find<MochiService>()));
  }
}
