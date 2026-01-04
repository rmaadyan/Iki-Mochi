import 'package:get/get.dart';
import '../../../data/services/supabase_service.dart';

class AdminOrderController extends GetxController {
  final SupabaseService supabase = Get.find();

  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    fetchAllOrders();
    super.onInit();
  }

  // ================= GET ALL ORDERS =================
  Future<void> fetchAllOrders() async {
    try {
      isLoading.value = true;

      final res = await supabase.client
          .from('orders')
          .select('*, order_items(*)')
          .order('created_at', ascending: false);

      orders.assignAll(List<Map<String, dynamic>>.from(res));
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil data pesanan',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // ================= UPDATE STATUS =================
  Future<void> updateStatus(String orderId, String status) async {
    try {
      // 🔒 OPTIONAL SAFETY (CLIENT SIDE)
      final role = await supabase.getUserRole();
      if (role != 'admin') {
        Get.snackbar('Akses ditolak', 'Khusus admin');
        return;
      }

      final res = await supabase.client
          .from('orders')
          .update({'status': status})
          .eq('id', orderId)
          .select()
          .single();

      // 🔥 UPDATE LOCAL STATE
      final index = orders.indexWhere((o) => o['id'] == orderId);
      if (index != -1) {
        orders[index] = res;
        orders.refresh();
      }

      Get.snackbar(
        'Berhasil',
        'Status pesanan diperbarui',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal update status\n$e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
