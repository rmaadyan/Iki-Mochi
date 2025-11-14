// lib/app/modules/mochi/controllers/mochi_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

// Pastikan path ini sesuai projectmu. Kalau pakai package: import,
// ganti ke: import 'package:your_package_name/app/data/services/http_mochi_service.dart';
import 'package:mochi/app/data/services/http_mochi_services.dart';
import 'package:mochi/app/data/services/dio_mochi_service.dart';


/// Simple Cart item class for local use
class CartItem {
  final String id;
  final String name;
  final String price; // keep as string like "4.500"
  final String emoji;
  int qty;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    this.qty = 1,
  });
}

/// MochiController - Getx controller managing lists, fetching via HTTP/Dio and cart
class MochiController extends GetxController {
  // Services injected via constructor (use Get.put / Get.lazyPut in binding)
  final HttpMochiService httpService;
  final DioMochiService dioService;

  MochiController({required this.httpService, required this.dioService});

  // Observables
  final RxList<Map<String, dynamic>> popular = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> specials = <Map<String, dynamic>>[].obs;

  final RxBool loading = false.obs;
  final RxString error = ''.obs;

  // Cart stored locally (keyed by id)
  final RxMap<String, CartItem> cart = <String, CartItem>{}.obs;

  // Which fetch method was last used (for experimentation)
  final RxString lastFetchMethod = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // optionally auto fetch default dataset using http
    fetchWithHttp();
  }

  // -------------------------
  // Fetching methods
  // -------------------------

  /// Fetch using the Http service (for compare)
  Future<void> fetchWithHttp() async {
    loading.value = true;
    error.value = '';
    lastFetchMethod.value = 'http';
    try {
      // Expectation: httpService.fetchPopular() returns List<Map<String,dynamic>>
      final respPopular = await httpService.fetchPopular(); // adapt method name to your service
      final respSpecials = await httpService.fetchSpecials();

      // defensive checks
      if (respPopular is List) {
        popular.assignAll(List<Map<String, dynamic>>.from(respPopular));
      } else 

      if (respSpecials is List) {
        specials.assignAll(List<Map<String, dynamic>>.from(respSpecials));
      } else {
        specials.clear();
      }
    } catch (e, st) {
      error.value = 'Fetch (http) failed: ${e.toString()}';
      debugPrint('fetchWithHttp error: $e\n$st');
    } finally {
      loading.value = false;
    }
  }

  /// Fetch using the Dio service (for performance experiments)
  Future<void> fetchWithDio() async {
    loading.value = true;
    error.value = '';
    lastFetchMethod.value = 'dio';
    try {
      final respPopular = await dioService.fetchPopular();
      final respSpecials = await dioService.fetchSpecials();

      if (respPopular is List) {
        popular.assignAll(List<Map<String, dynamic>>.from(respPopular));
      } else {
        popular.clear();
      }

      if (respSpecials is List) {
        specials.assignAll(List<Map<String, dynamic>>.from(respSpecials));
      } else {
        specials.clear();
      }
    } catch (e, st) {
      error.value = 'Fetch (dio) failed: ${e.toString()}';
      debugPrint('fetchWithDio error: $e\n$st');
    } finally {
      loading.value = false;
    }
  }

  /// A convenience method to choose service by name
  Future<void> fetch({String method = 'http'}) async {
    if (method == 'dio') return fetchWithDio();
    return fetchWithHttp();
  }

  // -------------------------
  // Cart helpers
  // -------------------------

  void addToCartFromMap(Map<String, dynamic> mochi, {int amount = 1}) {
    final id = (mochi['id'] as String?) ?? (mochi['name'] as String? ?? DateTime.now().millisecondsSinceEpoch.toString());
    final name = (mochi['name'] ?? mochi['title'])?.toString() ?? 'Mochi';
    final price = (mochi['price']?.toString() ?? '0');
    final emoji = (mochi['emoji']?.toString() ?? '🍡');

    if (cart.containsKey(id)) {
      cart[id]!.qty += amount;
      cart.refresh();
    } else {
      cart[id] = CartItem(id: id, name: name, price: price, emoji: emoji, qty: amount);
      cart.refresh();
    }
    Get.snackbar('Berhasil', '$name ditambahkan ke keranjang', snackPosition: SnackPosition.BOTTOM, duration: const Duration(milliseconds: 900));
  }

  void removeFromCart(String id) {
    if (cart.containsKey(id)) {
      cart.remove(id);
      cart.refresh();
    }
  }

  void changeQty(String id, int qty) {
    if (cart.containsKey(id)) {
      cart[id]!.qty = qty < 1 ? 1 : qty;
      cart.refresh();
    }
  }

  int cartTotalQty() => cart.values.fold(0, (sum, it) => sum + it.qty);

  /// naive total price: expects price string like "4.500" or "4500"
  int cartTotalPriceAsInt() {
    int total = 0;
    for (final v in cart.values) {
      final cleaned = v.price.replaceAll('.', '').replaceAll(',', '');
      final p = int.tryParse(cleaned) ?? 0;
      total += p * v.qty;
    }
    return total;
  }

  String cartTotalPriceFormatted() {
    final t = cartTotalPriceAsInt();
    // simple formatting: insert dot as thousand separator for indonesia-like display
    final s = t.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final pos = s.length - i;
      buffer.write(s[i]);
      if (pos > 1 && pos % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  // -------------------------
  // Utility / debug
  // -------------------------
  void clearCart() {
    cart.clear();
  }

  /// If you want to populate demo data quickly (fallback)
  void populateDemoData() {
    popular.assignAll([
      {"id": "strawberry", "name": "Strawberry", "price": "4.500", "emoji": "🍓", "bg": "#FFF0F5", "short": "Fresh strawberry wrapped in sweet mochi."},
      {"id": "matcha", "name": "Matcha", "price": "5.000", "emoji": "🍵", "bg": "#F0FFF0", "short": "Earthy matcha cream inside soft mochi."},
    ]);

    specials.assignAll([
      {"id": "strawberry_daifuku", "title": "Strawberry Daifuku", "price": "5.000", "emoji": "🍡", "tags": ["Sweet", "Fruity", "Soft"], "description": "Delicious.", "reviews": []},
    ]);
  }
}
