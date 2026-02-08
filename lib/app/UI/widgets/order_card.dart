import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String orderId;
  final String createdAt;
  final int totalPrice;
  final String paymentMethod;
  final String? address;
  final List items;

  const OrderCard({
    super.key,
    required this.orderId,
    required this.createdAt,
    required this.totalPrice,
    required this.paymentMethod,
    required this.items,
    this.address,
  });

  @override
  Widget build(BuildContext context) {
    final date = DateTime.tryParse(createdAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${orderId.substring(0, 6)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  date != null
                      ? '${date.day}/${date.month}/${date.year}'
                      : '',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Column(
              children: items.map<Widget>((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Text(item['emoji'] ?? '🍡'),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${item['product_name']} x${item['qty']}',
                        ),
                      ),
                      Text('Rp ${item['price']}'),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 24),
            if (address != null && address!.isNotEmpty)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(address!, style: const TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(paymentMethod.toUpperCase()),
                Text(
                  'Rp $totalPrice',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
