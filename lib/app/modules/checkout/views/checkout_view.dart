import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = controller.cart;

    return WillPopScope(
      // ✅ JANGAN Get.back() DI SINI
      onWillPop: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        return true; // biarkan Navigator handle pop
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,

          // ✅ BACK BUTTON FINAL (INI YANG DIPAKAI)
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // cukup ini
              FocusManager.instance.primaryFocus?.unfocus();
              Navigator.of(context).maybePop();
            },
          ),

          title: const Text('Checkout'),
        ),

        // ❌ JANGAN Obx DI LUAR
        body: SafeArea(
          bottom: true,
          child: ListView(
            padding: EdgeInsets.fromLTRB(
              16,
              16,
              16,
              MediaQuery.of(context).padding.bottom +
                  32, // 🔥 ANTI KETUTUP NAVBAR
            ),
            children: [
              // ================= PESANAN =================
              const Text(
                'Pesanan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Obx(() {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Keranjang kosong'));
                }

                return Column(
                  children: cart.items.values.map((item) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Image.asset(item.image, width: 36, height: 36),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Rp ${item.price}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                onPressed: () => cart.decrement(item.id),
                              ),
                              Text(
                                '${item.qty}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () => cart.increment(item.id),
                              ),
                            ],
                          ),

                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () => cart.remove(item.id),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),

              const Divider(height: 32),

              // ================= TOTAL =================
              Obx(() {
                return Text(
                  'Total: Rp ${cart.totalPrice}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }),

              const SizedBox(height: 24),

              // ================= ALAMAT =================
              Text(
                'Alamat Pengiriman',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              Obx(() {
                final hasAddress = controller.address.value.isNotEmpty;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        hasAddress
                            ? controller.address.value
                            : 'Belum ada alamat pengiriman',
                        style: TextStyle(
                          color: hasAddress ? null : Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.edit_location_alt),
                              label: const Text('Isi Manual'),
                              onPressed: controller.openManualAddressDialog,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.my_location),
                              label: const Text('Gunakan GPS'),
                              onPressed: controller.pickFromGPS,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // ================= MINI MAP GPS (SAFE) =================
                      Obx(() {
                        final hasLocation =
                            controller.latitude.value != 0 &&
                            controller.longitude.value != 0;

                        if (!hasLocation) return const SizedBox();

                        return SizedBox(
                          height: 150, // 🔥 WAJIB FIXED HEIGHT
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  controller.latitude.value,
                                  controller.longitude.value,
                                ),
                                zoom: 15,
                              ),
                              markers: {
                                Marker(
                                  markerId: const MarkerId('user-location'),
                                  position: LatLng(
                                    controller.latitude.value,
                                    controller.longitude.value,
                                  ),
                                ),
                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                              compassEnabled: false,
                              mapToolbarEnabled: false,
                              liteModeEnabled: true, // ✅ WAJIB (ANTI CRASH)
                              onMapCreated: (_) {}, // ✅ PREVENT NULL CONTROLLER
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              }),

              const SizedBox(height: 24),

              // ================= PAYMENT =================
              const Text(
                'Metode Pembayaran',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              Obx(() {
                return Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('E-Wallet (Dana)'),
                      value: 'ewallet',
                      groupValue: controller.paymentMethod.value,
                      onChanged: controller.setPayment,
                    ),
                    RadioListTile<String>(
                      title: const Text('Transfer Bank (BNI)'),
                      value: 'bank',
                      groupValue: controller.paymentMethod.value,
                      onChanged: controller.setPayment,
                    ),
                    RadioListTile<String>(
                      title: const Text('Bayar di Tempat (COD)'),
                      value: 'cod',
                      groupValue: controller.paymentMethod.value,
                      onChanged: controller.setPayment,
                    ),
                  ],
                );
              }),

              const SizedBox(height: 24),

              // ================= CTA =================
              Obx(() {
                final disabled =
                    cart.items.isEmpty ||
                    controller.address.value.isEmpty ||
                    controller.paymentMethod.value.isEmpty;

                return SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    onPressed: disabled
                        ? null
                        : () async {
                            await controller.submitOrder();
                          },
                    child: const Text('Pesan Sekarang'),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
