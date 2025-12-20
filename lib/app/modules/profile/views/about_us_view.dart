import 'package:flutter/material.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 24),

            // 🟣 LOGO
            Image.asset(
              'assets/images/mochi_logo.png',
              width: 120,
              height: 120,
            ),

            const SizedBox(height: 16),

            // 🟣 APP NAME
            Text(
              'Iki Mochi',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: cs.primary,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            // 🟣 DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Iki Mochi adalah aplikasi pemesanan mochi dengan pendekatan desain yang sederhana, manis, dan fokus pada pengalaman pengguna.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: cs.onSurface.withOpacity(0.75),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 🟣 CREDITS TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Credits',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: cs.onSurface,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🟣 CREDITS CARD
            Card(
              color: cs.surface,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    creditItem(context, 'Product & Developer', 'rmaadyn'),
                    creditItem(context, 'UI / UX Design', 'Iki Mochi Team'),
                    creditItem(context, 'Backend & API', 'Supabase'),

                    const Divider(height: 28),

                    Text(
                      'Thanks to all members!',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 12),

                    creditItem(
                      context,
                      'Lead Developer',
                      'Muhammad Parama Adyan',
                    ),
                    creditItem(
                      context,
                      'Designer',
                      'Berliana Diva Rose',
                    ),
                    creditItem(
                      context,
                      'Project Manager',
                      'Haitsam Dzaki Dasiyanto',
                    ),
                    creditItem(
                      context,
                      'Marketing',
                      'Muhammad Rakan Syahputra',
                    ),
                    creditItem(
                      context,
                      'Backend Developer',
                      'Aglifah Alfarabi Basri',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 🔹 Credit Item (theme-aware)
Widget creditItem(BuildContext context, String role, String name) {
  final theme = Theme.of(context);
  final cs = theme.colorScheme;

  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.circle,
          size: 6,
          color: cs.primary,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color: cs.onSurface,
              ),
              children: [
                TextSpan(
                  text: '$role: ',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextSpan(text: name),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
