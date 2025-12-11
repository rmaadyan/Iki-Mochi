// lib/app/services/local_storage_service.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../models/todo_model.dart';
import '../models/notification_log_model.dart';

class LocalStorageService extends GetxService {
  // box names
  static const String _settingsBox = 'settings_box';
  static const String _cartBox = 'cart_box';
  static const String _cacheBox = 'cache_box';
  static const String _sessionBox = 'session_box';
  static const String todoBoxName = 'todo_box';
  static const String notificationBoxName = 'notification_log_box';

  late Box<String> _settings;
  late Box<String> _cart; // store map id -> jsonString
  late Box<String> _cache; // store key -> jsonString
  late Box<String> _session; // store 'user' -> jsonString
  late final Box<TodoModel> _todoBox;
  late final Box<NotificationLogModel> _notificationBox;

  Box<TodoModel> get todoBox => _todoBox;
  Box<NotificationLogModel> get notificationBox => _notificationBox;

  /// Initialize Hive and open boxes. Call this via Get.putAsync in main().
  Future<LocalStorageService> init() async {
    // Hive init
    if (kIsWeb) {
      await Hive.initFlutter();
    } else {
      final dir = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(dir.path);
    }

    // Open boxes storing JSON strings (no custom adapters needed)
    _settings = await Hive.openBox<String>(_settingsBox);
    _cart = await Hive.openBox<String>(_cartBox);
    _cache = await Hive.openBox<String>(_cacheBox);
    _session = await Hive.openBox<String>(_sessionBox);

    debugPrint('LocalStorageService initialized (Hive boxes opened).');
    return this;
  }

  /// Close all boxes (optional)
  Future<void> close() async {
    await _settings.close();
    await _cart.close();
    await _cache.close();
    await _session.close();
  }

  // -------------------------
  // Settings helpers (simple key/value)
  // -------------------------
  Future<void> saveBool(String key, bool value) async => _settings.put(key, jsonEncode(value));
  bool getBool(String key, {bool defaultValue = false}) {
    final v = _settings.get(key);
    return v == null ? defaultValue : jsonDecode(v) as bool;
  }

  Future<void> saveString(String key, String value) async => _settings.put(key, jsonEncode(value));
  String? getString(String key) {
    final v = _settings.get(key);
    return v == null ? null : (jsonDecode(v) as String);
  }

  // convenience for theme (example)
  Future<void> saveIsDarkTheme(bool isDark) => saveBool('isDarkTheme', isDark);
  bool getIsDarkTheme() => getBool('isDarkTheme', defaultValue: false);

  // -------------------------
  // Session / User helpers
  // store user/session as Map -> JSON
  // -------------------------
  Future<void> saveSession(Map<String, dynamic> session) async {
    await _session.put('user_session', jsonEncode(session));
  }

  Map<String, dynamic>? getSession() {
    final s = _session.get('user_session');
    if (s == null) return null;
    return Map<String, dynamic>.from(jsonDecode(s) as Map);
  }

  Future<void> clearSession() async {
    await _session.delete('user_session');
  }

  // -------------------------
  // Cache helpers
  // key can be endpoint name or custom key
  // value must be json-serializable (Map/List/primitive)
  // -------------------------
  Future<void> saveCache(String key, dynamic value) async {
    await _cache.put(key, jsonEncode(value));
  }

  dynamic getCache(String key) {
    final s = _cache.get(key);
    if (s == null) return null;
    return jsonDecode(s);
  }

  Future<void> removeCache(String key) async {
    await _cache.delete(key);
  }

  // -------------------------
  // Cart helpers
  // Store cart as map of id -> itemJson
  // Item is any JSON-serializable map containing id,name,price,qty,emoji,...
  // -------------------------
  Future<void> saveCart(Map<String, dynamic> cartMap) async {
    // cartMap: {'id1': {...}, 'id2': {...}}
    await _cart.put('cart_items', jsonEncode(cartMap));
  }

  /// returns Map<String, dynamic> where value is the item map
  Map<String, dynamic> getCart() {
    final s = _cart.get('cart_items');
    if (s == null) return {};
    return Map<String, dynamic>.from(jsonDecode(s) as Map);
  }

  Future<void> clearCart() async {
    await _cart.delete('cart_items');
  }

  Future<void> addToCart(String id, Map<String, dynamic> item, {int addQty = 1}) async {
    final cart = getCart();
    if (cart.containsKey(id)) {
      final existing = Map<String, dynamic>.from(cart[id] as Map);
      final existingQty = (existing['qty'] ?? 1) as int;
      existing['qty'] = existingQty + addQty;
      cart[id] = existing;
    } else {
      final copy = Map<String, dynamic>.from(item);
      copy['qty'] = (copy['qty'] ?? 0) + addQty;
      cart[id] = copy;
    }
    await saveCart(cart);
  }

  Future<void> removeFromCart(String id) async {
    final cart = getCart();
    if (!cart.containsKey(id)) return;
    cart.remove(id);
    await saveCart(cart);
  }

  Future<void> updateCartItemQty(String id, int qty) async {
    final cart = getCart();
    if (!cart.containsKey(id)) return;
    final item = Map<String, dynamic>.from(cart[id] as Map);
    item['qty'] = qty;
    if (qty <= 0) cart.remove(id);
    else cart[id] = item;
    await saveCart(cart);
  }

  int cartTotalQty() {
    final cart = getCart();
    int total = 0;
    cart.forEach((_, v) {
      final item = Map<String, dynamic>.from(v as Map);
      total += (item['qty'] ?? 0) as int;
    });
    return total;
  }

  int cartTotalPrice() {
    final cart = getCart();
    int total = 0;
    cart.forEach((_, v) {
      final item = Map<String, dynamic>.from(v as Map);
      final price = (item['price'] ?? 0);
      final qty = (item['qty'] ?? 0) as int;
      final p = (price is int) ? price : int.tryParse(price.toString().replaceAll('.', '')) ?? 0;
      total += p * qty;
    });
    return total;
  }
}

