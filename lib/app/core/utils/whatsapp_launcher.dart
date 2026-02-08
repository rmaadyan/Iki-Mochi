import 'package:url_launcher/url_launcher.dart';

Future<void> openWhatsApp({
  required String phone,
  required String message,
}) async {
  final encodedMessage = Uri.encodeComponent(message);
  final url = Uri.parse('https://wa.me/$phone?text=$encodedMessage');

  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Tidak bisa membuka WhatsApp';
  }
}
