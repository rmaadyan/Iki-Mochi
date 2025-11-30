import 'package:get/get.dart';
import '../../location/controllers/gps_location_contoller.dart';
import '../../../data/services/location_service.dart';

/// Binding untuk GPS Location Module
class GpsLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<GpsLocationController>(
      () => GpsLocationController(),
      fenix: true,
    );
  }
}

