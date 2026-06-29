import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:flutter/services.dart' show rootBundle;

class FinalInvoiceScreen extends StatelessWidget {
  final double devicePrice;
  final int deviceQty;
  final double deviceDiscount;
  final double deviceGst;
  final double cuvettePrice;
  final int cuvetteQty;
  final double cuvetteDiscount;
  final double cuvetteGst;
  final String invoiceNumber;
  final String customerName;
  final String customerContact;
  final String customerAddress;

  final double deviceAmount;
  final double cuvetteAmount;
  final double grandTotal;

  const FinalInvoiceScreen({
    super.key,
    required this.devicePrice,
    required this.deviceQty,
    required this.deviceDiscount,
    required this.deviceGst,

    required this.cuvettePrice,
    required this.cuvetteQty,
    required this.cuvetteDiscount,
    required this.cuvetteGst,
    required this.invoiceNumber,
    required this.customerName,
    required this.customerContact,
    required this.customerAddress,
    required this.deviceAmount,
    required this.cuvetteAmount,
    required this.grandTotal,
  });

  pw.Widget cell(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: const pw.TextStyle(
          fontSize: 10,
        ),
      ),
    );
  }

  Future<Uint8List> generatePdf() async {


    final pdf = pw.Document();

    final now = DateTime.now();

    final date =
        "${now.day.toString().padLeft(2, '0')}/"
        "${now.month.toString().padLeft(2, '0')}/"
        "${now.year}";

    final taxableValue = deviceAmount + cuvetteAmount;

    final hsn9027Taxable = deviceAmount;
    final hsn3822Taxable = cuvetteAmount;

    final hsn9027Cgst = hsn9027Taxable * 0.025;
    final hsn9027Sgst = hsn9027Taxable * 0.025;
    final hsn9027TotalTax = hsn9027Cgst + hsn9027Sgst;

    final hsn3822Cgst = hsn3822Taxable * 0.025;
    final hsn3822Sgst = hsn3822Taxable * 0.025;
    final hsn3822TotalTax = hsn3822Cgst + hsn3822Sgst;

    final cgst = hsn9027Cgst + hsn3822Cgst;
    final sgst = hsn9027Sgst + hsn3822Sgst;

    final totalTax = cgst + sgst;

    pdf.addPage(
    pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(20),
    build: (context) => [

          pw.Center(
            child: pw.Text(
              "TAX INVOICE",
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Table(
            border: pw.TableBorder.all(
              width: 1,
              color: PdfColors.black,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                children: [

                  // Company Details
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          "CUTTING EDGE MEDICAL DEVICES PVT. LTD.",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),

                        pw.SizedBox(height: 3),

                        pw.Text(
                          "An ISO 13485:2016 Certified Medical Device Company",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          "E-2406, Sudama Nagar, Indore (M.P.)",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),

                        pw.Text(
                          "GSTIN : 23AAFCC8508D1Z0",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),

                        pw.Text(
                          "Email : info@cemd.in",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Invoice No
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Invoice No.",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          invoiceNumber,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Date
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Dated",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          date,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Payment Mode
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Mode of Payment",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),
                        pw.SizedBox(height: 5),
                        pw.Text(
                          "Advance",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 5),

          pw.Table(
            border: pw.TableBorder.all(
              width: 1,
              color: PdfColors.black,
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                children: [

                  // Consignee Details
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          "Consignee (Ship To)",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          customerName,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),

                        pw.Text(
                          customerAddress,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),

                        pw.Text(
                          "Mob: $customerContact",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Quotation No
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Quotation No.",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          invoiceNumber,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Date
                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Quotation Date",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          date,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 5),

          pw.Table(
            border: pw.TableBorder.all(),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                children: [

                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          "Buyer Details",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 9,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          customerName,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),

                        pw.Text(
                          customerAddress,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Dispatch Through",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          "Road Transport",
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),

                  pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          "Destination",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                            fontSize: 8,
                          ),
                        ),

                        pw.SizedBox(height: 5),

                        pw.Text(
                          customerAddress,
                          style: const pw.TextStyle(
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          pw.Table(
            border: pw.TableBorder.all(
              width: 1,
              color: PdfColors.black,
            ),
            columnWidths: {
              0: const pw.FixedColumnWidth(25),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FixedColumnWidth(45),
              3: const pw.FixedColumnWidth(35),
              4: const pw.FixedColumnWidth(55),
              5: const pw.FixedColumnWidth(50),
              6: const pw.FixedColumnWidth(55),
              7: const pw.FixedColumnWidth(60),
            },
            children: [

              // Header Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  cell("S.No"),
                  cell("Description"),
                  cell("HSN"),
                  cell("Qty"),
                  cell("Rate"),
                  cell("Disc%"),
                  cell("Price"),
                  cell("Amount"),
                ],
              ),

              // Device Row
              pw.TableRow(
                children: [
                  cell("1"),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "SCINTIGLO SG-100\n"
                          "A smart point-of-care electronic device\n"
                          "for quantitative measurement of\n"
                          "urinary microproteinuria",
                      style: const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ),

                  cell("9027"),

                  cell(deviceQty.toString()),

                  cell(
                    devicePrice.toStringAsFixed(2),
                  ),

                  cell(
                    deviceDiscount.toStringAsFixed(2),
                  ),

                  cell(
                    devicePrice.toStringAsFixed(2),
                  ),

                  cell(
                    deviceAmount.toStringAsFixed(2),
                  ),
                ],
              ),

              // Cuvette Row
              pw.TableRow(
                children: [
                  cell("2"),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Consumables with proprietary reagent",
                      style: const pw.TextStyle(
                        fontSize: 7,
                      ),
                    ),
                  ),

                  cell("3822"),

                  cell(
                    cuvetteQty.toString(),
                  ),

                  cell(
                    cuvettePrice.toStringAsFixed(2),
                  ),

                  cell(
                    cuvetteDiscount.toStringAsFixed(2),
                  ),

                  cell(
                    cuvettePrice.toStringAsFixed(2),
                  ),

                  cell(
                    cuvetteAmount.toStringAsFixed(2),
                  ),
                ],
              ),
            ],
          ),  

          pw.SizedBox(height: 5),

          pw.Table(
            border: pw.TableBorder(
              left: const pw.BorderSide(),
              right: const pw.BorderSide(),
              bottom: const pw.BorderSide(),
            ),
            columnWidths: {
              0: const pw.FlexColumnWidth(4),
              1: const pw.FlexColumnWidth(1),
            },
            children: [

              pw.TableRow(
                children: [
                  cell("Taxable Value"),
                  cell("\u20B9 ${taxableValue.toStringAsFixed(2)}"),
                ],
              ),

              pw.TableRow(
                children: [
                  cell("CGST @ 2.5%"),
                  cell(
                    "\u20B9 ${cgst.toStringAsFixed(2)}",

                  )
                ],
              ),

              pw.TableRow(
                children: [
                  cell("SGST @ 2.5%"),
                  cell("\u20B9 ${sgst.toStringAsFixed(2)}"),
                ],
              ),

              pw.TableRow(
                children: [
                  cell("Total Tax"),
                  cell("\u20B9 ${totalTax.toStringAsFixed(2)}"),
                ],
              ),

              pw.TableRow(
                children: [
                  cell("Grand Total"),
                  cell(
                    "\u20B9 ${grandTotal.toStringAsFixed(2)}",

                  )
                ],
              ),
            ],
          ),


          pw.Table(
            border: pw.TableBorder(
              left: const pw.BorderSide(),
              right: const pw.BorderSide(),
              bottom: const pw.BorderSide(),

            ),
            columnWidths: {
              0: const pw.FixedColumnWidth(45),
              1: const pw.FixedColumnWidth(80),
              2: const pw.FixedColumnWidth(40),
              3: const pw.FixedColumnWidth(60),
              4: const pw.FixedColumnWidth(40),
              5: const pw.FixedColumnWidth(60),
              6: const pw.FixedColumnWidth(65),
            },
            children: [

              // Header
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [
                  cell("HSN"),
                  cell("Taxable Value"),
                  cell("CGST %"),
                  cell("CGST Amt"),
                  cell("SGST %"),
                  cell("SGST Amt"),
                  cell("Total Tax"),
                ],
              ),

              // 9027 Row
              pw.TableRow(
                children: [
                  cell("9027"),
                  cell(
                    hsn9027Taxable.toStringAsFixed(2),
                  ),
                  cell("2.50%"),
                  cell(
                    hsn9027Cgst.toStringAsFixed(2),
                  ),
                  cell("2.50%"),
                  cell(
                    hsn9027Sgst.toStringAsFixed(2),
                  ),
                  cell(
                    hsn9027TotalTax.toStringAsFixed(2),
                  ),
                ],
              ),

              // 3822 Row
              pw.TableRow(
                children: [
                  cell("3822"),
                  cell("0.00"),
                  cell("2.50%"),
                  cell("0.00"),
                  cell("2.50%"),
                  cell("0.00"),
                  cell("0.00"),
                ],
              ),

              // Total Row
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey200,
                ),
                children: [
                  cell("TOTAL"),
                  cell(
                    hsn9027Taxable.toStringAsFixed(2),
                  ),
                  cell(""),
                  cell(
                    hsn9027Cgst.toStringAsFixed(2),
                  ),
                  cell(""),
                  cell(
                    hsn9027Sgst.toStringAsFixed(2),
                  ),
                  cell(
                    hsn9027TotalTax.toStringAsFixed(2),
                  ),
                ],
              ),
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Text(
                      "Amount Chargeable (in words)\n"
                          "INR ${grandTotal.toStringAsFixed(0)} Rupees Only",
                        style: pw.TextStyle(
                          fontSize: 8,
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 5),

          pw.Table(
            border: pw.TableBorder.all(),
            children: [
              pw.TableRow(
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(6),
                    child: pw.Column(
                      crossAxisAlignment:
                      pw.CrossAxisAlignment.start,
                      children: [

                        pw.Text(
                          "Company Bank Details",
                          style: pw.TextStyle(
                            fontWeight:
                            pw.FontWeight.bold,
                          ),
                        ),

                        pw.SizedBox(height: 4),

                        pw.Text(
                          "Bank : Axis Bank",
                          style: const pw.TextStyle(
                            fontSize: 7,
                          ),
                        ),

                        pw.Text(
                          "A/C No : 932200015806072",
                          style: const pw.TextStyle(
                            fontSize: 7,
                          ),
                        ),

                        pw.Text(
                          "IFSC : UTIB0005070",
                          style: const pw.TextStyle(
                            fontSize: 7,
                          ),
                        ),

                        pw.Text(
                          "Branch : Annapurna Road, Indore",
                          style: const pw.TextStyle(
                            fontSize: 7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

        pw.SizedBox(height: 5),

        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [

                pw.Container(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Column(
                    crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                    children: [

                      pw.Text(
                        "Declaration",
                        style: pw.TextStyle(
                          fontWeight:
                          pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 2),

                      pw.Text(
                        "We declare that this invoice "
                            "shows the actual price of the "
                            "goods described and that all "
                            "particulars are true and correct.",
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),

                pw.Container(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Column(
                    children: [

                      pw.SizedBox(height: 40),
                      pw.Text(
                        "Authorized Signatory",
                        style: pw.TextStyle(
                          fontWeight:
                          pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        pw.Table(
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.all(6),
                  child: pw.Column(
                    crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                    children: [

                      pw.Text(
                        "Terms & Conditions",
                        style: pw.TextStyle(
                          fontWeight:
                          pw.FontWeight.bold,
                        ),
                      ),

                      pw.SizedBox(height: 4),

                      pw.Text(
                        "• 100% advance payment required.",
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),

                      pw.Text(
                        "• Transportation charges extra.",
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),

                      pw.Text(
                        "• Offer valid for 15 days.",
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),

                      pw.Text(
                        "• Warranty as per company policy.",
                        style: const pw.TextStyle(
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    );
    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Final Invoice"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text("Invoice No : $invoiceNumber"),
            Text("Customer : $customerName"),

            const SizedBox(height: 15),

            Text(
              "Device Amount : ₹${deviceAmount.toStringAsFixed(2)}",
            ),

            Text(
              "Cuvette Amount : ₹${cuvetteAmount.toStringAsFixed(2)}",
            ),

            const SizedBox(height: 10),

            Text(
              "Grand Total : ₹${grandTotal.toStringAsFixed(2)}",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final pdf =
                      await generatePdf();

                      await Printing.layoutPdf(
                        onLayout: (_) => pdf,
                      );
                    },
                    child: const Text(
                      "View PDF",
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final pdf =
                      await generatePdf();

                      final dir =
                      await getTemporaryDirectory();

                      final file = File(
                        "${dir.path}/tax_invoice.pdf",
                      );

                      await file.writeAsBytes(pdf);

                      await Share.shareXFiles(
                        [XFile(file.path)],
                        text: "Tax Invoice",
                      );
                    },
                    child: const Text(
                      "Share PDF",
                    ),
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