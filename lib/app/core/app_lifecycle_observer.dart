// app/core/app_lifecycle_observer.dart
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../data/services/supabase_service.dart';

class AppLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.detached) {
      // app BENAR-BENAR ditutup
      final supabase = Get.find<SupabaseService>();
      await supabase.signOut();
    }
  }
}
