import 'package:flutter/material.dart';

class FinalSummaryScreen extends StatelessWidget {
  final String customerName;
  final String customerContact;
  final String selectedPack;
  final String cuvetteType;
  final double cuvetteAmount;
  final double finalAmount;

  const FinalSummaryScreen({
    super.key,
    required this.customerName,
    required this.customerContact,
    required this.selectedPack,
    required this.cuvetteType,
    required this.cuvetteAmount,
    required this.finalAmount,
  });

  void viewPdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("View PDF Clicked")),
    );
  }

  void sharePdf(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Share PDF Clicked")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F8), // SAME BACKGROUND
      body: SafeArea(
        child: Column(
          children: [

            /// HEADER
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15),
              child: Row(
                children: const [
                  Icon(Icons.receipt_long,
                      color: Colors.teal),
                  SizedBox(width: 10),
                  Text(
                    "Final Summary",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),

            /// BODY
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      const Text(
                        "Quotation Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),

                      const SizedBox(height: 25),

                      buildDetailRow(
                          "Customer Name", customerName),

                      buildDetailRow(
                          "Contact", customerContact),

                      buildDetailRow(
                          "Selected Pack", selectedPack),

                      buildDetailRow(
                        "Cuvette Amount",
                        cuvetteType == "FREE"
                            ? "FREE"
                            : "₹ ${cuvetteAmount.toStringAsFixed(2)}",
                      ),

                      const SizedBox(height: 20),

                      Divider(color: Colors.grey.shade300),

                      const SizedBox(height: 10),

                      /// FINAL AMOUNT HIGHLIGHT
                      Container(
                        width: double.infinity,
                        padding:
                        const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color:
                          const Color(0xFFE0F2F1),
                          borderRadius:
                          BorderRadius.circular(15),
                        ),
                        child: Text(
                          "Final Amount: ₹ ${finalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// VIEW PDF
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.teal,
                            padding:
                            const EdgeInsets
                                .symmetric(
                                vertical: 14),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(15),
                            ),
                          ),
                          onPressed: () =>
                              viewPdf(context),
                          child:
                          const Text("View PDF"),
                        ),
                      ),

                      const SizedBox(height: 15),

                      /// SHARE PDF
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style:
                          ElevatedButton.styleFrom(
                            backgroundColor:
                            Colors.teal,
                            padding:
                            const EdgeInsets
                                .symmetric(
                                vertical: 14),
                            shape:
                            RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius
                                  .circular(15),
                            ),
                          ),
                          onPressed: () =>
                              sharePdf(context),
                          child:
                          const Text("Share PDF"),
                        ),
                      ),
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

  /// REUSABLE DETAIL ROW
  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              "$title:",
              style: const TextStyle(
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
