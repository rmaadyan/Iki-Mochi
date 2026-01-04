import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../cart/controllers/cart_controller.dart';
import '../../order/controllers/order_controller.dart';
import '../../../data/services/supabase_service.dart';
import '../../../UI/widgets/order_success_dialog.dart';

class CheckoutController extends GetxController {
  final CartController cart = Get.find<CartController>();
  final SupabaseService supabase = Get.find<SupabaseService>();
  final OrderController orderController = Get.find<OrderController>();

  // ================= STATE =================
  final RxString address = ''.obs;
  final RxString paymentMethod = ''.obs;
  final RxDouble latitude = 0.0.obs;
  final RxDouble longitude = 0.0.obs;

  // ================= MANUAL ADDRESS =================
  void openManualAddressDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Alamat Pengiriman'),
        content: TextField(
          autofocus: true,
          maxLines: 3,
          onChanged: (v) => address.value = v,
          decoration: const InputDecoration(
            hintText: 'Masukkan alamat lengkap',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [TextButton(onPressed: Get.back, child: const Text('Simpan'))],
      ),
    );
  }

  // ================= GPS =================
  Future<void> pickFromGPS() async {
    final enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
      Get.snackbar('GPS Mati', 'Aktifkan GPS terlebih dahulu');
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.snackbar('Izin ditolak', 'GPS tidak diizinkan');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.snackbar('Izin ditolak', 'Aktifkan izin lokasi di pengaturan');
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude.value = position.latitude;
    longitude.value = position.longitude;

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final place = placemarks.first;
    address.value = '${place.street}, ${place.subLocality}, ${place.locality}';

    FocusManager.instance.primaryFocus?.unfocus();

    Get.snackbar(
      'Lokasi berhasil',
      'Alamat diambil dari GPS',
      duration: const Duration(seconds: 1),
    );
  }

  void setLocation({
    required double lat,
    required double lng,
    required String addr,
  }) {
    latitude.value = lat;
    longitude.value = lng;
    address.value = addr;
  }

  // ================= PAYMENT =================
  void setPayment(String? value) {
    if (value == null) return;
    paymentMethod.value = value;
  }

  // ================= SUBMIT =================

  Future<void> submitOrder() async {
    debugPrint('🔥 SUBMIT ORDER DIPANGGIL');

    if (cart.items.isEmpty) {
      Get.snackbar('Gagal', 'Keranjang kosong');
      for (final item in cart.items.values) {
        debugPrint('🧪 CART ITEM -> id=${item.id}, name=${item.name}');
      }

      return;
    }

    if (address.isEmpty) {
      Get.snackbar('Gagal', 'Alamat belum diisi');
      return;
    }

    if (paymentMethod.isEmpty) {
      Get.snackbar('Gagal', 'Pilih metode pembayaran');
      return;
    }

    final items = cart.items.values.map((item) {
      return {
        'id': item.id, // 🔥 WAJIB ADA
        'name': item.name,
        'price': item.price,
        'qty': item.qty,
        'emoji': item.image,
      };
    }).toList();

    debugPrint('🧪 CART ITEMS YANG AKAN DIKIRIM:');
    for (final item in cart.items.values) {
      debugPrint(
        '🧪 id=${item.id}, name=${item.name}, price=${item.price}, qty=${item.qty}',
      );
    }

    await supabase.createOrder(
      totalPrice: cart.totalPrice,
      items: items,
      paymentMethod: paymentMethod.value,
      address: address.value,
      latitude: latitude.value == 0 ? null : latitude.value,
      longitude: longitude.value == 0 ? null : longitude.value,
    );

    await orderController.fetchOrders();
    cart.clear();

    address.value = '';
    paymentMethod.value = '';
    latitude.value = 0;
    longitude.value = 0;

    Get.dialog(const OrderSuccessDialog(), barrierDismissible: false);
  }
}
