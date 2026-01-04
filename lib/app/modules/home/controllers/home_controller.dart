import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:mochi/app/data/services/mochi_service.dart';
import 'package:mochi/app/data/models/mochi_model.dart';

class HomeController extends GetxController {
  final MochiService mochiService;

  HomeController({required this.mochiService});

  // ================= STATE =================
  final RxList<MochiModel> popularMochis = <MochiModel>[].obs;
  final RxList<MochiModel> specialMochis = <MochiModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ================= LOAD DATA =================
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      final popular = await mochiService.fetchPopular();
      final special = await mochiService.fetchSpecial();

      popularMochis.assignAll(popular);
      specialMochis.assignAll(special);
    } catch (e, st) {
      debugPrint('HomeController loadData error: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }
}
