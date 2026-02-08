import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class InvoicePdf {
  static Future<void> preview({
    required String invoiceId,
    required String status,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    required int total,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'INVOICE',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text('ID: $invoiceId'),
              pw.Text('Status: ${status.toUpperCase()}'),
              pw.Text('Pembayaran: $paymentMethod'),

              pw.Divider(height: 32),

              pw.Text(
                'Rincian Pesanan',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 12),

              pw.Table.fromTextArray(
                headers: ['Item', 'Qty', 'Harga'],
                data: items.map((e) {
                  return [e['name'], e['qty'].toString(), 'Rp ${e['price']}'];
                }).toList(),
              ),

              pw.Divider(height: 32),

              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total: Rp $total',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    // 🔥 INI YANG FIX
    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }
}
