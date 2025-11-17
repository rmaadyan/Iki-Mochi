// import 'package:get/get.dart';
// import '../controllers/auth_controller.dart';

// class AuthBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<AuthController>(
//       () => AuthController(),
//     );
//   }
// }

import 'package:get/get.dart';
import '../../../data/providers/auth_provider.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    debugPrint('Registering AuthProvider');
    Get.put<AuthProvider>(AuthProvider());
    debugPrint('Registering AuthController');
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
