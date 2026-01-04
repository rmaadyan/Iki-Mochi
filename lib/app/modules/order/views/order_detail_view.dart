import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../../../core/utils/map_launcher.dart';
import '../../../core/values/store_location.dart';
import '../../../core/utils/invoice_pdf.dart';

class OrderDetailView extends GetView<OrderController> {
  const OrderDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final String orderId = Get.arguments as String;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pesanan'), centerTitle: true),
      body: Obx(() {
        final order = controller.getOrderById(orderId);

        if (order == null) {
          return const Center(child: Text('Pesanan tidak ditemukan'));
        }

        final List items = (order['order_items'] as List?) ?? [];
        final String status = order['status']?.toString() ?? '-';
        final String paymentMethod = order['payment_method']?.toString() ?? '-';

        final int totalPrice = order['total_price'] is int
            ? order['total_price']
            : int.tryParse(order['total_price']?.toString() ?? '0') ?? 0;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ===== HEADER / INVOICE CARD =====
            _InvoiceCard(
              orderId: orderId,
              status: status,
              paymentMethod: paymentMethod,
            ),

            const SizedBox(height: 20),

            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informasi Pesanan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    _InfoRow(
                      label: 'Alamat',
                      value:
                          order['delivery_address']?.toString() ??
                          'Alamat tidak tersedia',
                    ),

                    _InfoRow(
                      label: 'Tanggal',
                      value: order['created_at'] != null
                          ? DateTime.parse(
                              order['created_at'],
                            ).toLocal().toString()
                          : '-',
                    ),

                    _InfoRow(
                      label: 'Jumlah Item',
                      value: '${items.length} item',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ===== ITEM LIST =====
            const Text(
              'Rincian Pesanan',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            if (items.isEmpty)
              const Text(
                'Item pesanan tidak tersedia',
                style: TextStyle(color: Colors.grey),
              )
            else
              ...items.map((item) {
                final name =
                    item['product_name']?.toString() ??
                    item['name']?.toString() ??
                    'Item';

                final qty = item['quantity'] is int
                    ? item['quantity']
                    : int.tryParse(item['quantity']?.toString() ?? '1') ?? 1;

                final price = item['price'] is int
                    ? item['price']
                    : int.tryParse(item['price']?.toString() ?? '0') ?? 0;

                return _ItemTile(name: name, qty: qty, price: price);
              }),

            const SizedBox(height: 20),

            // ===== TOTAL SUMMARY =====
            _TotalCard(total: totalPrice),

            const SizedBox(height: 20),

            // ===== TRACK STORE LOCATION =====
            ElevatedButton.icon(
              onPressed: () {
                openGoogleMaps(StoreLocation.lat, StoreLocation.lng);
              },
              icon: const Icon(Icons.map_outlined),
              label: const Text('Lacak Lokasi Toko'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                final items = (order['order_items'] as List).map((e) {
                  return {
                    'name': e['product_name'],
                    'qty': e['quantity'],
                    'price': e['price'],
                  };
                }).toList();

                InvoicePdf.preview(
                  invoiceId: order['id'],
                  status: order['status'],
                  paymentMethod: paymentLabel(order['payment_method']),
                  items: items,
                  total: totalPrice,
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Lihat Invoice'),
            ),
          ],
        );
      }),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final String orderId;
  final String status;
  final String paymentMethod;

  const _InvoiceCard({
    required this.orderId,
    required this.status,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'INV-$orderId',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            Row(
              children: [
                _StatusBadge(status),
                const SizedBox(width: 8),
                _PaymentBadge(paymentMethod),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final String name;
  final int qty;
  final int price;

  const _ItemTile({required this.name, required this.qty, required this.price});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.fastfood),
        title: Text(name),
        subtitle: Text('x$qty'),
        trailing: Text(
          'Rp $price',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  final int total;

  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F7CFF), Color(0xFF2F5BEA)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total Pembayaran',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          Text(
            'Rp $total',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge(this.status);

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'completed':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return _Badge(text: status.toUpperCase(), color: color);
  }
}

class _PaymentBadge extends StatelessWidget {
  final String method;
  const _PaymentBadge(this.method);

  @override
  Widget build(BuildContext context) {
    return _Badge(text: paymentLabel(method), color: Colors.blue);
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

String paymentLabel(String method) {
  switch (method) {
    case 'ewallet':
      return 'E-Wallet (Dana)';
    case 'bank':
      return 'Transfer Bank (BNI)';
    case 'cod':
      return 'Bayar di Tempat (COD)';
    default:
      return '-';
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
