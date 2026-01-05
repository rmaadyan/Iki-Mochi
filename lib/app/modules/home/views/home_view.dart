import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mochi/app/ui/widgets/popular_mochi_card.dart';
import 'package:mochi/app/data/models/dummy_data.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/home_controller.dart';
import '../../../data/services/theme_toggle_service.dart';
import '../../../core/values/app_colors.dart';
import 'package:mochi/app/routes/app_pages.dart';

/// ---------- Responsive helpers ----------
double _clamp(double v, double min, double max) =>
    v < min ? min : (v > max ? max : v);

double rSize(BuildContext context, double size) {
  final w = MediaQuery.of(context).size.width;
  final scale = (w / 390);
  final s = _clamp(scale, 0.75, 1.6);
  return size * s;
}

double rFont(BuildContext context, double font) {
  final tsf = MediaQuery.of(context).textScaleFactor;
  final base = rSize(context, font);
  final tsfClamped = _clamp(tsf, 0.85, 1.2);
  return (base * tsfClamped);
}

/// ---------- HoverMochiCard ----------

class HoverMochiCard extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onTap;
  final void Function(Map<String, dynamic> item) onAddToCart;

  const HoverMochiCard({
    super.key,
    required this.item,
    this.onTap,
    required this.onAddToCart,
  });

  @override
  State<HoverMochiCard> createState() => _HoverMochiCardState();
}

class _HoverMochiCardState extends State<HoverMochiCard> {
  bool _hover = false;
  bool _pressed = false;

  void _setHover(bool v) => setState(() => _hover = v);
  void _setPressed(bool v) => setState(() => _pressed = v);

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final bool isDesktopLike = MediaQuery.of(context).size.width >= 700;

    // ================= SAFE DATA EXTRACTION =================
    final String emoji = item['emoji']?.toString() ?? '🍡';

    final String name =
        item['name']?.toString() ??
        item['title']?.toString() ??
        'Unknown Mochi';

    final String price = item['price']?.toString() ?? '0';

    final String description =
        item['short']?.toString() ??
        item['description']?.toString() ??
        'No description available';

    // ================= UI EFFECT =================
    final double scale = _pressed
        ? 0.97
        : (_hover && isDesktopLike ? 1.03 : 1.0);

    final double elevation = _hover && isDesktopLike ? 16 : 6;

    final double cardWidth = MediaQuery.of(context).size.width >= 1000
        ? 240
        : 180;

    return MouseRegion(
      onEnter: (_) => _setHover(true),
      onExit: (_) => _setHover(false),
      child: GestureDetector(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          scale: scale,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: cardWidth,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.98),
                  Colors.white.withOpacity(0.92),
                ],
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 3),
                ),
              ],
            ),

            // ================= CONTENT =================
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 22),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF8B4A58),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Rp.$price",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFF85A7),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: () => widget.onAddToCart(widget.item),
                              icon: const Icon(
                                Icons.add_shopping_cart_outlined,
                                size: 14,
                              ),
                              label: const Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF85A7),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                minimumSize: const Size(0, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ===== DESCRIPTION (FLEKSIBEL) =====
                Expanded(
                  child: Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 11,
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ===== DETAILS BUTTON =====
                SizedBox(
                  width: double.infinity,
                  height: 34,
                  child: OutlinedButton(
                    onPressed: widget.onTap,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------- Homeview ----------
class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  State<HomeView> createState() => _HomeViewState();
}

// ---------- Cart Model ----------
class CartItem {
  final String id;
  final String name;
  final String price;
  final String emoji;
  int qty;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
    this.qty = 1,
  });
}

class _HomeViewState extends State<HomeView> {
  // ================= CONTROLLERS =================
  final HomeController controller = Get.find<HomeController>();
  final CartController cartController = Get.find<CartController>();
  final PageController _specialPageController = PageController(
    viewportFraction: 0.98,
  );

  @override
  void dispose() {
    _specialPageController.dispose();
    super.dispose();
  }

  // ================= MOCHI DATA (SINGLE SOURCE) =================
  final List<Map<String, dynamic>> allMochis = mochiDummyData;

  late final List<Map<String, dynamic>> popularMochis;
  late final List<Map<String, dynamic>> specialMochis;

  @override
  void initState() {
    super.initState();

    popularMochis = allMochis.where((m) => m['isPopular'] == true).toList();

    specialMochis = allMochis.where((m) => m['isSpecial'] == true).toList();
  }

  // ================= DETAIL SHEET =================
  void _showDetailSheet(Map<String, dynamic> mochi, {bool reviewTab = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (_, __) => Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: MochiDetailSheet(
              mochi: mochi,
              initialTabIndex: reviewTab ? 1 : 0,
              onAddReview: (r) {
                setState(() {
                  mochi['reviews']?.add(r);
                });
              },
              onAddToCart: (m) {
                cartController.addItemFromMap(m);
              },
            ),
          ),
        );
      },
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final iconSize = isTablet ? 38.0 : 24.0;

    final themeService = Get.find<ThemeToggleService>();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(-0.8, -0.8),
            radius: 1.2,
            colors: isDark
                ? const [Color(0xFF2A1F24), Color(0xFF1E1E1E)]
                : const [Color(0xFFFFF7FC), Color(0xFFFFEEF6)],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // ================= HEADER =================
              SliverAppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                expandedHeight: rSize(context, 140),
                automaticallyImplyLeading: false,
                flexibleSpace: Stack(
                  children: [
                    // CART ICON
                    Positioned(
                      top: rSize(context, 8),
                      left: rSize(context, 8),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            iconSize: iconSize,
                            icon: Icon(
                              Icons.shopping_bag_outlined,
                              color: AppColors.primary,
                            ),
                            onPressed: () => Get.toNamed(Routes.CHECKOUT),
                          ),
                          Obx(() {
                            if (cartController.totalQty == 0) {
                              return const SizedBox();
                            }
                            return Positioned(
                              right: -4,
                              top: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${cartController.totalQty}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    // THEME TOGGLE
                    Positioned(
                      top: rSize(context, 8),
                      right: rSize(context, 8),
                      child: Obx(() {
                        return IconButton(
                          iconSize: iconSize,
                          icon: Icon(
                            themeService.isDark.value
                                ? Icons.light_mode_outlined
                                : Icons.dark_mode_outlined,
                            color: AppColors.primary,
                          ),
                          onPressed: themeService.toggleTheme,
                        );
                      }),
                    ),

                    // TITLE
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: rSize(context, 16)),
                        child: Text(
                          "Pick Your\nFavorite Mochi",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: rFont(context, 26),
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ================= CONTENT =================
              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: rSize(context, 16),
                  vertical: rSize(context, 12),
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== POPULAR =====
                      Text(
                        'Popular Mochi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: rSize(context, 12)),

                      Obx(() {
                        // 1️⃣ loading
                        if (controller.isLoading.value) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final items = controller.popularMochis;

                        // 2️⃣ empty state (INI PENTING)
                        if (items.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'Popular mochi belum tersedia',
                              style: TextStyle(color: Colors.grey),
                            ),
                          );
                        }

                        // 3️⃣ grid normal
                        final crossAxisCount = screenWidth >= 1100
                            ? 4
                            : screenWidth >= 720
                            ? 3
                            : 2;

                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: rSize(context, 14),
                                mainAxisSpacing: rSize(context, 18),
                                childAspectRatio: 0.62,
                              ),
                          itemCount: items.length,
                          itemBuilder: (_, idx) {
                            final mochi = items[idx];

                            return PopularMochiCard(
                              mochi: mochi,
                              onTap: () {
                                // kalau mau nanti buka detail
                              },
                              onAdd: () {
                                cartController.addItemFromMap({
                                  'id': mochi.id,
                                  'name': mochi.name,
                                  'price': mochi.price,
                                  'image': mochi.image,
                                });
                              },
                            );
                          },
                        );
                      }),

                      SizedBox(height: rSize(context, 40)),

                      // ===== SPECIAL =====
                      Text(
                        'Special Mochi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: rSize(context, 12)),

                      Column(
                        children: specialMochis.map((mochi) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: rSize(context, 8),
                            ),
                            child: _SpecialMochiCard(
                              mochi: mochi,
                              onTap: () => _showDetailSheet(mochi),
                              onAddToCart: () {
                                cartController.addItemFromMap(mochi);
                              },
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: rSize(context, 32)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SpecialMochiCard extends StatelessWidget {
  final Map<String, dynamic> mochi;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _SpecialMochiCard({
    required this.mochi,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Image.asset(mochi['image'], fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mochi['title'] ?? mochi['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B4A58),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Rp.${mochi['price']}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF85A7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: (mochi['tags'] as List? ?? [])
                            .map<Widget>(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  t,
                                  style: const TextStyle(fontSize: 11),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                mochi['description'] ?? mochi['short'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  height: 1.4,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF85A7),
                    ),
                    child: const Text("Details"),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: onAddToCart,
                  child: const Text("Add"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

/// ---------- MochiDetailSheet ----------
class MochiDetailSheet extends StatefulWidget {
  final Map<String, dynamic> mochi;
  final int initialTabIndex;
  final void Function(Map<String, dynamic>)? onAddReview;
  final void Function(Map<String, dynamic>)? onAddToCart;

  const MochiDetailSheet({
    Key? key,
    required this.mochi,
    this.initialTabIndex = 0,
    this.onAddReview,
    this.onAddToCart,
  }) : super(key: key);

  @override
  State<MochiDetailSheet> createState() => _MochiDetailSheetState();
}

class _MochiDetailSheetState extends State<MochiDetailSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _reviewTextController = TextEditingController();
  int _selectedRating = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewTextController.dispose();
    super.dispose();
  }

  void _addReview() {
    final text = _reviewTextController.text.trim();
    if (text.isEmpty) return;

    final newReview = {
      "rating": _selectedRating,
      "text": text,
      "author": "You",
    };

    setState(() {
      (widget.mochi['reviews'] as List?)?.add(newReview);
    });

    widget.onAddReview?.call(newReview);
    _reviewTextController.clear();
    _selectedRating = 5;
    _tabController.animateTo(1);
  }

  Widget _buildReviewCard(Map r) {
    final int rating = r['rating'] ?? 0;

    return Card(
      margin: EdgeInsets.only(bottom: rSize(context, 10)),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(rSize(context, 12)),
      ),
      child: Padding(
        padding: EdgeInsets.all(rSize(context, 12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey.shade200,
                  child: Text(
                    (r['author'] ?? '?')
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                  ),
                ),
                SizedBox(width: rSize(context, 8)),
                Text(
                  r['author'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: rFont(context, 13),
                  ),
                ),
                const Spacer(),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < rating ? Icons.star : Icons.star_border,
                      size: rSize(context, 14),
                      color: const Color(0xFFFFB6C1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: rSize(context, 6)),
            Text(
              r['text'] ?? '',
              style: TextStyle(fontSize: rFont(context, 12)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mochi = widget.mochi;

    final List ingredients =
        (mochi['ingredients'] as List?) ??
        (mochi['composition'] as List?) ??
        [];

    final nutrition = mochi['nutrition'] as Map<String, dynamic>?;

    final List<Map<String, dynamic>> reviews =
        (mochi['reviews'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];

    return SafeArea(
      top: false,
      child: Column(
        children: [
          SizedBox(height: rSize(context, 8)),
          Container(
            width: rSize(context, 40),
            height: rSize(context, 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(rSize(context, 8)),
            ),
          ),

          // === HEADER ===
          Padding(
            padding: EdgeInsets.all(rSize(context, 16)),
            child: Row(
              children: [
                Container(
                  width: rSize(context, 96),
                  height: rSize(context, 96),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F5),
                    borderRadius: BorderRadius.circular(rSize(context, 12)),
                  ),
                  child: Image.asset(mochi['image'], fit: BoxFit.contain),
                ),
                SizedBox(width: rSize(context, 12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mochi['title'] ?? mochi['name'] ?? '',
                        style: TextStyle(
                          fontSize: rFont(context, 18),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF8B4A58),
                        ),
                      ),
                      SizedBox(height: rSize(context, 4)),
                      Text(
                        "Rp.${mochi['price']}",
                        style: TextStyle(
                          fontSize: rFont(context, 14),
                          color: const Color(0xFFFF85A7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // === TABS ===
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFFFF85A7),
            indicatorColor: const Color(0xFFFF85A7),
            tabs: const [
              Tab(text: "Details"),
              Tab(text: "Reviews"),
            ],
          ),

          // === TAB CONTENT ===
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // ===== DETAILS TAB =====
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    rSize(context, 16),
                    rSize(context, 16),
                    rSize(context, 16),
                    rSize(context, 120), // 🔥 ruang aman untuk tombol
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mochi['longDescription'] ??
                            mochi['description'] ??
                            mochi['short'] ??
                            'No description available.',
                        style: TextStyle(
                          fontSize: rFont(context, 13),
                          color: Colors.grey.shade700,
                          height: 1.5,
                        ),
                      ),

                      SizedBox(height: rSize(context, 20)),

                      if (ingredients.isNotEmpty) ...[
                        Text(
                          "Komposisi",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: rFont(context, 14),
                          ),
                        ),
                        SizedBox(height: rSize(context, 8)),
                        Wrap(
                          spacing: rSize(context, 8),
                          runSpacing: rSize(context, 6),
                          children: ingredients
                              .map<Widget>(
                                (i) => Chip(
                                  label: Text(
                                    i.toString(),
                                    style: TextStyle(
                                      fontSize: rFont(context, 11),
                                    ),
                                  ),
                                  backgroundColor: const Color(0xFFFFF0F5),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: rSize(context, 16)),
                      ],

                      Wrap(
                        spacing: rSize(context, 12),
                        runSpacing: rSize(context, 8),
                        children: [
                          if (nutrition?['energy'] != null)
                            _InfoBadge(
                              label: "${nutrition!['energy']} kcal",
                              icon: Icons.local_fire_department,
                            ),
                          if (nutrition?['protein'] != null)
                            _InfoBadge(
                              label: "Protein ${nutrition!['protein']}g",
                              icon: Icons.fitness_center,
                            ),
                          if (nutrition?['carbs'] != null)
                            _InfoBadge(
                              label: "Carbs ${nutrition!['carbs']}g",
                              icon: Icons.grain,
                            ),
                          if (mochi['weight'] != null)
                            _InfoBadge(
                              label: mochi['weight'],
                              icon: Icons.scale,
                            ),
                          if (mochi['stock'] != null)
                            _InfoBadge(
                              label: "Stock ${mochi['stock']}",
                              icon: Icons.inventory_2,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),

                // ===== REVIEWS TAB =====
                Column(
                  children: [
                    Expanded(
                      child: reviews.isEmpty
                          ? Center(
                              child: Text(
                                "Belum ada review",
                                style: TextStyle(fontSize: rFont(context, 13)),
                              ),
                            )
                          : ListView.builder(
                              padding: EdgeInsets.all(rSize(context, 12)),
                              itemCount: reviews.length,
                              itemBuilder: (_, i) =>
                                  _buildReviewCard(reviews[i]),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // === SAFE ADD TO CART ===
          SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                rSize(context, 16),
                rSize(context, 8),
                rSize(context, 16),
                rSize(context, 16),
              ),
              child: SizedBox(
                width: double.infinity,
                height: rSize(context, 48),
                child: ElevatedButton(
                  onPressed: () => widget.onAddToCart?.call(mochi),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF85A7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(rSize(context, 24)),
                    ),
                  ),
                  child: Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: rFont(context, 14)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final IconData icon;

  const _InfoBadge({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: rSize(context, 12),
        vertical: rSize(context, 6),
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(rSize(context, 20)),
      ),
      child: Row(
        children: [
          Icon(icon, size: rSize(context, 14), color: Colors.pinkAccent),
          SizedBox(width: rSize(context, 6)),
          Text(label, style: TextStyle(fontSize: rFont(context, 12))),
        ],
      ),
    );
  }
}
