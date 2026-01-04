import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;

  // ================= INIT =================
  Future<SupabaseService> init() async {
    try {
      await dotenv.load(fileName: ".env");

      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception('Supabase env not configured');
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
        authOptions: const FlutterAuthClientOptions(autoRefreshToken: true),
      );

      client = Supabase.instance.client;

      if (kDebugMode) {
        debugPrint('✅ Supabase initialized');
      }

      return this;
    } catch (e, s) {
      debugPrint('❌ Supabase init error: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // ================= AUTH =================
  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;

  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  bool get isLoggedIn => currentSession != null;

  // ================= ORDER =================
  Future<String> createOrder({
    required int totalPrice,
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    required String address,
    double? latitude,
    double? longitude,
  }) async {
    // 🔥 DEBUG PALING AWAL
    debugPrint('🔥 createOrder() DIPANGGIL DARI SupabaseService');
    debugPrint('🔥 paymentMethod = $paymentMethod');
    debugPrint('🔥 address = $address');
    debugPrint('🔥 latitude = $latitude');
    debugPrint('🔥 longitude = $longitude');

    debugPrint('🧪 ITEMS MASUK KE SUPABASE:');
    for (final item in items) {
      debugPrint(item.toString());
    }

    final user = currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    try {
      // 1️⃣ SIMPAN ORDER
      final order = await client
          .from('orders')
          .insert({
            'user_id': user.id,
            'total_price': totalPrice,
            'status': 'pending',
            'payment_method': paymentMethod,
            'delivery_address': address,
            'delivery_lat': latitude,
            'delivery_lng': longitude,
          })
          .select()
          .single();

      final String orderId = order['id'];

      // 2️⃣ SIMPAN ITEM PESANAN (FIX FINAL)
      final orderItems = items.map((item) {
        if (item['id'] == null) {
          throw Exception('product_id NULL ❌ — cek CartItem.id');
        }

        return {
          'order_id': orderId,
          'product_id': item['id'], // 🔥 INI YANG HILANG SELAMA INI
          'product_name': item['name'],
          'price': item['price'],
          'qty': item['qty'],
          'emoji': item['emoji'],
        };
      }).toList();

      await client.from('order_items').insert(orderItems);

      return orderId;
    } catch (e, s) {
      debugPrint('❌ createOrder error: $e');
      debugPrintStack(stackTrace: s);
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    final user = currentUser;
    if (user == null) return [];

    final res = await client
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }
}
