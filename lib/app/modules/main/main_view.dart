import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/supabase_service.dart';
import '../../routes/app_pages.dart';

import '../home/views/home_view.dart';
import '../order/views/order_list_view.dart';
import '../order/controllers/order_controller.dart';
import '../profile/views/profile_view.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int _currentIndex = 0;

  late final SupabaseService _supabase;

  final List<Widget> _pages = const [
    HomeView(),
    OrderListView(),
    ProfileView(),
  ];

  @override
  void initState() {
    super.initState();

    // ✅ REGISTER CONTROLLER UNTUK TAB PESANAN
    Get.put<OrderController>(OrderController(), permanent: true);

    // ✅ SUPABASE SERVICE
    _supabase = Get.find<SupabaseService>();

    // 🔐 AUTH GUARD
    if (!_supabase.isLoggedIn) {
      Future.microtask(() {
        Get.offAllNamed(Routes.LOGIN);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_supabase.isLoggedIn) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF85A7),
        unselectedItemColor:
            isDark ? Colors.grey.shade400 : Colors.grey,
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
      ),
    );
  }
}
