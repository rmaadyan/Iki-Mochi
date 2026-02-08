import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_order_controller.dart';
import 'admin_order_detail_view.dart';

class AdminOrderView extends GetView<AdminOrderController> {
  const AdminOrderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Orders'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.orders.isEmpty) {
          return const Center(child: Text('Belum ada pesanan'));
        }

        return RefreshIndicator(
          onRefresh: controller.fetchAllOrders,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final order = controller.orders[i];
              final status = order['status']?.toString() ?? 'unknown';

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: ListTile(
                  title: Text(
                    'Order #${order['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text('Total: Rp ${order['total_price']}'),
                      const SizedBox(height: 4),
                      Text(
                        'Status: ${status.toUpperCase()}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _statusColor(status),
                        ),
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () async {
                    // 👉 buka detail & tunggu hasil
                    await Get.to(() => AdminOrderDetailView(order: order));

                    // 👉 refresh setelah balik
                    controller.fetchAllOrders();
                  },
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

/// ===== STATUS COLOR =====
Color _statusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'processing':
      return Colors.blue;
    case 'completed':
      return Colors.green;
    default:
      return Colors.grey;
  }
}
