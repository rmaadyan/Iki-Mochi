import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/supabase_service.dart';
import '../../../routes/app_pages.dart';

import '../../home/views/home_view.dart';
import '../../order/views/order_list_view.dart';
import '../../order/controllers/order_controller.dart';
import '../../profile/views/profile_view.dart';

// ⬇️ TAMBAHAN
import '../controllers/main_controller.dart';

class MainView extends GetView<MainController> {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final supabase = Get.find<SupabaseService>();

    // 🔐 AUTH GUARD (TETAP)
    if (!supabase.isLoggedIn) {
      Future.microtask(() {
        Get.offAllNamed(Routes.LOGIN);
      });
      return const SizedBox.shrink();
    }

    // ✅ ORDER CONTROLLER (TETAP)
    if (!Get.isRegistered<OrderController>()) {
      Get.put<OrderController>(OrderController(), permanent: true);
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // 🔥 SWIPE AREA
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: const [HomeView(), OrderListView(), ProfileView()],
      ),

      // 🔥 BOTTOM NAV SYNC
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFFFF85A7),
          unselectedItemColor: isDark ? Colors.grey.shade400 : Colors.grey,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Pesanan',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      }),
    );
  }
}
