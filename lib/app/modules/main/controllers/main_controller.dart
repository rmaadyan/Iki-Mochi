import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainController extends GetxController {
  // index tab aktif
  final RxInt currentIndex = 0.obs;

  late final PageController pageController;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex.value);
  }

  // dipanggil saat tap bottom nav
  void changeTab(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  // dipanggil saat swipe
  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
