import 'package:flutter/material.dart';
import 'final_invoice_screen.dart';

class CuvettePricingScreen extends StatefulWidget {
  final String invoiceNumber;
  final String customerName;
  final String customerContact;
  final String customerAddress;

  final double deviceAmount;
  final double devicePrice;
  final int deviceQty;
  final double deviceDiscount;
  final double deviceGst;

  const CuvettePricingScreen({
  Key? key,
  required this.invoiceNumber,
  required this.customerName,
  required this.customerContact,
  required this.customerAddress,
  required this.deviceAmount,
  required this.devicePrice,
  required this.deviceQty,
  required this.deviceDiscount,
  required this.deviceGst,
  }) : super(key: key);

  @override
  State<CuvettePricingScreen> createState() => _CuvetteScreenState();
}

class _CuvetteScreenState extends State<CuvettePricingScreen> {

  int free50 = 0;
  int free100 = 0;
  int freeSingle = 0;
  int paid50 = 0;
  int paid100 = 0;
  int paidSingle = 0;

  double paidAmount = 0;
  double discountPercent = 0;
  double gstPercent = 0;

  double discountAmount = 0;
  double gstAmount = 0;
  double finalAmount = 0;

  bool get hasPaid => paid50 > 0 || paid100 > 0 || paidSingle > 0;

  int get totalCuvettes =>
      (free50 + paid50) * 50 +
          (free100 + paid100) * 100 +
          freeSingle +
          paidSingle;

  void calculateFinal() {
    double subtotal = paidAmount;
    double total = 0;

    if (discountPercent == 0) {
      total = subtotal;
      gstAmount = subtotal * gstPercent / (100 + gstPercent);
      discountAmount = 0;
    } else {

      double afterGstRemove =
          subtotal - (subtotal * gstPercent / 100);

      discountAmount =
          afterGstRemove * discountPercent / 100;

      double afterDiscount =
          afterGstRemove - discountAmount;

      gstAmount =
          afterDiscount * gstPercent / 100;

      total = afterDiscount + gstAmount;
    }

    finalAmount = total;

    if (finalAmount < 0) {
      finalAmount = 0;
    }

    setState(() {});
  }

  void clearAll() {
    setState(() {

      free50 = 0;
      free100 = 0;
      freeSingle = 0;

      paid50 = 0;
      paid100 = 0;
      paidSingle = 0;

      paidAmount = 0;
      discountPercent = 0;
      gstPercent = 0;

      discountAmount = 0;
      gstAmount = 0;
      finalAmount = 0;
    });
  }

  void openAddPopup() {

    String selectedPack = "50";
    String selectedType = "FREE";

    TextEditingController qtyController =
    TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: const Text("Add Cuvettes"),

        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                DropdownButtonFormField<String>(
                  value: selectedPack,
                  decoration: const InputDecoration(labelText: "Pack"),
                  items: const [

                    DropdownMenuItem(
                      value: "50",
                      child: Text("50 (Set)"),
                    ),

                    DropdownMenuItem(
                      value: "100",
                      child: Text("100 (Set)"),
                    ),

                    DropdownMenuItem(
                      value: "CUSTOM",
                      child: Text("Customize"),
                    ),
                  ],

                  onChanged: (v) {
                    selectedPack = v!;
                  },
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(labelText: "Type"),
                  items: const [

                    DropdownMenuItem(
                      value: "FREE",
                      child: Text("FREE"),
                    ),

                    DropdownMenuItem(
                      value: "PAID",
                      child: Text("PAID"),
                    ),
                  ],

                  onChanged: (v) {
                    selectedType = v!;
                  },
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: "Quantity"),
                ),
              ],
            ),
          ),
        ),

        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {

              int qty =
                  int.tryParse(qtyController.text) ?? 0;

              if (qty <= 0) return;

              setState(() {

                if (selectedType == "FREE") {

                  if (selectedPack == "50") {
                    free50 += qty;
                  } else if (selectedPack == "100") {
                    free100 += qty;
                  } else {
                    freeSingle += qty;
                  }

                } else {

                  if (selectedPack == "50") {
                    paid50 += qty;
                  } else if (selectedPack == "100") {
                    paid100 += qty;
                  } else {
                    paidSingle += qty;
                  }

                }

              });

              Navigator.pop(context);
            },

            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void openAmountPopup() {

    TextEditingController amountController =
    TextEditingController(text: paidAmount.toString());

    TextEditingController gstController =
    TextEditingController(text: gstPercent.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(

        title: const Text("Enter Paid Details"),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: "Paid Amount (Incl GST)"),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: gstController,
              keyboardType: TextInputType.number,
              decoration:
              const InputDecoration(labelText: "GST %"),
            ),
          ],
        ),

        actions: [

          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

          ElevatedButton(
            onPressed: () {

              paidAmount =
                  double.tryParse(amountController.text) ?? 0;

              gstPercent =
                  double.tryParse(gstController.text) ?? 0;

              calculateFinal();

              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  Widget summaryRow(String title, int free, int paid) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(title),

          Text("Free: $free | Paid: $paid"),
        ],
      ),
    );
  }
  void saveAndNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FinalInvoiceScreen(
          invoiceNumber: widget.invoiceNumber,

          customerName: widget.customerName,
          customerContact: widget.customerContact,
          customerAddress: widget.customerAddress,

          devicePrice: widget.devicePrice,
          deviceQty: widget.deviceQty,
          deviceDiscount: widget.deviceDiscount,
          deviceGst: widget.deviceGst,

          cuvettePrice: paidAmount,
          cuvetteQty: totalCuvettes,
          cuvetteDiscount: discountPercent,
          cuvetteGst: gstPercent,

          deviceAmount: widget.deviceAmount,
          cuvetteAmount: finalAmount,

          grandTotal:
          widget.deviceAmount + finalAmount,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    double grandTotal =
        widget.deviceAmount + finalAmount;

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Cuvette Selection",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddPopup,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text("Add"),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: ElevatedButton(
          onPressed: saveAndNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
          child: const Text(
            "Save & Next",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(

        padding: const EdgeInsets.fromLTRB(16, 16, 16, 150),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      "Invoice Number: ${widget.invoiceNumber}",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      "Name: ${widget.customerName}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Contact: ${widget.customerContact}",
                      style: const TextStyle(fontSize: 16),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "Address: ${widget.customerAddress}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),

                child: Column(
                  children: [

                    summaryRow("50 Sets", free50, paid50),
                    summaryRow("100 Sets", free100, paid100),
                    summaryRow("Single", freeSingle, paidSingle),

                    const Divider(),

                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Total Cuvettes",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text(totalCuvettes.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (hasPaid)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: openAmountPopup,
                  icon: const Icon(Icons.payments),
                  label: const Text("Enter Paid Amount"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text("Discount"),

                        Text("₹ ${discountAmount.toStringAsFixed(2)}"),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text("GST"),

                        Text("₹ ${gstAmount.toStringAsFixed(2)}"),
                      ],
                    ),

                    const Divider(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Final Paid",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text(
                          "₹ ${finalAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [

                        const Text(
                          "Grand Total",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        Text(
                          "₹ ${grandTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
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