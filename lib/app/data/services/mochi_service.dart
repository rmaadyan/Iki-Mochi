import 'dart:async';
import '../models/mochi_model.dart';
import '../models/dummy_data.dart';

class MochiService {
  final Duration delay;

  MochiService({this.delay = const Duration(milliseconds: 120)});

  Future<List<MochiModel>> fetchAll() async {
    await Future.delayed(delay);
    return mochiDummyData.map(MochiModel.fromMap).toList();
  }

  Future<List<MochiModel>> fetchPopular() async {
    await Future.delayed(delay);
    return mochiDummyData
        .where((m) => m['isPopular'] == true)
        .map(MochiModel.fromMap)
        .toList();
  }

  Future<List<MochiModel>> fetchSpecial() async {
    await Future.delayed(delay);
    return mochiDummyData
        .where((m) => m['isSpecial'] == true)
        .map(MochiModel.fromMap)
        .toList();
  }

  Future<MochiModel?> getById(String id) async {
    final all = await fetchAll();
    try {
      return all.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}
