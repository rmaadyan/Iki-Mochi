import 'package:flutter/material.dart';
import '../../data/models/mochi_model.dart';

class MochiProductCard extends StatelessWidget {
  final MochiModel mochi;
  final VoidCallback? onAdd;

  const MochiProductCard({
    super.key,
    required this.mochi,
    this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // IMAGE
          AspectRatio(
            aspectRatio: 1,
            child: Image.asset(
              mochi.image,
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 10),

          // NAME
          Text(
            mochi.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 4),

          // PRICE
          Text(
            'Rp ${mochi.price}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 10),

          // ADD BUTTON
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
