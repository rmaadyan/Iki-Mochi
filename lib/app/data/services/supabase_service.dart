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

  // ================= AUTH STATE =================
  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;

  /// 🔥 INI PENTING UNTUK RELEASE
  Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  bool get isLoggedIn => currentSession != null;

  // ================= AUTH ACTIONS =================
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final res = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (res.user == null) {
      throw Exception('Login gagal');
    }

    return res;
  }

  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? metadata,
  }) async {
    return await client.auth.signUp(
      email: email,
      password: password,
      data: metadata,
    );
  }

  Future<void> signOut() async {
    await client.auth.signOut();
  }

  // ================= DATABASE =================
  SupabaseQueryBuilder from(String table) => client.from(table);
  SupabaseStorageClient get storage => client.storage;

  // ================= ORDER =================
  Future<String> createOrder({
    required int totalPrice,
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
  }) async {
    final user = currentUser;
    if (user == null) {
      throw Exception('User belum login');
    }

    try {
      final order = await client
          .from('orders')
          .insert({
            'user_id': user.id,
            'total_price': totalPrice,
            'status': 'pending',
            'payment_method': paymentMethod,
          })
          .select()
          .single();

      final String orderId = order['id'];

      final orderItems = items.map((item) {
        return {
          'order_id': orderId,
          'product_id': item['id'],
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
