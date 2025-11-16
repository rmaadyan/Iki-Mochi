import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/mochi_model.dart';
import 'mochi_service_contract.dart';

class SupabaseService implements MochiServiceContract {
  final supabase = Supabase.instance.client;

  @override
  Future<List<Mochi>> getAll() async {
    final response = await supabase
        .from('mochi')
        .select();
    return response.map((json) => Mochi.fromJson(json)).toList();
  }

  @override
  Future<void> add(Mochi mochi) async {
    await supabase.from('mochi').insert(mochi.toJson());
  }

  @override
  Future<void> update(int id, Mochi mochi) async {
    await supabase.from('mochi').update(mochi.toJson()).eq('id', id);
  }

  @override
  Future<void> delete(int id) async {
    await supabase.from('mochi').delete().eq('id', id);
  }

  Future<void> signIn(String email, String pass) async {
    await supabase.auth.signInWithPassword(email: email, password: pass);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
    @override
Future<List<Mochi>> fetchPopular() async {
  final response = await supabase
      .from('mochi')
      .select()
      .order('likes', ascending: false)
      .limit(10);

  return (response as List<dynamic>)
      .map((j) => Mochi.fromJson(j as Map<String, dynamic>))
      .toList();
}

@override
Future<List<Mochi>> fetchSpecials() async {
  final response = await supabase
      .from('mochi')
      .select()
      .eq('special', true);

  return (response as List<dynamic>)
      .map((j) => Mochi.fromJson(j as Map<String, dynamic>))
      .toList();
}
  }
  
  @override
  Future<List<Map<String, dynamic>>> fetchPopular() {
    // TODO: implement fetchPopular
    throw UnimplementedError();
  }
  
  @override
  Future<List<Map<String, dynamic>>> fetchSpecials() {
    // TODO: implement fetchSpecials
    throw UnimplementedError();
  }
}
