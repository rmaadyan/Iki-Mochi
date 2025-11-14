import 'package:get/get.dart';
import 'package:mochi/app/data/services/http_mochi_services.dart';
import 'package:mochi/app/data/services/dio_mochi_service.dart';

import '../controllers/mochi_controller.dart';

class MochiBinding extends Bindings {
  @override
  void dependencies() {
    // register services
    Get.lazyPut<HttpMochiService>(() => HttpMochiService(baseUrl: 'https://example.com/api'));
    Get.lazyPut<DioMochiService>(() => DioMochiService(baseUrl: 'https://example.com/api'));

    // controller depends on both services
    Get.lazyPut<MochiController>(() => MochiController(
      httpService: Get.find<HttpMochiService>(),
      dioService: Get.find<DioMochiService>(),
    ));
  }
}
