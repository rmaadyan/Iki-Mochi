import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient client;

  // ================= INIT =================
  Future<SupabaseService> init() async {
    try {
      if (kDebugMode) {
        debugPrint('Loading .env file...');
      }

      await dotenv.load(fileName: ".env");

      final supabaseUrl = dotenv.env['SUPABASE_URL'];
      final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];

      if (supabaseUrl == null || supabaseAnonKey == null) {
        throw Exception(
          'Supabase URL or Anon Key is not set in the environment variables.',
        );
      }

      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: supabaseAnonKey,
      );

      client = Supabase.instance.client;

      if (kDebugMode) {
        debugPrint('Supabase initialized with URL: $supabaseUrl');
      }

      return this;
    } catch (e) {
      debugPrint('error initializing supabase: $e');
      rethrow;
    }
  }

  // ================= AUTH HELPERS =================
  User? get currentUser => client.auth.currentUser;
  Session? get currentSession => client.auth.currentSession;
  Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;

  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
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

  bool get isLoggedIn => currentUser != null;

  // ================= DATABASE HELPERS =================
  SupabaseQueryBuilder from(String table) => client.from(table);
  SupabaseStorageClient get storage => client.storage;

  // ================= ORDER HELPERS =================

  Future<String> createOrder({
    required int totalPrice,
    required List<Map<String, dynamic>> items,
  }) async {
    final userId = currentUser!.id;

    final orderRes = await client
        .from('orders')
        .insert({
          'user_id': userId,
          'total_price': totalPrice,
          'status': 'completed',
        })
        .select()
        .single();

    final orderId = orderRes['id'];

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
  }

  Future<List<Map<String, dynamic>>> getOrderHistory() async {
    final userId = currentUser!.id;

    final res = await client
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }
}