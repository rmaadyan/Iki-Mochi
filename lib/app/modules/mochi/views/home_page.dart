import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    ),
  );
}

/// ---------- Responsive helpers ----------
double _clamp(double v, double min, double max) => v < min ? min : (v > max ? max : v);

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
  const HoverMochiCard({Key? key, required this.item, this.onTap, required this.onAddToCart}) : super(key: key);

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
    final double scale = _pressed ? 0.985 : (_hover && isDesktopLike ? 1.03 : 1.0);
    final double elevation = _hover && isDesktopLike ? 16 : 6;
    final double cardWidth = MediaQuery.of(context).size.width >= 1000 ? rSize(context, 240) : rSize(context, 180);

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
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                (item['bg'] as Color).withOpacity(0.92),
                Colors.white.withOpacity(0.02),
              ]),
              borderRadius: BorderRadius.circular(rSize(context, 18)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: elevation, offset: Offset(0, elevation / 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: rSize(context, 56),
                      height: rSize(context, 56),
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                      child: Center(child: Text(item['emoji'] as String, style: TextStyle(fontSize: rFont(context, 22)))),
                    ),
                    SizedBox(width: rSize(context, 12)),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(
                          item['name'] as String,
                          style: TextStyle(fontSize: rFont(context, 13), fontWeight: FontWeight.w700, color: const Color(0xFF8B4A58)),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "Rp.${item['price']}",
                          style: TextStyle(fontSize: rFont(context, 12), fontWeight: FontWeight.bold, color: const Color(0xFFFF85A7)),
                        ),
                      ]),
                    )
                  ],
                ),
                SizedBox(height: rSize(context, 8)),
                Text(
                  item['short'] as String? ?? '',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: rFont(context, 11), height: 1.2),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: rSize(context, 12)),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: rSize(context, 38),
                        child: ElevatedButton.icon(
                          onPressed: () => widget.onAddToCart(widget.item),
                          icon: Icon(Icons.add_shopping_cart_outlined, size: rSize(context, 16)),
                          label: Text("Add", style: TextStyle(fontSize: rFont(context, 13))),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF85A7),
                            padding: EdgeInsets.symmetric(vertical: rSize(context, 6)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rSize(context, 10))),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: rSize(context, 8)),
                    SizedBox(
                      height: rSize(context, 38),
                      child: OutlinedButton(
                        onPressed: widget.onTap,
                        child: Text("Details", style: TextStyle(fontSize: rFont(context, 13))),
                        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rSize(context, 10)))),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// ---------- HomePage ----------
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class CartItem {
  final String id;
  final String name;
  final String price;
  final String emoji;
  int qty;
  CartItem({required this.id, required this.name, required this.price, required this.emoji, this.qty = 1});
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, dynamic>> popularMochis = [
    {"id":"strawberry","name":"Strawberry","price":"4.500","emoji":"🍓","bg":const Color(0xFFFFF0F5),"short":"Fresh strawberry wrapped in sweet mochi."},
    {"id":"matcha","name":"Matcha","price":"5.000","emoji":"🍵","bg":const Color(0xFFF0FFF0),"short":"Earthy matcha cream inside soft mochi."},
    {"id":"choco","name":"Chocolate","price":"5.000","emoji":"🍫","bg":const Color(0xFFFFF8F0),"short":"Rich chocolate center — pure comfort."},
    {"id":"mango","name":"Mango","price":"5.500","emoji":"🥭","bg":const Color(0xFFFFFBE6),"short":"Tropical mango filling — juicy and bright."},
    {"id":"black_sesame","name":"Black Sesame","price":"5.200","emoji":"🌑","bg":const Color(0xFFF6F6F8),"short":"Nutty, slightly savory black sesame paste."},
    {"id":"taro","name":"Taro","price":"5.300","emoji":"🍠","bg":const Color(0xFFFFF0F8),"short":"Creamy taro goodness inside chewy mochi."},
    {"id":"yuzu","name":"Yuzu","price":"5.700","emoji":"🍋","bg":const Color(0xFFFFFCE6),"short":"Citrusy yuzu filling for a zesty surprise."},
    {"id":"blueberry","name":"Blueberry","price":"5.400","emoji":"🫐","bg":const Color(0xFFF0F8FF),"short":"Sweet-tart blueberry jam wrapped in mochi."},
  ];

  final List<Map<String, dynamic>> specialMochis = [
    {"id":"strawberry_daifuku","title":"Strawberry Daifuku","price":"5.000","emoji":"🍡","tags":["Sweet","Fruity","Soft"],"description":"Strawberry Daifuku features a fresh strawberry wrapped in red bean paste and soft mochi rice cake. Balanced and delightful.","reviews":[{"rating":5,"text":"Enak, teksturnya lembut banget!","author":"Ayu"}]},
    {"id":"mochi_bites","title":"Mochi Bites","price":"6.000","emoji":"🟤","tags":["Crunchy","Assorted","Snack"],"description":"Bite-sized mochi with assorted fillings: chocolate, matcha cream, caramel. Perfect for sharing.","reviews":[{"rating":5,"text":"Sempurna untuk cemilan.","author":"Citra"}]} ,
    {"id":"mochi_cheesecake","title":"Mochi Cheesecake","price":"8.500","emoji":"🧀","tags":["Creamy","Rich","Dessert"],"description":"Mochi Cheesecake: silky cheesecake filling wrapped in a thin mochi layer. A fusion dessert — creamy, slightly tangy, and delightfully chewy.","reviews":[{"rating":5,"text":"Kombinasi mochi + cheesecake bikin nagih!","author":"Ira"},{"rating":4,"text":"Lembut dan elegan, cocok untuk dessert spesial.","author":"Rian"}]},
  ];

  final List<Map<String, dynamic>> _categoryItems = [
    {'label': 'All', 'active': true},
    {'label': 'Sweet', 'active': false},
    {'label': 'Fruity', 'active': false},
    {'label': 'Ice', 'active': false},
    {'label': 'Snack', 'active': false},
  ];

  final Map<String, CartItem> _cart = {};
  final PageController _specialPageController = PageController(viewportFraction: 0.98);
  int _specialIndex = 0;

  // --- fetch experiment state (added)
  bool _isFetching = false;
  String _lastFetchMethod = '';
  int? _lastFetchMs;

  @override
  void dispose() {
    _specialPageController.dispose();
    super.dispose();
  }

  void _addToCartFromMap(Map<String, dynamic> itemMap, {int amount = 1}) {
    final id = itemMap['id'] as String? ?? (itemMap['name'] as String);
    setState(() {
      if (_cart.containsKey(id)) _cart[id]!.qty += amount;
      else _cart[id] = CartItem(id: id, name: itemMap['name'] ?? itemMap['title'], price: itemMap['price'].toString(), emoji: itemMap['emoji'] ?? '🍡', qty: amount);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${itemMap['name'] ?? itemMap['title']} ditambahkan ke keranjang."), duration: const Duration(milliseconds: 900)));
  }

  int _cartTotalQty() => _cart.values.fold(0, (s, e) => s + e.qty);

  void _openCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          minChildSize: 0.35,
          maxChildSize: 0.95,
          builder: (context, controller) {
            return Material(
              child: Column(children: [
                Container(height: 6, width: 60, margin: const EdgeInsets.only(top: 12), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(12))),
                SizedBox(height: rSize(context, 8)),
                Padding(padding: EdgeInsets.symmetric(horizontal: rSize(context, 16)), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Your Cart", style: TextStyle(fontSize: rFont(context, 18), fontWeight: FontWeight.bold)), Text("${_cartTotalQty()} items", style: TextStyle(color: Colors.grey.shade600))])),
                Expanded(
                  child: _cart.isEmpty
                      ? Center(child: Text("Keranjang kosong", style: TextStyle(fontSize: rFont(context, 14))))
                      : ListView.builder(
                          controller: controller,
                          itemCount: _cart.length,
                          itemBuilder: (_, idx) {
                            final item = _cart.values.toList()[idx];
                            return ListTile(
                              leading: CircleAvatar(child: Text(item.emoji)),
                              title: Text(item.name, style: TextStyle(fontSize: rFont(context, 14))),
                              subtitle: Text("Rp.${item.price} x ${item.qty}", style: TextStyle(fontSize: rFont(context, 13))),
                              trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                                IconButton(icon: Icon(Icons.remove_circle_outline, size: rSize(context, 20)), onPressed: () => setState(() => item.qty = (item.qty - 1 <= 0 ? 1 : item.qty - 1))),
                                Text('${item.qty}', style: TextStyle(fontSize: rFont(context, 14))),
                                IconButton(icon: Icon(Icons.add_circle_outline, size: rSize(context, 20)), onPressed: () => setState(() => item.qty++)),
                              ]),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(rSize(context, 16)),
                  child: Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Total", style: TextStyle(color: Colors.grey.shade600)), SizedBox(height: rSize(context, 6)), Text("Rp.${_cart.values.fold(0, (a, b) => a + (int.tryParse(b.price.replaceAll('.', '')) ?? 0) * b.qty)}", style: TextStyle(fontSize: rFont(context, 18), fontWeight: FontWeight.bold))])),
                    ElevatedButton(
                      onPressed: _cart.isEmpty ? null : () {
                        setState(() => _cart.clear());
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Pesanan berhasil (demo).")));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF85A7), padding: EdgeInsets.symmetric(vertical: rSize(context, 12), horizontal: rSize(context, 18))),
                      child: Text("Checkout", style: TextStyle(fontSize: rFont(context, 14))),
                    ),
                  ]),
                )
              ]),
            );
          },
        );
      },
    );
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
            constraints: BoxConstraints(maxWidth: maxSheetWidth, maxHeight: maxSheetHeight),
            child: Material(borderRadius: BorderRadius.circular(20), clipBehavior: Clip.antiAlias, child: MochiDetailSheet(mochi: mochi, initialTabIndex: reviewTab ? 1 : 0, onAddReview: (r) => setState(() => mochi['reviews'].add(r)), onAddToCart: (m) => _addToCartFromMap(m))),
          ),
        );

        if (kIsWeb || screen.width >= 700) return Padding(padding: EdgeInsets.symmetric(vertical: rSize(context, 24), horizontal: rSize(context, 16)), child: content);
        return DraggableScrollableSheet(expand: false, initialChildSize: 0.82, minChildSize: 0.5, maxChildSize: 0.95, builder: (context, controller) => Container(decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))), child: MochiDetailSheet(mochi: mochi, initialTabIndex: reviewTab ? 1 : 0, scrollController: controller, onAddReview: (r) => setState(() => mochi['reviews'].add(r)), onAddToCart: (m) => _addToCartFromMap(m))));
      },
    );
  }

  Widget _buildCategoryChip(String text, bool isActive, {VoidCallback? onTap}) {
    return Material(
      color: isActive ? const Color(0xFFFF85A7) : Colors.white,
      elevation: isActive ? 4 : 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(rSize(context, 24)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(rSize(context, 24)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: rSize(context, 18), vertical: rSize(context, 10)),
          constraints: BoxConstraints(minWidth: rSize(context, 72)),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: rFont(context, 12),
                fontWeight: FontWeight.w500,
                color: isActive ? Colors.white : Colors.grey.shade800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  // ====== Added: simulated fetch methods for experimentation ======
  Future<void> _fetchWithHttp() async {
    setState(() { _isFetching = true; _lastFetchMethod = 'HTTP (simulated)'; _lastFetchMs = null; });
    final sw = Stopwatch()..start();
    try {
      // Simulate network latency for HTTP (change to real http call if needed)
      await Future.delayed(const Duration(milliseconds: 420));
      sw.stop();
      setState(() { _lastFetchMs = sw.elapsedMilliseconds; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('HTTP fetch finished in ${_lastFetchMs} ms')));
      debugPrint('HTTP simulated fetch took: ${_lastFetchMs} ms');
    } catch (e) {
      sw.stop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('HTTP fetch failed: $e')));
      debugPrint('HTTP simulated fetch error: $e');
    } finally {
      setState(() { _isFetching = false; });
    }
  }

  Future<void> _fetchWithDio() async {
    setState(() { _isFetching = true; _lastFetchMethod = 'Dio (simulated)'; _lastFetchMs = null; });
    final sw = Stopwatch()..start();
    try {
      // Simulate (slightly faster) network latency for Dio (change to real dio call if needed)
      await Future.delayed(const Duration(milliseconds: 340));
      sw.stop();
      setState(() { _lastFetchMs = sw.elapsedMilliseconds; });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dio fetch finished in ${_lastFetchMs} ms')));
      debugPrint('Dio simulated fetch took: ${_lastFetchMs} ms');
    } catch (e) {
      sw.stop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Dio fetch failed: $e')));
      debugPrint('Dio simulated fetch error: $e');
    } finally {
      setState(() { _isFetching = false; });
    }
  }
  // ====== end added functions ======

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: RadialGradient(center: Alignment(-0.8, -0.8), radius: 1.2, colors: [Color(0xFFFFF7FC), Color(0xFFFFEEF6)])),
        child: SafeArea(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: rSize(context, 16), vertical: rSize(context, 10)),
              child: Row(children: [
                Expanded(
                  child: Text("Choose\nYour Favorite Mochi",
                      style: TextStyle(fontSize: rFont(context, 24), fontWeight: FontWeight.w700, color: const Color(0xFF8B4A58), height: 1.05)),
                ),
                Stack(children: [
                  IconButton(icon: Icon(Icons.shopping_bag_outlined, color: const Color(0xFF8B4A58), size: rSize(context, 26)), onPressed: _openCartSheet),
                  if (_cartTotalQty() > 0)
                    Positioned(right: rSize(context, 6), top: rSize(context, 6), child: Container(padding: EdgeInsets.all(rSize(context, 6)), decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(rSize(context, 12))), child: Text("${_cartTotalQty()}", style: TextStyle(color: Colors.white, fontSize: rFont(context, 12), fontWeight: FontWeight.bold)))),
                ]),
              ]),
            ),

            // ====== ADDED: Buttons for performance experiment ======
            Padding(
              padding: EdgeInsets.symmetric(horizontal: rSize(context, 16), vertical: rSize(context, 8)),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _isFetching ? null : _fetchWithHttp,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.pinkAccent),
                        child: const Text("Fetch via HTTP"),
                      ),
                      SizedBox(width: rSize(context, 10)),
                      ElevatedButton(
                        onPressed: _isFetching ? null : _fetchWithDio,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurpleAccent),
                        child: const Text("Fetch via Dio"),
                      ),
                    ],
                  ),
                  SizedBox(height: rSize(context, 8)),
                  // small status line
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isFetching) const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      SizedBox(width: rSize(context, 8)),
                      Text(
                        _lastFetchMethod.isEmpty ? 'Belum melakukan fetch' : 'Last: $_lastFetchMethod - ${_lastFetchMs != null ? '${_lastFetchMs} ms' : 'pending...'}',
                        style: TextStyle(fontSize: rFont(context, 12), color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ====== end added buttons ======

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: rSize(context, 16), vertical: rSize(context, 12)),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width > 900 ? 820 : double.infinity),
                      child: Container(
                        height: rSize(context, 48),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(rSize(context, 24)), boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))]),
                        child: Row(children: [
                          SizedBox(width: rSize(context, 12)),
                          Icon(Icons.search, color: const Color(0xFF8B4A58), size: rSize(context, 20)),
                          SizedBox(width: rSize(context, 10)),
                          Expanded(
                            child: TextField(style: TextStyle(fontSize: rFont(context, 13)), decoration: InputDecoration(hintText: "Search mochi...", hintStyle: TextStyle(fontSize: rFont(context, 13), color: Colors.grey.shade500), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(horizontal: rSize(context, 20), vertical: rSize(context, 12)))),
                          ),
                          SizedBox(width: rSize(context, 12)),
                        ]),
                      ),
                    ),
                  ),

                  SizedBox(height: rSize(context, 14)),

                  SizedBox(
                    height: rSize(context, 60),
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: rSize(context, 8)),
                      itemCount: _categoryItems.length,
                      separatorBuilder: (_, __) => SizedBox(width: rSize(context, 8)),
                      itemBuilder: (context, index) {
                        final item = _categoryItems[index];
                        return _buildCategoryChip(
                          item['label'] as String,
                          item['active'] as bool,
                          onTap: () {
                            setState(() {
                              for (var c in _categoryItems) c['active'] = false;
                              _categoryItems[index]['active'] = true;
                            });
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: rSize(context, 20)),

                  Text("Popular Mochi", style: TextStyle(fontSize: rFont(context, 18), fontWeight: FontWeight.bold, color: const Color(0xFF8B4A58))),
                  SizedBox(height: rSize(context, 12)),

                  if (screenWidth < 720)
                    SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [for (var it in popularMochis) ...[HoverMochiCard(item: it, onTap: () => _showDetailSheet(it), onAddToCart: (m) => _addToCartFromMap(m)), SizedBox(width: rSize(context, 12))]]))
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: screenWidth >= 1100 ? 4 : 3, crossAxisSpacing: rSize(context, 12), mainAxisSpacing: rSize(context, 12), childAspectRatio: 0.88),
                      itemCount: popularMochis.length,
                      itemBuilder: (_, idx) => HoverMochiCard(item: popularMochis[idx], onTap: () => _showDetailSheet(popularMochis[idx]), onAddToCart: (m) => _addToCartFromMap(m)),
                    ),

                  SizedBox(height: rSize(context, 20)),
                  Text("Special Mochi", style: TextStyle(fontSize: rFont(context, 18), fontWeight: FontWeight.bold, color: const Color(0xFF8B4A58))),
                  SizedBox(height: rSize(context, 12)),

                  // Vertical list of special mochi (scrolls with page)
                  Column(
                    children: [
                      for (final mochi in specialMochis) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: rSize(context, 8)),
                          child: InkWell(
                            onTap: () => _showDetailSheet(mochi, reviewTab: false),
                            borderRadius: BorderRadius.circular(rSize(context, 16)),
                            child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(rSize(context, 16)),
                                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, 6))],
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(rSize(context, 14)),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: rSize(context, 100),
                                          height: rSize(context, 100),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFFF0F5),
                                            borderRadius: BorderRadius.circular(rSize(context, 12)),
                                          ),
                                          child: Center(child: Text(mochi['emoji'] as String, style: TextStyle(fontSize: rFont(context, 36)))),
                                        ),
                                        SizedBox(width: rSize(context, 12)),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                mochi['title'] as String,
                                                style: TextStyle(fontSize: rFont(context, 16), fontWeight: FontWeight.bold, color: const Color(0xFF8B4A58)),
                                              ),
                                              SizedBox(height: rSize(context, 6)),
                                              Text("Rp.${mochi['price']}", style: TextStyle(fontSize: rFont(context, 14), color: const Color(0xFFFF85A7))),
                                              SizedBox(height: rSize(context, 8)),
                                              Wrap(
                                                spacing: rSize(context, 8),
                                                children: (mochi['tags'] as List).map<Widget>((t) => Container(
                                                  padding: EdgeInsets.symmetric(horizontal: rSize(context, 10), vertical: rSize(context, 6)),
                                                  decoration: BoxDecoration(color: const Color(0xFFFFF0F5), borderRadius: BorderRadius.circular(rSize(context, 12))),
                                                  child: Text(t, style: TextStyle(fontSize: rFont(context, 11), color: const Color(0xFF8B4A58))),
                                                )).toList(),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: rSize(context, 16), vertical: rSize(context, 10)),
                                    child: Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            mochi['description'] as String,
                                            style: TextStyle(color: Colors.grey, fontSize: rFont(context, 13), height: 1.4),
                                          ),
                                        ),
                                        SizedBox(height: rSize(context, 12)),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () => _showDetailSheet(mochi, reviewTab: false),
                                                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF85A7)),
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(vertical: rSize(context, 12)),
                                                  child: Text("Details", style: TextStyle(fontSize: rFont(context, 13))),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: rSize(context, 12)),
                                            OutlinedButton(
                                              onPressed: () => _addToCartFromMap(mochi),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: rSize(context, 12), horizontal: rSize(context, 12)),
                                                child: Text("Add", style: TextStyle(fontSize: rFont(context, 13))),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: rSize(context, 12)),
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
                ]),
              ),
            ),
          ]),
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
  final ScrollController? scrollController;
  const MochiDetailSheet({Key? key, required this.mochi, this.initialTabIndex = 0, this.onAddReview, this.onAddToCart, this.scrollController}) : super(key: key);
  @override
  State<MochiDetailSheet> createState() => _MochiDetailSheetState();
}

class _MochiDetailSheetState extends State<MochiDetailSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _reviewTextController = TextEditingController();
  int _selectedRating = 5;
  PageController? _reviewsPageController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initialTabIndex);
    _reviewsPageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _reviewTextController.dispose();
    _reviewsPageController?.dispose();
    super.dispose();
  }

  void _addReview() {
    final text = _reviewTextController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Tulis review dulu.")));
      return;
    }
    final newReview = {"rating": _selectedRating, "text": text, "author": "You"};
    setState(() => widget.mochi['reviews'].add(newReview));
    widget.onAddReview?.call(newReview);
    _reviewTextController.clear();
    _selectedRating = 5;
    _tabController.animateTo(1);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Review ditambahkan.")));
  }

  Widget _buildReviewCard(Map r) {
    final int rating = r['rating'] as int;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: rSize(context, 12), vertical: rSize(context, 10)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(rSize(context, 12))),
      child: Padding(
        padding: EdgeInsets.all(rSize(context, 12)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(backgroundColor: Colors.grey.shade200, child: Text((r['author'] as String).substring(0, 1).toUpperCase())),
            SizedBox(width: rSize(context, 10)),
            Text(r['author'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: rFont(context, 14))),
            const Spacer(),
            Row(children: [for (int i = 0; i < rating; i++) Icon(Icons.star, size: rSize(context, 14), color: const Color(0xFFFFB6C1)), for (int i = rating; i < 5; i++) Icon(Icons.star_border, size: rSize(context, 14), color: Colors.grey.shade300)])
          ]),
          SizedBox(height: rSize(context, 8)),
          Text(r['text'], style: TextStyle(fontSize: rFont(context, 13))),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mochi = widget.mochi;
    final List<Map<String, dynamic>> reviews = List<Map<String, dynamic>>.from(mochi['reviews'] as List);
    final Size screen = MediaQuery.of(context).size;
    final bool isWide = screen.width >= 900;

    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(children: [
        SizedBox(height: rSize(context, 8)),
        Container(width: rSize(context, 40), height: rSize(context, 4), margin: EdgeInsets.only(top: rSize(context, 6)), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(rSize(context, 8)))),
        Padding(padding: EdgeInsets.symmetric(horizontal: rSize(context, 16), vertical: rSize(context, 8)), child: Row(children: [
          Container(width: isWide ? rSize(context, 140) : rSize(context, 100), height: isWide ? rSize(context, 140) : rSize(context, 100), decoration: BoxDecoration(color: const Color(0xFFFFF0F5), borderRadius: BorderRadius.circular(rSize(context, 12))), child: Center(child: Text(mochi['emoji'] as String, style: TextStyle(fontSize: rFont(context, isWide ? 40 : 32))))),
          SizedBox(width: rSize(context, 12)),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(mochi['title'] ?? mochi['name'] as String, style: TextStyle(fontSize: rFont(context, 18), fontWeight: FontWeight.bold, color: const Color(0xFF8B4A58))),
            SizedBox(height: rSize(context, 6)),
            Text("Rp.${mochi['price']}", style: TextStyle(fontSize: rFont(context, 14), color: const Color(0xFFFF85A7))),
            SizedBox(height: rSize(context, 8)),
            Wrap(spacing: rSize(context, 8), children: ((mochi['tags'] ?? []) as List).map<Widget>((t) => Container(padding: EdgeInsets.symmetric(horizontal: rSize(context, 10), vertical: rSize(context, 6)), decoration: BoxDecoration(color: const Color(0xFFFFF0F5), borderRadius: BorderRadius.circular(rSize(context, 12))), child: Text(t, style: TextStyle(fontSize: rFont(context, 11), color: const Color(0xFF8B4A58))))).toList())
          ])),
        ])),
        TabBar(controller: _tabController, labelColor: const Color(0xFFFF85A7), unselectedLabelColor: Colors.grey, indicatorColor: const Color(0xFFFF85A7), tabs: [Tab(child: Text("Details", style: TextStyle(fontSize: rFont(context, 14)))), Tab(child: Text("Reviews", style: TextStyle(fontSize: rFont(context, 14))))]),

        Expanded(
          child: SafeArea(
            child: TabBarView(
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  padding: EdgeInsets.all(rSize(context, 16)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mochi['description'] ?? mochi['short'] ?? "",
                        style: TextStyle(color: Colors.grey, fontSize: rFont(context, 13), height: 1.4),
                      ),
                      SizedBox(height: rSize(context, 18)),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () => widget.onAddToCart?.call(mochi),
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF85A7), padding: EdgeInsets.symmetric(vertical: rSize(context, 12))),
                              child: Text("Add to cart", style: TextStyle(fontSize: rFont(context, 13))),
                            ),
                          ),
                          SizedBox(width: rSize(context, 12)),
                          OutlinedButton(
                            onPressed: () => _tabController.animateTo(1),
                            child: Padding(padding: EdgeInsets.symmetric(vertical: rSize(context, 12), horizontal: rSize(context, 10)), child: Text("Reviews", style: TextStyle(fontSize: rFont(context, 13)))),
                          ),
                        ],
                      ),
                      SizedBox(height: rSize(context, 12)),
                    ],
                  ),
                ),

                Column(
                  children: [
                    if (reviews.isNotEmpty)
                      SizedBox(
                        height: isWide ? rSize(context, 180) : rSize(context, 140),
                        child: PageView.builder(
                          controller: _reviewsPageController,
                          itemCount: reviews.length,
                          itemBuilder: (_, idx) => _buildReviewCard(reviews[idx]),
                        ),
                      ),

                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: rSize(context, 8)),
                        child: ListView.separated(
                          itemBuilder: (_, i) => _buildReviewCard(reviews[i]),
                          separatorBuilder: (_, __) => SizedBox(height: rSize(context, 8)),
                          itemCount: reviews.length,
                          physics: const AlwaysScrollableScrollPhysics(),
                        ),
                      ),
                    ),

                    SafeArea(
                      top: false,
                      child: Padding(
                        padding: EdgeInsets.all(rSize(context, 12)),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: rSize(context, 10)),
                              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(rSize(context, 12))),
                              child: DropdownButton<int>(
                                value: _selectedRating,
                                underline: const SizedBox(),
                                items: [5, 4, 3, 2, 1].map((r) => DropdownMenuItem(value: r, child: Text("$r ★"))).toList(),
                                onChanged: (v) => setState(() => _selectedRating = v ?? 5),
                              ),
                            ),
                            SizedBox(width: rSize(context, 8)),
                            Expanded(
                              child: TextField(
                                controller: _reviewTextController,
                                decoration: InputDecoration(
                                  hintText: "Tulis review...",
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                  contentPadding: EdgeInsets.symmetric(horizontal: rSize(context, 12), vertical: rSize(context, 10)),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(rSize(context, 12)), borderSide: BorderSide.none),
                                ),
                              ),
                            ),
                            SizedBox(width: rSize(context, 8)),
                            ElevatedButton(
                              onPressed: _addReview,
                              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF85A7)),
                              child: Text("Kirim", style: TextStyle(fontSize: rFont(context, 14))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
