class MochiModel {
  final String id;
  final String name;
  final int price;
  final String image;
  final String short;
  final bool isPopular;
  final bool isSpecial;

  MochiModel({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.short,
    required this.isPopular,
    required this.isSpecial,
  });

  factory MochiModel.fromMap(Map<String, dynamic> map) {
    return MochiModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      short: map['short'],
      isPopular: map['isPopular'] ?? false,
      isSpecial: map['isSpecial'] ?? false,
    );
  }
}
