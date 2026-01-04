import 'package:get/get.dart';
import '../../../data/services/supabase_service.dart';

class OrderController extends GetxController {
  final SupabaseService _supabase = Get.find();

  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  @override
  void onInit() {
    fetchOrders();
    super.onInit();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await _supabase.getOrderHistory();
      orders.assignAll(result);
    } catch (e) {
      errorMessage.value = 'Gagal mengambil data pesanan';
      Get.snackbar('Error', errorMessage.value!);
    } finally {
      isLoading.value = false;
    }
  }

  Map<String, dynamic>? getOrderById(String id) {
    for (final o in orders) {
      if (o['id'] == id) return o;
    }
    return null;
  }

  bool hasDeliveryLocation(Map<String, dynamic> order) {
    return order['delivery_lat'] != null && order['delivery_lng'] != null;
  }
}
