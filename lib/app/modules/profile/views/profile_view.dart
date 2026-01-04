import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/services/supabase_service.dart';
import '../../../data/services/theme_toggle_service.dart';
import '../../../routes/app_pages.dart';

import '../../profile/views/about_us_view.dart';
import '../../favorite/views/favorite_view.dart';
import '../../admin/views/admin_order_view.dart';
import '../../profile/views/order_history_view.dart';

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

    return FutureBuilder<String>(
      future: supabaseService.getUserRole(),
      builder: (context, snapshot) {
        final role = snapshot.data ?? 'user';
        final isAdmin = role == 'admin';

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
                  const SizedBox(height: 24),

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

                  const SizedBox(height: 16),

                  // === NAME ===
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF8B4A58),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  // === ROLE BADGE ===
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isAdmin
                          ? Colors.green.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isAdmin ? 'Admin' : 'User',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isAdmin ? Colors.green : Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // === MENU ===
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        ProfileItem(
                          icon: Icons.history,
                          label: 'Order History',
                          onTap: () => Get.to(() => const OrderHistoryView()),
                        ),

                        ProfileItem(
                          icon: Icons.favorite,
                          label: 'Favorite',
                          onTap: () => Get.to(() => const FavoriteView()),
                        ),

                        ProfileItem(
                          icon: Icons.person_3_outlined,
                          label: 'About us',
                          onTap: () => Get.to(() => const AboutUsView()),
                        ),

                        ProfileItem(
                          icon: Icons.support_agent,
                          label: 'Contact Us',
                          onTap: () {
                            openWhatsApp(
                              phone: '6281250337130',
                              message:
                                  'Halo Admin Iki Mochi 👋\nSaya butuh bantuan.\n\nEmail: $email',
                            );
                          },
                        ),

                        // === ADMIN ONLY ===
                        if (isAdmin)
                          ProfileItem(
                            icon: Icons.admin_panel_settings,
                            label: 'Admin Orders',
                            onTap: () => Get.to(() => const AdminOrderView()),
                          ),

                        ProfileItem(
                          icon: Icons.logout,
                          label: 'Logout',
                          onTap: () async {
                            await supabaseService.signOut();
                            Get.offAllNamed(Routes.LOGIN);
                          },
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        themeService.isDark.value
                            ? 'Dark Mode Active'
                            : 'Light Mode Active',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class ProfileItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ProfileItem({
    super.key,
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
