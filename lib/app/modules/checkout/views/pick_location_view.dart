import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';

import '../controllers/checkout_controller.dart';

class PickLocationView extends StatefulWidget {
  const PickLocationView({super.key});

  @override
  State<PickLocationView> createState() => _PickLocationViewState();
}

class _PickLocationViewState extends State<PickLocationView> {
  LatLng selected = const LatLng(-6.2, 106.8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: selected,
          initialZoom: 16,
          onPositionChanged: (pos, _) {
            selected = pos.center;
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: selected,
                width: 40,
                height: 40,
                child: const Icon(
                  Icons.location_pin,
                  size: 40,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            final placemarks = await placemarkFromCoordinates(
              selected.latitude,
              selected.longitude,
            );

            final place = placemarks.first;

            Get.find<CheckoutController>().setLocation(
              lat: selected.latitude,
              lng: selected.longitude,
              addr: '${place.street}, ${place.subLocality}, ${place.locality}',
            );

            Get.back();
          },
          child: const Text('Simpan Lokasi'),
        ),
      ),
    );
  }
}
