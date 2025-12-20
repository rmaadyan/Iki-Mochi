import 'package:flutter/material.dart';
import '../../../core/values/app_colors.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About Us'), centerTitle: true),
      body: Padding(
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
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 12),

            // 🟣 DESCRIPTION
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Iki Mochi adalah aplikasi pemesanan mochi dengan pendekatan desain yang sederhana, manis, dan fokus pada pengalaman pengguna.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 🟣 CREDITS TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Credits',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // 🟣 CREDITS CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _CreditItem('Product & Developer', 'rmaadyn'),
                      _CreditItem('UI / UX Design', 'Iki Mochi Team'),
                      _CreditItem('Backend & API', 'Supabase'),

                      Divider(height: 24),

                      _CreditItem('Lead Developer','Muhammad Parama Adyan'),
                      _CreditItem('Designer','Berliana Diva Rose'),
                      _CreditItem('Project Manager','Haitsam Dzaki Dasiyanto'),
                      _CreditItem('Marketing','Muhammad Rakan Syahputra'),
                      _CreditItem('Backend Developer','Aglifah Alfarabi Basri'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreditRow extends StatelessWidget {
  final String role;
  final String name;

  const _CreditRow({required this.role, required this.name});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.circle, size: 8, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                TextSpan(
                  text: '$role: ',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: name),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CreditItem extends StatelessWidget {
  final String title;
  final String value;

  const _CreditItem(this.title, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 18,
              height: 1.2,
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
