class OrderModel {
  final String id;
  final DateTime createdAt;
  final int totalPrice;
  final String address;
  final double? latitude;
  final double? longitude;
  final String paymentMethod;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.createdAt,
    required this.totalPrice,
    required this.address,
    required this.paymentMethod,
    required this.items,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'total_price': totalPrice,
      'delivery_address': address,
      'delivery_lat': latitude,
      'delivery_lng': longitude,
      'payment_method': paymentMethod,
      'items': items.map((e) => e.toMap()).toList(),
    };
  }
}

class OrderItemModel {
  final String name;
  final int price;
  final int qty;

  OrderItemModel({
    required this.name,
    required this.price,
    required this.qty,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'qty': qty,
    };
  }
}
