// lib/app/modules/mochi/controllers/mochi_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

  // Which fetch method was last used
  final RxString lastFetchMethod = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Optionally auto-fetch default dataset
    fetchWithHttp();
  }

  // -------------------------
  // Fetching methods
  // -------------------------

  /// Safe conversion helper: tries to convert a dynamic response into List<Map<String,dynamic>>
  List<Map<String, dynamic>> _toListOfMap(dynamic resp) {
    if (resp == null) return [];
    try {
      // If resp is Iterable of maps, normalize each entry to Map<String,dynamic>
      if (resp is Iterable) {
        return resp.map((e) {
          if (e is Map) {
            // ensure keys/values are of proper types
            return Map<String, dynamic>.from(e as Map);
          }
          return <String, dynamic>{};
        }).where((m) => m.isNotEmpty).toList();
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  Future<void> fetchWithHttp() async {
    loading.value = true;
    error.value = '';
    lastFetchMethod.value = 'http';
    try {
      final respPopular = await httpService.fetchPopular();
      final respSpecials = await httpService.fetchSpecials();

      // Convert safely; if conversion fails we get empty lists rather than runtime errors
      final List<Map<String, dynamic>> p = _toListOfMap(respPopular);
      final List<Map<String, dynamic>> s = _toListOfMap(respSpecials);

      popular.assignAll(p);
      specials.assignAll(s);
    } catch (e, st) {
      error.value = 'Fetch (http) failed: ${e.toString()}';
      debugPrint('fetchWithHttp error: $e\n$st');
      popular.clear();
      specials.clear();
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetchWithDio() async {
    loading.value = true;
    error.value = '';
    lastFetchMethod.value = 'dio';
    try {
      final respPopular = await dioService.fetchPopular();
      final respSpecials = await dioService.fetchSpecials();

      final p = _toListOfMap(respPopular);
      final s = _toListOfMap(respSpecials);

      popular.assignAll(p);
      specials.assignAll(s);
    } catch (e, st) {
      error.value = 'Fetch (dio) failed: ${e.toString()}';
      debugPrint('fetchWithDio error: $e\n$st');
      popular.clear();
      specials.clear();
    } finally {
      loading.value = false;
    }
  }

  Future<void> fetch({String method = 'http'}) async {
    if (method.toLowerCase() == 'dio') {
      return fetchWithDio();
    }
    return fetchWithHttp();
  }

  // -------------------------
  // Cart helpers
  // -------------------------

  void addToCartFromMap(Map<String, dynamic> mochi, {int amount = 1}) {
    final id = (mochi['id'] as String?) ??
        (mochi['name'] as String?) ??
        DateTime.now().millisecondsSinceEpoch.toString();
    final name = (mochi['name'] ?? mochi['title'])?.toString() ?? 'Mochi';
    final price = (mochi['price']?.toString() ?? '0');
    final emoji = (mochi['emoji']?.toString() ?? '🍡');

    // use update to modify or insert atomically
    cart.update(
      id,
      (existing) {
        existing.qty += amount;
        return existing;
      },
      ifAbsent: () => CartItem(id: id, name: name, price: price, emoji: emoji, qty: amount),
    );
    // notify observers
    cart.refresh();

    Get.snackbar('Berhasil', '$name ditambahkan ke keranjang',
        snackPosition: SnackPosition.BOTTOM, duration: const Duration(milliseconds: 900));
  }

  void removeFromCart(String id) {
    if (cart.containsKey(id)) {
      cart.remove(id);
      cart.refresh();
    }
  }

  void changeQty(String id, int qty) {
    if (!cart.containsKey(id)) return;
    final newQty = qty < 1 ? 1 : qty;
    cart.update(id, (c) {
      c.qty = newQty;
      return c;
    });
    cart.refresh();
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

  String _thousandSeparator(String numeric) {
    // Insert dot as thousand separator: "1234567" -> "1.234.567"
    final s = numeric;
    final reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    return s.replaceAllMapped(reg, (m) => '.');
  }

  String cartTotalPriceFormatted() {
    final t = cartTotalPriceAsInt();
    if (t == 0) return '0';
    return _thousandSeparator(t.toString());
  }

  // -------------------------
  // Utility / debug
  // -------------------------
  void clearCart() {
    cart.clear();
  }

  /// Optional demo fallback data
  void populateDemoData() {
    popular.assignAll([
      {
        "id": "strawberry",
        "name": "Strawberry",
        "price": "4.500",
        "emoji": "🍓",
        "bg": "#FFF0F5",
        "short": "Fresh strawberry wrapped in sweet mochi."
      },
      {
        "id": "matcha",
        "name": "Matcha",
        "price": "5.000",
        "emoji": "🍵",
        "bg": "#F0FFF0",
        "short": "Earthy matcha cream inside soft mochi."
      },
    ]);

    specials.assignAll([
      {
        "id": "strawberry_daifuku",
        "title": "Strawberry Daifuku",
        "price": "5.000",
        "emoji": "🍡",
        "tags": ["Sweet", "Fruity", "Soft"],
        "description": "Delicious.",
        "reviews": []
      },
    ]);
  }
}
