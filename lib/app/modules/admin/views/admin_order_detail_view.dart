import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_order_controller.dart';

class AdminOrderDetailView extends GetView<AdminOrderController> {
  final Map<String, dynamic> order;

  const AdminOrderDetailView({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final status = order['status'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order ID',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(order['id']),
            const SizedBox(height: 12),

            Text(
              'Status Saat Ini',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              status.toUpperCase(),
              style: TextStyle(color: Colors.orange),
            ),

            const SizedBox(height: 24),

            if (status == 'pending') ...[
              ElevatedButton(
                onPressed: () async {
                  await controller.updateStatus(
                    order['id'],
                    'processing',
                  );
                  Get.back();
                },
                child: const Text('Proses Pesanan'),
              ),
            ],

            if (status == 'processing') ...[
              ElevatedButton(
                onPressed: () async {
                  await controller.updateStatus(
                    order['id'],
                    'completed',
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: const Text('Selesaikan Pesanan'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
