import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:mochi/app/data/models/dummy_data.dart';
import '../../../data/services/theme_toggle_service.dart';
import 'package:get/get.dart';
import '../../../../app/routes/app_pages.dart';
import '../../../data/services/supabase_service.dart';
import '../../../data/services/local_notification_service.dart';
import '../../../core/values/app_colors.dart';
import '../../order/controllers/order_controller.dart';

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
    Key? key,
    required this.item,
    this.onTap,
    required this.onAddToCart,
  }) : super(key: key);

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

    final double scale = _pressed
        ? 0.985
        : (_hover && isDesktopLike ? 1.03 : 1.0);
    final double elevation = _hover && isDesktopLike ? 16 : 6;

    final double cardWidth = MediaQuery.of(context).size.width >= 1000
        ? rSize(context, 240)
        : rSize(context, 180);

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
            padding: EdgeInsets.all(rSize(context, 14)),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.98),
                  Colors.white.withOpacity(0.92),
                ],
              ),
              borderRadius: BorderRadius.circular(rSize(context, 18)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: elevation,
                  offset: Offset(0, elevation / 3),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER: EMOJI + NAME + PRICE + ADD =====
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: rSize(context, 56),
                      height: rSize(context, 56),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Text(
                          item['emoji'] as String,
                          style: TextStyle(fontSize: rFont(context, 22)),
                        ),
                      ),
                    ),
                    SizedBox(width: rSize(context, 12)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['name'] as String,
                                  style: TextStyle(
                                    fontSize: rFont(context, 13),
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF8B4A58),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: rSize(context, 2)),
                          Text(
                            "Rp.${item['price']}",
                            style: TextStyle(
                              fontSize: rFont(context, 12),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF85A7),
                            ),
                          ),
                          SizedBox(height: rSize(context, 6)),

                          // ===== ADD BUTTON (SENDIRI DI ATAS) =====
                          Align(
                            alignment: Alignment.centerLeft,
                            child: ElevatedButton.icon(
                              onPressed: () => widget.onAddToCart(widget.item),
                              icon: Icon(
                                Icons.add_shopping_cart_outlined,
                                size: rSize(context, 14),
                              ),
                              label: Text(
                                "Add",
                                style: TextStyle(
                                  fontSize: rFont(context, 12),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF85A7),
                                padding: EdgeInsets.symmetric(
                                  horizontal: rSize(context, 10),
                                  vertical: rSize(context, 4),
                                ),
                                minimumSize: Size(0, rSize(context, 30)),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    rSize(context, 10),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: rSize(context, 10)),

                // ===== DESCRIPTION =====
                Text(
                  item['short'] as String? ?? '',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: rFont(context, 11),
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: rSize(context, 12)),

                // ===== DETAILS BUTTON (FULL WIDTH) =====
                SizedBox(
                  width: double.infinity,
                  height: rSize(context, 34),
                  child: OutlinedButton(
                    onPressed: widget.onTap,
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(rSize(context, 10)),
                      ),
                    ),
                    child: Text(
                      "Details",
                      style: TextStyle(
                        fontSize: rFont(context, 12),
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
  String? _selectedPayment; // DEFAULT NULL, BUKAN 'ewallet

  // data
  final List<Map<String, dynamic>> popularMochis = popularMochisData;
  final List<Map<String, dynamic>> specialMochis = specialMochisData;

  final Map<String, CartItem> _cart = {};
  final PageController _specialPageController = PageController(
    viewportFraction: 0.98,
  );

  @override
  void dispose() {
    _specialPageController.dispose();
    super.dispose();
  }

  // ================= CART =================
  void _addToCartFromMap(Map<String, dynamic> itemMap, {int amount = 1}) {
    final id = itemMap['id'] ?? itemMap['name'];

    setState(() {
      if (_cart.containsKey(id)) {
        _cart[id]!.qty += amount;
      } else {
        _cart[id] = CartItem(
          id: id,
          name: itemMap['name'] ?? itemMap['title'],
          price: itemMap['price'].toString(),
          emoji: itemMap['emoji'] ?? '🍡',
          qty: amount,
        );
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${itemMap['name'] ?? itemMap['title']} ditambahkan ke keranjang.",
        ),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  int _cartTotalQty() =>
      _cart.values.fold<int>(0, (sum, item) => sum + item.qty);

  void _openCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.6,
              minChildSize: 0.35,
              maxChildSize: 0.95,
              builder: (context, controller) {
                final theme = Theme.of(context);
                final colors = theme.colorScheme;
                final text = theme.textTheme;

                final cartItems = _cart.values.toList();

                return Material(
                  color: colors.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        height: 5,
                        width: 60,
                        decoration: BoxDecoration(
                          color: colors.onSurface.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ===== HEADER =====
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: rSize(context, 16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Your Cart", style: text.titleLarge),
                            Text(
                              "${_cartTotalQty()} items",
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ===== CART LIST =====
                      Expanded(
                        child: cartItems.isEmpty
                            ? Center(
                                child: Text(
                                  "Keranjang kosong",
                                  style: text.bodyMedium,
                                ),
                              )
                            : ListView.builder(
                                controller: controller,
                                itemCount: cartItems.length,
                                itemBuilder: (_, idx) {
                                  final item = cartItems[idx];

                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: colors.primary
                                          .withOpacity(0.15),
                                      child: Text(item.emoji),
                                    ),
                                    title: Text(
                                      item.name,
                                      style: text.bodyLarge,
                                    ),
                                    subtitle: Text(
                                      "Rp.${item.price} × ${item.qty}",
                                      style: text.bodySmall,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            item.qty == 1
                                                ? Icons.delete_outline
                                                : Icons.remove_circle_outline,
                                          ),
                                          color: item.qty == 1
                                              ? colors.error
                                              : colors.onSurface,
                                          onPressed: () {
                                            setModalState(() {
                                              if (item.qty <= 1) {
                                                _cart.remove(item.id);
                                              } else {
                                                item.qty--;
                                              }
                                            });
                                          },
                                        ),
                                        Text(
                                          '${item.qty}',
                                          style: text.bodyLarge,
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          onPressed: () {
                                            setModalState(() => item.qty++);
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),

                      // ===== FOOTER =====
                      Padding(
                        padding: EdgeInsets.all(rSize(context, 16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // TOTAL
                            Text("Total", style: text.bodySmall),
                            const SizedBox(height: 6),
                            Text(
                              "Rp.${_cart.values.fold<int>(0, (sum, item) => sum + (int.tryParse(item.price.replaceAll('.', '')) ?? 0) * item.qty)}",
                              style: text.titleLarge,
                            ),

                            const SizedBox(height: 16),

                            // ===== PAYMENT METHOD =====
                            Text("Metode Pembayaran", style: text.titleMedium),
                            const SizedBox(height: 8),

                            RadioListTile<String>(
                              value: 'ewallet',
                              groupValue: _selectedPayment,
                              onChanged: (v) =>
                                  setModalState(() => _selectedPayment = v),
                              title: const Text('E-Wallet (Dana)'),
                              secondary: const Icon(
                                Icons.account_balance_wallet_outlined,
                              ),
                            ),

                            RadioListTile<String>(
                              value: 'bank',
                              groupValue: _selectedPayment,
                              onChanged: (v) =>
                                  setModalState(() => _selectedPayment = v),
                              title: const Text('Transfer Bank (BNI)'),
                              secondary: const Icon(
                                Icons.account_balance_outlined,
                              ),
                            ),

                            RadioListTile<String>(
                              value: 'cod',
                              groupValue: _selectedPayment,
                              onChanged: (v) =>
                                  setModalState(() => _selectedPayment = v),
                              title: const Text('Bayar di Tempat (COD)'),
                              secondary: const Icon(Icons.payments_outlined),
                            ),

                            const SizedBox(height: 12),

                            // ===== CHECKOUT BUTTON =====
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: cartItems.isEmpty
                                    ? null
                                    : () async {
                                        if (_selectedPayment == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Pilih metode pembayaran terlebih dahulu',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        final supabase =
                                            Get.find<SupabaseService>();
                                        final notifier =
                                            Get.find<
                                              LocalNotificationService
                                            >();

                                        final items = cartItems.map((e) {
                                          return {
                                            'id': e.id,
                                            'name': e.name,
                                            'price': int.parse(
                                              e.price.replaceAll('.', ''),
                                            ),
                                            'qty': e.qty,
                                            'emoji': e.emoji,
                                          };
                                        }).toList();

                                        final total = items.fold<int>(
                                          0,
                                          (sum, i) =>
                                              sum +
                                              (i['price'] as int) *
                                                  (i['qty'] as int),
                                        );

                                        await supabase.createOrder(
                                          totalPrice: total,
                                          items: items,
                                          paymentMethod: _selectedPayment!,
                                        );

                                        // 🔥 REFRESH LIST PESANAN
                                        Get.find<OrderController>()
                                            .fetchOrders();

                                        await notifier.showOrderSuccess();

                                        setModalState(() {
                                          _cart.clear();
                                          _selectedPayment = null;
                                        });

                                        await notifier.showOrderSuccess();

                                        Get.back(); // tutup bottom sheet SAJA

                                        setState(() {
                                          _cart.clear();
                                          _selectedPayment = null;
                                        });
                                      },
                                child: Text('Checkout', style: text.labelLarge),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _goToGpsLocation() {
    Get.toNamed(Routes.GPS_LOCATION);
  }

  void _goToNetworkLocation() {
    Get.toNamed(Routes.NETWORK_LOCATION);
  }

  void _showDetailSheet(Map<String, dynamic> mochi, {bool reviewTab = false}) {
    final Size screen = MediaQuery.of(context).size;
    final double maxSheetHeight = screen.height * 0.85;
    final double maxSheetWidth = screen.width > 900 ? 900 : screen.width * 0.96;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        Widget content = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: maxSheetWidth,
              maxHeight: maxSheetHeight,
            ),
            child: Material(
              borderRadius: BorderRadius.circular(20),
              clipBehavior: Clip.antiAlias,
              child: MochiDetailSheet(
                mochi: mochi,
                initialTabIndex: reviewTab ? 1 : 0,
                onAddReview: (r) => setState(() => mochi['reviews'].add(r)),
                onAddToCart: (m) => _addToCartFromMap(m),
              ),
            ),
          ),
        );

        if (kIsWeb || screen.width >= 700)
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: rSize(context, 24),
              horizontal: rSize(context, 16),
            ),
            child: content,
          );
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.82,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          builder: (context, controller) => Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: MochiDetailSheet(
              mochi: mochi,
              initialTabIndex: reviewTab ? 1 : 0,
              onAddReview: (r) => setState(() => mochi['reviews'].add(r)),
              onAddToCart: (m) => _addToCartFromMap(m),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final double iconSize = isTablet ? 38 : 24;

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
          child: Column(
            children: [
              // ===== HEADER =====
              Padding(
                padding: EdgeInsets.only(
                  top: rSize(context, 12),
                  bottom: rSize(context, 16),
                  left: rSize(context, 16),
                  right: rSize(context, 16),
                ),
                child: Column(
                  children: [
                    // ===== TITLE =====
                    Text(
                      "Pick Your\nFavorite Mochi",
                      textAlign: TextAlign.center, // 🔥 INI WAJIB
                      style: TextStyle(
                        fontSize: rFont(context, 26),
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        height: 1.2, // opsional, biar jarak baris cakep
                      ),
                    ),

                    SizedBox(height: rSize(context, 12)),

                    // ===== ICON ROW =====
                    Builder(
                      builder: (context) {
                        final iconColor = AppColors.primary.withOpacity(
                          Theme.of(context).brightness == Brightness.dark
                              ? 0.85
                              : 1,
                        );

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // CART + BADGE
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                IconButton(
                                  iconSize: iconSize,
                                  icon: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: iconColor,
                                  ),
                                  onPressed: _openCartSheet,
                                ),

                                if (_cartTotalQty() > 0)
                                  Positioned(
                                    right: -4,
                                    top: -4,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: rSize(context, 6),
                                        vertical: rSize(context, 2),
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        borderRadius: BorderRadius.circular(
                                          rSize(context, 12),
                                        ),
                                      ),

                                      child: Text(
                                        "${_cartTotalQty()}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: rFont(context, 11),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            SizedBox(width: rSize(context, 12)),

                            // GPS
                            IconButton(
                              iconSize: iconSize,
                              icon: Icon(Icons.gps_fixed, color: iconColor),
                              onPressed: _goToGpsLocation,
                            ),

                            SizedBox(width: rSize(context, 12)),

                            // NETWORK
                            IconButton(
                              iconSize: iconSize,
                              icon: Icon(Icons.network_cell, color: iconColor),
                              onPressed: _goToNetworkLocation,
                            ),

                            SizedBox(width: rSize(context, 12)),

                            // THEME TOGGLE
                            Obx(() {
                              return IconButton(
                                iconSize: iconSize,
                                icon: Icon(
                                  themeService.isDark.value
                                      ? Icons.light_mode_outlined
                                      : Icons.dark_mode_outlined,
                                  color: iconColor,
                                ),
                                onPressed: themeService.toggleTheme,
                              );
                            }),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: rSize(context, 16),
                    vertical: rSize(context, 12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ===== POPULAR MOCHI =====
                      Text(
                        'Popular Mochi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: rSize(context, 12)),

                      if (screenWidth < 720)
                        SizedBox(
                          height: rSize(context, 220),
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            padding: EdgeInsets.symmetric(
                              horizontal: rSize(context, 8),
                            ),
                            itemCount: popularMochis.length,
                            separatorBuilder: (_, __) =>
                                SizedBox(width: rSize(context, 12)),
                            itemBuilder: (context, idx) {
                              final it = popularMochis[idx];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: rSize(context, 6),
                                ),
                                child: HoverMochiCard(
                                  item: it,
                                  onTap: () => _showDetailSheet(it),
                                  onAddToCart: (m) => _addToCartFromMap(m),
                                ),
                              );
                            },
                            physics: const BouncingScrollPhysics(),
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: screenWidth >= 1100 ? 4 : 3,
                                crossAxisSpacing: rSize(context, 12),
                                mainAxisSpacing: rSize(context, 12),
                                childAspectRatio: 0.88,
                              ),
                          itemCount: popularMochis.length,
                          itemBuilder: (_, idx) => HoverMochiCard(
                            item: popularMochis[idx],
                            onTap: () => _showDetailSheet(popularMochis[idx]),
                            onAddToCart: (m) => _addToCartFromMap(m),
                          ),
                        ),

                      SizedBox(height: rSize(context, 24)),

                      // ===== SPECIAL MOCHI =====
                      Text(
                        'Special Mochi',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: rSize(context, 12)),

                      // Vertical list of special mochi (scrolls with page)
                      Column(
                        children: [
                          for (final mochi in specialMochis) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: rSize(context, 8),
                              ),
                              child: InkWell(
                                onTap: () =>
                                    _showDetailSheet(mochi, reviewTab: false),
                                borderRadius: BorderRadius.circular(
                                  rSize(context, 16),
                                ),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      rSize(context, 16),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 12,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(
                                          rSize(context, 14),
                                        ),
                                        child: Row(
                                          children: [
                                            Container(
                                              width: rSize(context, 100),
                                              height: rSize(context, 100),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFFF0F5),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                      rSize(context, 12),
                                                    ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  mochi['emoji'] as String,
                                                  style: TextStyle(
                                                    fontSize: rFont(
                                                      context,
                                                      36,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: rSize(context, 12)),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    mochi['title'] as String,
                                                    style: TextStyle(
                                                      fontSize: rFont(
                                                        context,
                                                        16,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: const Color(
                                                        0xFF8B4A58,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: rSize(context, 6),
                                                  ),
                                                  Text(
                                                    "Rp.${mochi['price']}",
                                                    style: TextStyle(
                                                      fontSize: rFont(
                                                        context,
                                                        14,
                                                      ),
                                                      color: const Color(
                                                        0xFFFF85A7,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: rSize(context, 8),
                                                  ),
                                                  Wrap(
                                                    spacing: rSize(context, 8),
                                                    children: (mochi['tags'] as List)
                                                        .map<Widget>(
                                                          (t) => Container(
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      rSize(
                                                                        context,
                                                                        10,
                                                                      ),
                                                                  vertical:
                                                                      rSize(
                                                                        context,
                                                                        6,
                                                                      ),
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  const Color(
                                                                    0xFFFFF0F5,
                                                                  ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    rSize(
                                                                      context,
                                                                      12,
                                                                    ),
                                                                  ),
                                                            ),
                                                            child: Text(
                                                              t,
                                                              style: TextStyle(
                                                                fontSize: rFont(
                                                                  context,
                                                                  11,
                                                                ),
                                                                color:
                                                                    const Color(
                                                                      0xFF8B4A58,
                                                                    ),
                                                              ),
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
                                        padding: EdgeInsets.symmetric(
                                          horizontal: rSize(context, 16),
                                          vertical: rSize(context, 10),
                                        ),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                mochi['description'] as String,
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: rFont(context, 13),
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: rSize(context, 12),
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () =>
                                                        _showDetailSheet(
                                                          mochi,
                                                          reviewTab: false,
                                                        ),
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              const Color(
                                                                0xFFFF85A7,
                                                              ),
                                                        ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: rSize(
                                                              context,
                                                              12,
                                                            ),
                                                          ),
                                                      child: Text(
                                                        "Details",
                                                        style: TextStyle(
                                                          fontSize: rFont(
                                                            context,
                                                            13,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: rSize(context, 12),
                                                ),
                                                OutlinedButton(
                                                  onPressed: () =>
                                                      _addToCartFromMap(mochi),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                          vertical: rSize(
                                                            context,
                                                            12,
                                                          ),
                                                          horizontal: rSize(
                                                            context,
                                                            12,
                                                          ),
                                                        ),
                                                    child: Text(
                                                      "Add",
                                                      style: TextStyle(
                                                        fontSize: rFont(
                                                          context,
                                                          13,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: rSize(context, 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                          SizedBox(height: rSize(context, 20)),
                        ],
                      ),
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

    final List<Map<String, dynamic>> reviews =
        (mochi['reviews'] as List?)
            ?.map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];

    return Column(
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
                child: Center(
                  child: Text(
                    mochi['emoji'] ?? '🍡',
                    style: TextStyle(fontSize: rFont(context, 32)),
                  ),
                ),
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

        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              // ===== DETAILS TAB =====
              Padding(
                padding: EdgeInsets.all(rSize(context, 16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // === DESCRIPTION ===
                    Text(
                      mochi['description'] ??
                          mochi['short'] ??
                          'No description available.',
                      style: TextStyle(
                        fontSize: rFont(context, 13),
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),

                    SizedBox(height: rSize(context, 20)),

                    // === INGREDIENTS ===
                    if (mochi['ingredients'] != null) ...[
                      Text(
                        "Ingredients",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: rFont(context, 14),
                        ),
                      ),
                      SizedBox(height: rSize(context, 8)),
                      Wrap(
                        spacing: rSize(context, 8),
                        runSpacing: rSize(context, 6),
                        children: (mochi['ingredients'] as List)
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

                    // === NUTRITION INFO ===
                    Row(
                      children: [
                        if (mochi['calories'] != null)
                          _InfoBadge(
                            label: "${mochi['calories']} kcal",
                            icon: Icons.local_fire_department,
                          ),
                        SizedBox(width: rSize(context, 12)),
                        if (mochi['stock'] != null)
                          _InfoBadge(
                            label: "Stock: ${mochi['stock']}",
                            icon: Icons.inventory_2,
                          ),
                      ],
                    ),

                    SizedBox(height: rSize(context, 24)),

                    // === ADD TO CART ===
                    SizedBox(
                      width: double.infinity,
                      height: rSize(context, 44),
                      child: ElevatedButton(
                        onPressed: () => widget.onAddToCart?.call(mochi),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF85A7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              rSize(context, 22),
                            ),
                          ),
                        ),
                        child: Text(
                          "Add to Cart",
                          style: TextStyle(fontSize: rFont(context, 14)),
                        ),
                      ),
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
                            itemBuilder: (_, i) => _buildReviewCard(reviews[i]),
                          ),
                  ),

                  // === INPUT REVIEW ===
                  Padding(
                    padding: EdgeInsets.all(rSize(context, 12)),
                    child: Row(
                      children: [
                        DropdownButton<int>(
                          value: _selectedRating,
                          items: [5, 4, 3, 2, 1]
                              .map(
                                (r) => DropdownMenuItem(
                                  value: r,
                                  child: Text("$r ★"),
                                ),
                              )
                              .toList(),
                          onChanged: (v) =>
                              setState(() => _selectedRating = v ?? 5),
                        ),
                        SizedBox(width: rSize(context, 8)),
                        Expanded(
                          child: TextField(
                            controller: _reviewTextController,
                            decoration: const InputDecoration(
                              hintText: "Tulis review...",
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: _addReview,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
