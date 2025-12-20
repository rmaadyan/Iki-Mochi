// lib/app/modules/home/controllers/home_controller.dart
import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:mochi/app/data/models/mochi_model.dart';
import 'package:mochi/app/data/models/mochi_service.dart';

class HomeController extends GetxController {
  final MochiService mochiService;

  HomeController({required this.mochiService});

  final popular = <MochiModel>[].obs;
  final specials = <SpecialMochiModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      isLoading.value = true;
      final p = await mochiService.fetchPopular();
      final s = await mochiService.fetchSpecials();
      popular.assignAll(p);
      specials.assignAll(s);
    } catch (e, st) {
      debugPrint('failed loadData: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }
}
