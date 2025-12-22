import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../../../routes/app_pages.dart';

class OrderListView extends GetView<OrderController> {
  const OrderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan'), centerTitle: true),
      body: Obx(() {
        // ===== LOADING =====
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // ===== EMPTY STATE =====
        if (controller.orders.isEmpty) {
          return const Center(child: Text('Belum ada pesanan'));
        }

        // ===== ORDER LIST =====
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: controller.orders.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final order = controller.orders[index];
            final List items = (order['order_items'] as List?) ?? [];

            final int itemCount = items.length;

            final String status =
                order['status']?.toString().toLowerCase() ?? 'unknown';

            final int totalPrice = order['total_price'] is int
                ? order['total_price']
                : int.tryParse(order['total_price']?.toString() ?? '0') ?? 0;

            // ===== TITLE LOGIC =====
            String titleText;
            if (itemCount == 0) {
              titleText = 'Item tidak tersedia';
            } else if (itemCount == 1) {
              titleText =
                  items.first['product_name']?.toString() ??
                  items.first['name']?.toString() ??
                  'Item';
            } else {
              final firstName =
                  items.first['product_name']?.toString() ??
                  items.first['name']?.toString() ??
                  'Item';
              titleText = '$firstName + ${itemCount - 1} lainnya';
            }

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _statusColor(status).withOpacity(0.15),
                  child: Icon(Icons.receipt_long, color: _statusColor(status)),
                ),
                title: Text(
                  titleText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(
                      'Status: ${status.toUpperCase()}',
                      style: TextStyle(
                        fontSize: 12,
                        color: _statusColor(status),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total: Rp $totalPrice',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Get.toNamed(Routes.ORDER_DETAIL, arguments: order['id']);
                },
              ),
            );
          },
        );
      }),
    );
  }
}

// ===== STATUS COLOR HELPER =====
Color _statusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'processing':
      return Colors.blue;
    case 'shipped':
      return Colors.purple;
    case 'completed':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
