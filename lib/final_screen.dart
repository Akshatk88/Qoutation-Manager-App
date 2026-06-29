import 'dart:io';
import 'dart:typed_data';


import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart' show rootBundle;


class FinalScreen extends StatelessWidget {
  final String qtnNumber;
  final String customerName;
  final String customerContact;
  final String customerAddress;

  final double baseAmount;
  final int totalCuvettes;
  final double cuvetteAmount;
  final double finalAmount;
  final double grandTotal;

  const FinalScreen({
    Key? key,
    required this.qtnNumber,
    required this.customerName,
    required this.customerContact,
    required this.customerAddress,
    required this.baseAmount,
    required this.totalCuvettes,
    required this.cuvetteAmount,
    required this.finalAmount,
    required this.grandTotal,
  }) : super(key: key);

  pw.Widget tableCell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(fontSize: 10),
      ),
    );
  }


  Future<Uint8List> generatePdf() async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final date = "${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}";

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (context) {
          return [
            // HEADER
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "CUTTING EDGE MEDICAL DEVICES PVT. LTD.",
                    style: pw.TextStyle(
                      fontSize: 16,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "An ISO 13485:2016 Certified Medical Device Company",
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text("www.cemd.in"),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Regd. Office: E-2406, Sudama Nagar, Indore, MP",
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "Works: Electronics Complex Industrial Area, Pardeshipura, Indore",
                    textAlign: pw.TextAlign.center,
                  ),
                  pw.Text(
                    "Mob: 6261824078 | info@cemd.in",
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Quotation Number : $qtnNumber",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  "Date : $date",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
            pw.SizedBox(height: 15),

            pw.Center(
              child: pw.Text(
                "QUOTATION",
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 15),

            pw.Text("To,"),
            pw.SizedBox(height: 5),
            pw.Text(
              customerName,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(customerAddress),
            pw.Text(customerContact),
            pw.SizedBox(height: 15),

            pw.Text("Ref: Quotation for the SCINTIGLO SG-100 with proprietary consumables"),
            pw.SizedBox(height: 20),

            // TABLE
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.black),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    tableCell("S.No"),
                    tableCell("Item Name"),
                    tableCell("Quantity"),
                    tableCell("Amount"),
                  ],
                ),
                pw.TableRow(
                  children: [
                    tableCell("1"),
                    tableCell("SCINTIGLO SG-100 Device"),
                    tableCell("1"),
                    tableCell("₹ ${baseAmount.toStringAsFixed(2)}"),
                  ],
                ),
                pw.TableRow(
                  children: [
                    tableCell("2"),
                    tableCell("Consumables / Cuvettes"),
                    tableCell(totalCuvettes.toString()),
                    tableCell("₹ ${finalAmount.toStringAsFixed(2)}"),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // TOTAL SECTION
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Container(
                width: 250,
                child: pw.Column(
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Device Amount"),
                        pw.Text("₹ ${baseAmount.toStringAsFixed(2)}"),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Cuvette Amount"),
                        pw.Text("₹ ${finalAmount.toStringAsFixed(2)}"),
                      ],
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Total Cuvettes"),
                        pw.Text(totalCuvettes.toString()),
                      ],
                    ),
                    pw.Divider(),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          "GRAND TOTAL",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          "₹ ${grandTotal.toStringAsFixed(2)}",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            pw.SizedBox(height: 25),

            // TERMS & CONDITIONS
            pw.Text(
              "Terms & Conditions",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Bullet(text: "Order can be fulfilled only after 100% advance payment."),
            pw.Bullet(text: "Offer valid for 15 days from issue of quotation."),
            pw.Bullet(text: "Product shall be delivered within 15 days of acceptance."),
            pw.Bullet(text: "Training and installation support will be provided."),
            pw.Bullet(text: "Transportation charges will be charged as applicable."),
            pw.SizedBox(height: 40),

            // SIGNATURE
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    "Regards",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text("Cutting Edge Medical Devices Pvt. Ltd."),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Summary"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quotation No: $qtnNumber"),
            Text("Customer Name: $customerName"),
            Text("Contact: $customerContact"),
            Text("Address: $customerAddress"),
            const SizedBox(height: 20),
            Text("Total Cuvettes: $totalCuvettes"),
            Text("Cuvette Amount: ₹$cuvetteAmount"),
            Text("Final Amount: ₹$finalAmount"),
            Text("Grand Total: ₹$grandTotal"),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final pdf = await generatePdf();
                      await Printing.layoutPdf(onLayout: (_) => pdf);
                    },
                    child: const Text("View PDF"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final pdf = await generatePdf();
                      final dir = await getTemporaryDirectory();
                      final file = File("${dir.path}/quotation.pdf");
                      await file.writeAsBytes(pdf);
                      await Share.shareXFiles(
                        [XFile(file.path)],
                        text: "Quotation PDF",
                      );
                    },
                    child: const Text("Share"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}