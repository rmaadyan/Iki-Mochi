// lib/app/data/services/mochi_service.dart
import 'dart:async';
import 'package:mochi/app/data/models/mochi_model.dart';

abstract class MochiService {
  Future<List<MochiModel>> fetchPopular();
  Future<List<SpecialMochiModel>> fetchSpecials();
  Future<MochiModel?> getById(String id);
}

class DummyMochiService implements MochiService {
  final Duration simulatedDelay;
  DummyMochiService({this.simulatedDelay = const Duration(milliseconds: 120)});

  final List<Map<String, dynamic>> _popular = [
    {"id":"strawberry","name":"Strawberry","price":"4.500","emoji":"🍓","short":"Fresh strawberry wrapped in sweet mochi."},
    {"id":"matcha","name":"Matcha","price":"5.000","emoji":"🍵","short":"Earthy matcha cream inside soft mochi."},
    {"id":"choco","name":"Chocolate","price":"5.000","emoji":"🍫","short":"Rich chocolate center — pure comfort."},
    {"id":"mango","name":"Mango","price":"5.500","emoji":"🥭","short":"Tropical mango filling — juicy and bright."},
  ];

  final List<Map<String, dynamic>> _specials = [
    {
      "id":"strawberry_daifuku",
      "title":"Strawberry Daifuku",
      "price":"5.000",
      "emoji":"🍡",
      "tags":["Sweet","Fruity","Soft"],
      "description":"Strawberry Daifuku features a fresh strawberry wrapped in red bean paste and soft mochi rice cake. Balanced and delightful.",
      "reviews":[{"rating":5,"text":"Enak, teksturnya lembut banget!","author":"Ayu"}]
    },
  ];

  @override
  Future<List<MochiModel>> fetchPopular() async {
    await Future.delayed(simulatedDelay);
    return _popular.map((m) => MochiModel.fromMap(m)).toList();
  }

  @override
  Future<List<SpecialMochiModel>> fetchSpecials() async {
    await Future.delayed(simulatedDelay);
    return _specials.map((m) => SpecialMochiModel.fromMap(m)).toList();
  }

  @override
  Future<MochiModel?> getById(String id) async {
    await Future.delayed(Duration(milliseconds: 60));
    final mp = _popular.firstWhere((e) => e['id'] == id, orElse: () => {});
    if (mp.isEmpty) return null;
    return MochiModel.fromMap(mp);
  }
}
