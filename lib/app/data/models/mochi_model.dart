class Mochi {
  final String id;
  final String name;
  final String price;
  final String emoji;
  final String short;
  final String description;
  final List<String> tags;

  Mochi({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    required this.short,
    required this.description,
    this.tags = const [],
  });

  factory Mochi.fromJson(Map<String, dynamic> j) {
    return Mochi(
      id: j['id']?.toString() ?? j['name'],
      name: j['name'] ?? '',
      price: j['price']?.toString() ?? '',
      emoji: j['emoji'] ?? '🍡',
      short: j['short'] ?? '',
      description: j['description'] ?? '',
      tags: (j['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}
