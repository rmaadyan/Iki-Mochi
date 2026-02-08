import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mochi/app/modules/favorite/controllers/favorite_controller.dart';
import 'package:mochi/app/modules/home/controllers/home_controller.dart';
import 'package:mochi/app/data/models/mochi_model.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoriteController>();
    final homeController = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Mochi'), centerTitle: true),
      body: Obx(() {
        // gabungkan semua mochi (popular + special)
        final List<MochiModel> allMochis = [
          ...homeController.popularMochis,
          ...homeController.specialMochis,
        ];

        final favorites = favController.filterFavorites(allMochis);

        if (favorites.isEmpty) {
          return const Center(
            child: Text(
              'Belum ada mochi favorit ❤️',
              style: TextStyle(fontSize: 14),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) {
            final mochi = favorites[index];

            return Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(mochi.image, fit: BoxFit.contain),
                ),
                title: Text(
                  mochi.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4A58),
                  ),
                ),
                subtitle: Text(
                  'Rp ${mochi.price}',
                  style: const TextStyle(
                    color: Color(0xFFFF85A7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.pinkAccent),
                  onPressed: () {
                    // toggle -> langsung hilang dari list
                    favController.toggleFavorite(mochi);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
