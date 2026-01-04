import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mochi/app/data/models/mochi_model.dart';
import 'package:mochi/app/modules/favorite/controllers/favorite_controller.dart';

class PopularMochiCard extends StatelessWidget {
  final MochiModel mochi;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  const PopularMochiCard({
    super.key,
    required this.mochi,
    required this.onTap,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final favController = Get.find<FavoriteController>();

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // ===== CARD =====
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // IMAGE
                Expanded(
                  flex: 6,
                  child: Image.asset(mochi.image, fit: BoxFit.contain),
                ),

                const SizedBox(height: 8),

                // NAME
                Text(
                  mochi.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF8B4A58),
                  ),
                ),

                const SizedBox(height: 2),

                // SHORT DESC
                Text(
                  mochi.short,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 6),

                // PRICE
                Text(
                  "Rp ${mochi.price}",
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF85A7),
                  ),
                ),

                const SizedBox(height: 8),

                // ADD BUTTON (UNCHANGED)
                Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF85A7),
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: onAdd,
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // ===== FAVORITE ICON ❤️ =====
          Positioned(
            top: 10,
            right: 10,
            child: Obx(() {
              final isFav = favController.isFavorite(mochi.id);

              return GestureDetector(
                onTap: () => favController.toggleFavorite(mochi),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    size: 18,
                    color: isFav ? Colors.pinkAccent : Colors.grey,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
