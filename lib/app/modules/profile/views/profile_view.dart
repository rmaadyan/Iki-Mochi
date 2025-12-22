import '../../../data/services/supabase_service.dart';
import '../../../routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/theme_toggle_service.dart';
import '../../profile/views/about_us_view.dart';
import '../../../core/utils/whatsapp_launcher.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeService = Get.find<ThemeToggleService>();
    final supabaseService = Get.find<SupabaseService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final user = supabaseService.currentUser;
    final email = user?.email ?? 'unknown@user';
    final displayName = user?.userMetadata?['name'] ?? 'User';
    final avatarLetter = email.isNotEmpty ? email[0].toUpperCase() : 'U';

    return Scaffold(
      body: Container(
        width: double.infinity,
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
              SizedBox(height: 24),

              // === AVATAR ===
              CircleAvatar(
                radius: 44,
                backgroundColor: const Color(0xFFFF85A7),
                child: Text(
                  avatarLetter,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),

              SizedBox(height: 16),

              // === USER NAME ===
              Text(
                displayName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF8B4A58),
                ),
              ),

              SizedBox(height: 4),

              Text(
                email,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),

              SizedBox(height: 32),

              // === MENU CARD ===
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _ProfileItem(
                      icon: Icons.history,
                      label: 'Order History',
                      onTap: () {
                        Get.to(() => const OrderHistoryView());
                      },
                    ),
                    _ProfileItem(
                      icon: Icons.person_3_outlined,
                      label: 'About us',
                      onTap: () {
                        Get.to(() => const AboutUsView());
                      },
                    ),

                    _ProfileItem(
                      icon: Icons.support_agent, // atau Icons.support_agent
                      label: 'Contact Us',
                      onTap: () {
                        openWhatsApp(
                          phone: '6281250337130',
                          message:
                              'Halo Admin Iki Mochi 👋\n'
                              'Saya butuh bantuan terkait pesanan.\n\n'
                              'Email: $email',
                        );
                      },
                    ),

                    _ProfileItem(
                      icon: Icons.logout,
                      label: 'Logout',
                      onTap: () async {
                        final supabase = Get.find<SupabaseService>();

                        await supabase.signOut();

                        Get.offAllNamed(Routes.LOGIN);
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // === THEME TOGGLE INFO ===
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    themeService.isDark.value
                        ? 'Dark Mode Active'
                        : 'Light Mode Active',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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

class OrderHistoryView extends StatelessWidget {
  const OrderHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Get.find<SupabaseService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Order History')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: supabase.getOrderHistory(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return const Center(child: Text('Belum ada pesanan'));
          }

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (_, i) {
              final order = orders[i];
              final items = order['order_items'] as List;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(
                    'Order #${order['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${items.length} item • Rp.${order['total_price']}',
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ProfileItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFFFF85A7)),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
