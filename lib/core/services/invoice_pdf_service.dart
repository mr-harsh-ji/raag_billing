import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../database/app_database.dart';

class InvoicePdfService {
  static Future<Uint8List> generateInvoicePdf({
    required Invoice invoice,
    required List<InvoiceItem> items,
    required Customer? customer,
    required BusinessProfileData business,
    required AppSettingsData settings,
    List<Product>? products,
  }) async {
    final pdf = pw.Document();
    final String shopCategory = business.shopCategory;
    final bool isJewellery = shopCategory == 'Jewellery';
    final bool isPharmacy = shopCategory == 'Pharmacy';
    final String gstinDisplay = settings.hideGstin ? 'HIDDEN' : (business.gstin ?? '');
    
    pw.MemoryImage? logoImage;
    try {
      if (business.logoPath != null && File(business.logoPath!).existsSync()) {
        final bytes = await File(business.logoPath!).readAsBytes();
        logoImage = pw.MemoryImage(bytes);
      } else {
        // Fallback to default asset logo
        final byteData = await rootBundle.load('assets/images/Raag Billing.png');
        final bytes = byteData.buffer.asUint8List();
        logoImage = pw.MemoryImage(bytes);
      }
    } catch (e) {
      print('Error loading logo for PDF: $e');
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.black, width: 1),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Title
                  pw.Container(
                    width: double.infinity,
                    alignment: pw.Alignment.center,
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(bottom: pw.BorderSide(color: PdfColors.black, width: 1)),
                    ),
                    child: pw.Text('GST INVOICE', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                  ),

                  // Header
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        if (logoImage != null)
                          pw.Image(logoImage, width: 60, height: 60)
                        else
                          pw.SizedBox(width: 60),

                        pw.Column(
                          children: [
                            pw.Text(business.name, style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
                            if (business.address != null) pw.Text(business.address!, style: const pw.TextStyle(fontSize: 8)),
                            pw.Text('Contact: ${business.phone ?? ''} | GSTIN: $gstinDisplay', style: const pw.TextStyle(fontSize: 8)),
                          ],
                        ),
                        if (isJewellery)
                          _buildHallmarkLogo()
                        else
                          pw.SizedBox(width: 60),
                      ],
                    ),
                  ),
                  pw.Divider(thickness: 1, color: PdfColors.black, height: 0),

                  // Details
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: PdfColors.black, width: 1))),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Details of Receiver | Billed to:', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.grey700)),
                              pw.SizedBox(height: 4),
                              pw.Text(customer?.name ?? 'Walk-in Customer', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                              if (customer?.address != null) pw.Text(customer!.address!, style: const pw.TextStyle(fontSize: 8)),
                              if (customer?.phone != null) pw.Text('Contact: ${customer!.phone}', style: const pw.TextStyle(fontSize: 8)),
                            ],
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              _buildDetailRow('Invoice No', ': ${invoice.invoiceNumber}'),
                              _buildDetailRow('Date', ': ${DateFormat('dd/MM/yyyy hh:mm a').format(invoice.date)}'),
                              _buildDetailRow('Mode', ': ${invoice.paymentMethod}'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(thickness: 1, color: PdfColors.black, height: 0),

                  // Table
                  if (isJewellery)
                    _buildJewelleryTable(items)
                  else if (isPharmacy)
                    _buildPharmacyTable(items)
                  else
                    _buildGeneralTable(items, business.currencySymbol),

                  // Footer Section
                  pw.Divider(thickness: 1, color: PdfColors.black, height: 0),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          decoration: const pw.BoxDecoration(border: pw.Border(right: pw.BorderSide(color: PdfColors.black, width: 1))),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('Bank Details:', style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                              pw.Text('Bank: ${business.bankName ?? ''}', style: const pw.TextStyle(fontSize: 7)),
                              pw.Text('A/C: ${business.accountNumber ?? ''}', style: const pw.TextStyle(fontSize: 7)),
                              pw.Text('IFSC: ${business.ifscCode ?? ''}', style: const pw.TextStyle(fontSize: 7)),
                              pw.SizedBox(height: 10),
                              if (business.upiId != null) 
                                pw.Row(
                                  children: [
                                    pw.BarcodeWidget(
                                      barcode: pw.Barcode.qrCode(),
                                      data: 'upi://pay?pa=${business.upiId}&pn=${business.name}&am=${invoice.grandTotal}&cu=INR',
                                      width: 40,
                                      height: 40,
                                    ),
                                    pw.SizedBox(width: 8),
                                    pw.Text('Scan to Pay', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Container(
                          padding: const pw.EdgeInsets.all(4),
                          child: pw.Column(
                            children: [
                              _buildSummaryRow('Taxable Value', invoice.subtotal),
                              _buildSummaryRow('CGST', (invoice.cgst ?? 0)),
                              _buildSummaryRow('SGST', (invoice.sgst ?? 0)),
                              if (invoice.discountAmount > 0) _buildSummaryRow('Discount', -invoice.discountAmount),
                              _buildSummaryRow('Round Off', (invoice.roundOff ?? 0)),
                              pw.Divider(thickness: 1, color: PdfColors.black),
                              _buildSummaryRow('Total Amount', invoice.grandTotal, isBold: true, fontSize: 10),
                              pw.Divider(thickness: 0.5, color: PdfColors.black, height: 4),
                              _buildSummaryRow('Paid Amount', invoice.paidAmount),
                              _buildSummaryRow('Due Amount', invoice.dueAmount, isBold: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(thickness: 1, color: PdfColors.black, height: 0),

                  // Amount in Words
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: pw.Text('Amount in words: ${_numberToWords(invoice.grandTotal)}', 
                        style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.Divider(thickness: 1, color: PdfColors.black, height: 0),
                  
                  // Bottom Notes
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(8),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Terms & Conditions:', style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold)),
                                if (business.termsAndConditions != null)
                                  ...business.termsAndConditions!.split('\n').map((line) => pw.Text(line, style: const pw.TextStyle(fontSize: 6)))
                                else ...[
                                  pw.Text('• Goods once sold will not be taken back.', style: const pw.TextStyle(fontSize: 6)),
                                  pw.Text('• All disputes subject to local jurisdiction.', style: const pw.TextStyle(fontSize: 6)),
                                ],
                              ],
                            ),
                            pw.Column(
                              children: [
                                pw.Text('For ${business.name}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8)),
                                pw.SizedBox(height: 20),
                                pw.Text('Authorised Signatory', style: const pw.TextStyle(fontSize: 7)),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 10),
                        pw.Text(settings.thankYouNote, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, fontStyle: pw.FontStyle.italic)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        children: [
          pw.SizedBox(width: 50, child: pw.Text(label, style: const pw.TextStyle(fontSize: 8))),
          pw.Text(value, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
        ],
      ),
    );
  }

  static pw.Widget _buildJewelleryTable(List<InvoiceItem> items) {
    return pw.TableHelper.fromTextArray(
      headers: ['#', 'Product', 'HSN', 'Purity', 'Weight', 'Stone', 'Mkg. Chg.', 'Net Wt', 'Rate', 'Taxable', 'GST%', 'GST Amt', 'Total'],
      data: items.asMap().entries.map((entry) {
        final i = entry.key + 1;
        final item = entry.value;
        final gstAmt = item.total - (item.taxableValue ?? 0);
        return [
          i.toString(),
          item.productName,
          item.hsnCode ?? '',
          item.purity ?? '',
          item.grossWeight?.toStringAsFixed(3) ?? '',
          item.stoneWeight?.toStringAsFixed(3) ?? '0',
          item.makingCharges?.toStringAsFixed(2) ?? '0',
          item.netWeight?.toStringAsFixed(3) ?? '',
          item.rate?.toStringAsFixed(2) ?? '',
          (item.taxableValue ?? 0).toStringAsFixed(2),
          '${item.taxPercentage}%',
          gstAmt.toStringAsFixed(2),
          item.total.toStringAsFixed(2),
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6),
      cellStyle: const pw.TextStyle(fontSize: 6),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
        9: pw.Alignment.centerRight,
        10: pw.Alignment.centerRight,
        11: pw.Alignment.centerRight,
        12: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildGeneralTable(List<InvoiceItem> items, String currency) {
    return pw.TableHelper.fromTextArray(
      headers: ['#', 'Product', 'Qty', 'Rate', 'Taxable', 'GST%', 'GST Amt', 'Total'],
      data: items.asMap().entries.map((entry) {
        final i = entry.key + 1;
        final item = entry.value;
        final taxable = item.unitPrice * item.quantity;
        final gstAmt = item.total - taxable;
        return [
          i.toString(),
          item.productName,
          item.quantity.toString(),
          item.unitPrice.toStringAsFixed(2),
          taxable.toStringAsFixed(2),
          '${item.taxPercentage}%',
          gstAmt.toStringAsFixed(2),
          item.total.toStringAsFixed(2),
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
      cellStyle: const pw.TextStyle(fontSize: 8),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.centerRight,
        3: pw.Alignment.centerRight,
        4: pw.Alignment.centerRight,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildPharmacyTable(List<InvoiceItem> items) {
    return pw.TableHelper.fromTextArray(
      headers: ['#', 'Product', 'Batch', 'MFG', 'EXP', 'Qty', 'Rate', 'Taxable', 'GST%', 'Total'],
      data: items.asMap().entries.map((entry) {
        final i = entry.key + 1;
        final item = entry.value;
        final taxable = item.unitPrice * item.quantity;
        return [
          i.toString(),
          item.productName,
          item.batchNumber ?? '',
          item.manufacturingDate != null ? DateFormat('MM/yy').format(item.manufacturingDate!) : '',
          item.expiryDate != null ? DateFormat('MM/yy').format(item.expiryDate!) : '',
          item.quantity.toString(),
          item.unitPrice.toStringAsFixed(2),
          taxable.toStringAsFixed(2),
          '${item.taxPercentage}%',
          item.total.toStringAsFixed(2),
        ];
      }).toList(),
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
      cellStyle: const pw.TextStyle(fontSize: 7),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey200),
      border: pw.TableBorder.all(color: PdfColors.black, width: 0.5),
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.centerLeft,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.centerRight,
        6: pw.Alignment.centerRight,
        7: pw.Alignment.centerRight,
        8: pw.Alignment.centerRight,
        9: pw.Alignment.centerRight,
      },
    );
  }

  static pw.Widget _buildSummaryRow(String label, double value, {bool isBold = false, double fontSize = 8}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: fontSize)),
          pw.Text(value.toStringAsFixed(2), style: pw.TextStyle(fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal, fontSize: fontSize)),
        ],
      ),
    );
  }

  static pw.Widget _buildHallmarkLogo() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(2),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 0.5),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Container(
                width: 12,
                height: 10,
                child: pw.CustomPaint(
                  painter: (PdfGraphics canvas, PdfPoint size) {
                    canvas.moveTo(size.x / 2, size.y);
                    canvas.lineTo(0, 0);
                    canvas.lineTo(size.x, 0);
                    canvas.closePath();
                    canvas.setStrokeColor(PdfColors.black);
                    canvas.strokePath();
                  },
                ),
              ),
              pw.Text('BIS', style: pw.TextStyle(fontSize: 4, fontWeight: pw.FontWeight.bold)),
            ],
          ),
          pw.SizedBox(width: 4),
          pw.VerticalDivider(width: 1, thickness: 0.5, color: PdfColors.black),
          pw.SizedBox(width: 4),
          pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('HALLMARKED', style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold)),
              pw.Text('JEWELLERY', style: const pw.TextStyle(fontSize: 5)),
            ],
          ),
        ],
      ),
    );
  }

  static String _numberToWords(double amount) {
    if (amount == 0) return "Zero Rupees Only";
    
    final wholeAmount = amount.floor();
    final fraction = ((amount - wholeAmount) * 100).round();
    
    String words = '${_convertToWords(wholeAmount)} Rupees';
    if (fraction > 0) {
      words += ' and ${_convertToWords(fraction)} Paise';
    }
    return '$words Only';
  }

  static String _convertToWords(int number) {
    if (number == 0) return "";
    
    const units = ["", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"];
    const tens = ["", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eighty", "Ninety"];
    
    if (number < 20) return units[number];
    if (number < 100) return tens[number ~/ 10] + (number % 10 != 0 ? " " + units[number % 10] : "");
    if (number < 1000) return units[number ~/ 100] + " Hundred" + (number % 100 != 0 ? " and " + _convertToWords(number % 100) : "");
    if (number < 100000) return _convertToWords(number ~/ 1000) + " Thousand" + (number % 1000 != 0 ? " " + _convertToWords(number % 1000) : "");
    if (number < 10000000) return _convertToWords(number ~/ 100000) + " Lakh" + (number % 100000 != 0 ? " " + _convertToWords(number % 100000) : "");
    return _convertToWords(number ~/ 10000000) + " Crore" + (number % 10000000 != 0 ? " " + _convertToWords(number % 10000000) : "");
  }

  static Future<void> printInvoice(Invoice invoice, List<InvoiceItem> items, Customer? customer, BusinessProfileData business, AppSettingsData settings, {List<Product>? products}) async {
    final pdfBytes = await generateInvoicePdf(invoice: invoice, items: items, customer: customer, business: business, settings: settings, products: products);
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfBytes, name: 'Invoice_${invoice.invoiceNumber}');
  }

  static Future<void> shareInvoice(Invoice invoice, List<InvoiceItem> items, Customer? customer, BusinessProfileData business, AppSettingsData settings, {List<Product>? products}) async {
    final pdfBytes = await generateInvoicePdf(invoice: invoice, items: items, customer: customer, business: business, settings: settings, products: products);
    await Printing.sharePdf(bytes: pdfBytes, filename: 'invoice_${invoice.invoiceNumber}.pdf');
  }
}
