import 'package:hive/hive.dart';
import '../models/mochi_model.dart';
import 'mochi_service_contract.dart';

class HiveService implements MochiServiceContract {
  late Box<Mochi> _box;

  @override
  Future<void> init() async {
    _box = await Hive.openBox<Mochi>('mochiBox');
  }

  @override
  Future<List<Mochi>> getAll() async {
    return _box.values.toList();
  }

  @override
  Future<void> add(Mochi mochi) async {
    await _box.add(mochi);
  }

  @override
  Future<void> update(int index, Mochi mochi) async {
    await _box.put(index, mochi);
  }

  @override
  Future<void> delete(int index) async {
    await _box.delete(index);

    @override
    Future<List<Mochi>> fetchPopular() async {
      // Hive tidak punya konsep popular, fallback ke all
      return getAll();
    }

    @override
    Future<List<Mochi>> fetchSpecials() async {
      // Belum ada implementasi khusus, sementara return all
      return getAll();
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
