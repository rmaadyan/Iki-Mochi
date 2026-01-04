import 'package:get/get.dart';

class CartItem {
  final String id; // 🔥 WAJIB
  final String name;
  final int price;
  final String image;
  int qty;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.qty = 1,
  });
}

class CartController extends GetxController {
  /// key = mochi id
  final RxMap<String, CartItem> items = <String, CartItem>{}.obs;

  // ================= ADD (FROM MAP - SPECIAL / DETAIL SHEET) =================
  void addItemFromMap(Map<String, dynamic> mochi, {int amount = 1}) {
    final String id = (mochi['id'] ?? mochi['name']).toString();

    if (items.containsKey(id)) {
      items[id]!.qty += amount;
    } else {
      items[id] = CartItem(
        id: id, // ✅ PAKAI ID YANG SAMA
        name: mochi['name'],
        price: mochi['price'],
        image: mochi['image'],
      );
    }

    items.refresh();
  }

  // ================= INCREMENT =================
  void increment(String id) {
    if (!items.containsKey(id)) return;
    items[id]!.qty++;
    items.refresh();
  }

  // ================= DECREMENT =================
  void decrement(String id) {
    if (!items.containsKey(id)) return;

    if (items[id]!.qty > 1) {
      items[id]!.qty--;
    } else {
      items.remove(id);
    }
    items.refresh();
  }

  // ================= REMOVE =================
  void remove(String id) {
    items.remove(id);
    items.refresh();
  }

  void clear() {
    items.clear();
  }

  // ================= TOTAL =================
  int get totalQty => items.values.fold(0, (sum, item) => sum + item.qty);

  int get totalPrice =>
      items.values.fold(0, (sum, item) => sum + (item.price * item.qty));
}
