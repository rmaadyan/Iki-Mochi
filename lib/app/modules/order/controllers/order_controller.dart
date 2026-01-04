import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../data/services/supabase_service.dart';

enum OrderFilterStatus { all, pending, processing, completed }

class OrderController extends GetxController {
  final SupabaseService _supabase = Get.find();

  // ================= STATE =================
  final orders = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;
  final errorMessage = RxnString();

  final selectedStatus = OrderFilterStatus.all.obs;

  // ================= REALTIME =================
  RealtimeChannel? _orderChannel;

  // ================= FILTER =================
  List<Map<String, dynamic>> get filteredOrders {
    if (selectedStatus.value == OrderFilterStatus.all) {
      return orders;
    }

    final statusString = selectedStatus.value.name;

    return orders.where((order) {
      final status = order['status']?.toString().toLowerCase();
      return status == statusString;
    }).toList();
  }

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();

    // 1️⃣ ambil order pertama kali
    fetchOrders();

    // 2️⃣ realtime listener (admin update → user update)
    _listenOrderRealtime();

    // 3️⃣ refetch kalau user ganti filter (aman & murah)
    ever(selectedStatus, (_) => fetchOrders());
  }

  @override
  void onClose() {
    // cleanup realtime
    if (_orderChannel != null) {
      _supabase.client.removeChannel(_orderChannel!);
    }
    super.onClose();
  }

  // ================= FETCH =================
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

  // ================= REALTIME LISTENER =================
  void _listenOrderRealtime() {
    final user = _supabase.currentUser;
    if (user == null) return;

    _orderChannel = _supabase.client
        .channel('user-orders-${user.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'orders',
          callback: (payload) {
            // 🔥 admin update status → refetch user order
            fetchOrders();
          },
        )
        .subscribe();
  }

  // ================= HELPERS =================
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
