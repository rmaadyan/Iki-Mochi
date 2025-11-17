// lib/app/data/models/mochi_model.dart
class MochiModel {
  final String id;
  final String name;
  final String price;
  final String emoji;
  final String short;
  final int? stock;

  MochiModel({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    required this.short,
    this.stock,
  });

  factory MochiModel.fromMap(Map<String, dynamic> m) {
    return MochiModel(
      id: (m['id'] ?? m['Id'] ?? '').toString(),
      name: (m['name'] ?? m['title'] ?? '').toString(),
      price: (m['price'] ?? '').toString(),
      emoji: (m['emoji'] ?? '🍡').toString(),
      short: (m['short'] ?? m['description'] ?? '').toString(),
      stock: m['stock'] != null ? int.tryParse(m['stock'].toString()) : null,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'emoji': emoji,
        'short': short,
        'stock': stock,
      };
}

class SpecialMochiModel extends MochiModel {
  final List<Map<String, dynamic>> reviews;
  final List<String> tags;

  SpecialMochiModel({
    required String id,
    required String name,
    required String price,
    required String emoji,
    required String short,
    this.reviews = const [],
    this.tags = const [],
    int? stock,
  }) : super(id: id, name: name, price: price, emoji: emoji, short: short, stock: stock);

  factory SpecialMochiModel.fromMap(Map<String, dynamic> m) {
    final base = MochiModel.fromMap(m);
    return SpecialMochiModel(
      id: base.id,
      name: base.name,
      price: base.price,
      emoji: base.emoji,
      short: base.short,
      tags: List<String>.from(m['tags'] ?? []),
      reviews: List<Map<String, dynamic>>.from(m['reviews'] ?? []),
      stock: base.stock,
    );
  }
}
