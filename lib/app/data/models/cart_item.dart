class CartItem {
  final String id;
  final String name;
  final int price;
  final String image;
  int qty;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    this.qty = 1,
  });
}
