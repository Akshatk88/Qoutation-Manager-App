import 'package:flutter/material.dart';

class CuvetteScreen extends StatefulWidget {
  final String customerName;
  final String customerContact;
  final double baseAmount;

  const CuvetteScreen({
    Key? key,
    required this.customerName,
    required this.customerContact,
    required this.baseAmount,
  }) : super(key: key);

  @override
  State<CuvetteScreen> createState() => _CuvetteScreenState();
}

class _CuvetteScreenState extends State<CuvetteScreen> {

  /// FREE COUNTS
  int free50 = 0;
  int free100 = 0;
  int freeSingle = 0;

  /// PAID COUNTS
  int paid50 = 0;
  int paid100 = 0;
  int paidSingle = 0;

  double paidAmount = 0;
  double discountPercent = 0;
  double gstPercent = 0;

  double discountAmount = 0;
  double gstAmount = 0;
  double finalAmount = 0;

  bool get hasPaid =>
      paid50 > 0 || paid100 > 0 || paidSingle > 0;

  int get totalCuvettes =>
      (free50 + paid50) * 50 +
          (free100 + paid100) * 100 +
          freeSingle +
          paidSingle;

  double get grandTotal =>
      widget.baseAmount + finalAmount;

  /// DEVICE STYLE CALCULATION
  void calculateFinal() {

    double base = paidAmount;

    double priceWithoutGst =
        base / (1 + gstPercent / 100);

    discountAmount =
        priceWithoutGst * (discountPercent / 100);

    double afterDiscount =
        priceWithoutGst - discountAmount;

    gstAmount =
        afterDiscount * (gstPercent / 100);

    finalAmount =
        afterDiscount + gstAmount;

    if (finalAmount < 0) finalAmount = 0;

    setState(() {});
  }

  /// CLEAR ALL
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

  /// ADD POPUP
  void openAddPopup() {

    String selectedPack = "50";
    String selectedType = "FREE";
    TextEditingController qtyController =
    TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Add Cuvettes"),
          content: SingleChildScrollView(
            child: Column(
              children: [

                DropdownButtonFormField<String>(
                  value: selectedPack,
                  isExpanded: true,
                  decoration:
                  const InputDecoration(labelText: "Pack"),
                  items: const [
                    DropdownMenuItem(
                        value: "50",
                        child: Text("50 (Set)")),
                    DropdownMenuItem(
                        value: "100",
                        child: Text("100 (Set)")),
                    DropdownMenuItem(
                        value: "CUSTOM",
                        child: Text("Customize")),
                  ],
                  onChanged: (v) => selectedPack = v!,
                ),

                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedType,
                  isExpanded: true,
                  decoration:
                  const InputDecoration(labelText: "Type"),
                  items: const [
                    DropdownMenuItem(
                        value: "FREE",
                        child: Text("FREE")),
                    DropdownMenuItem(
                        value: "PAID",
                        child: Text("PAID")),
                  ],
                  onChanged: (v) => selectedType = v!,
                ),

                const SizedBox(height: 12),

                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: "Quantity"),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
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
        );
      },
    );
  }

  void openAmountPopup() {

    TextEditingController amountController =
    TextEditingController();
    TextEditingController gstController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Paid Details"),
        content: SingleChildScrollView(
          child: Column(
            children: [

              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration:
                const InputDecoration(
                    labelText: "Paid Amount (Incl GST)"),
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
        ),
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                paidAmount =
                    double.tryParse(amountController.text) ?? 0;
                gstPercent =
                    double.tryParse(gstController.text) ?? 0;
                discountPercent = 0;
                calculateFinal();
                Navigator.pop(context);
              },
              child: const Text("OK"))
        ],
      ),
    );
  }

  void openDiscountPopup() {

    TextEditingController controller =
    TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Discount %"),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                discountPercent =
                    double.tryParse(controller.text) ?? 0;
                calculateFinal();
                Navigator.pop(context);
              },
              child: const Text("Apply"))
        ],
      ),
    );
  }

  Widget summaryRow(String title, int free, int paid) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "$title → Free: $free | Paid: $paid",
        style: const TextStyle(fontSize: 15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuvette Selection"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            onPressed: clearAll,
            icon: const Icon(Icons.refresh),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: openAddPopup,
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text("Customer: ${widget.customerName}"),
            Text("Contact: ${widget.customerContact}"),

            const SizedBox(height: 20),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    summaryRow("50 Sets", free50, paid50),
                    summaryRow("100 Sets", free100, paid100),
                    summaryRow("Single", freeSingle, paidSingle),

                    const Divider(),

                    Text(
                      "Total Cuvettes: $totalCuvettes",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (hasPaid)
              ElevatedButton(
                onPressed: openAmountPopup,
                child: const Text("Enter Paid Amount"),
              ),

            if (hasPaid && paidAmount > 0)
              ElevatedButton(
                onPressed: openDiscountPopup,
                child: const Text("Discount %"),
              ),

            const SizedBox(height: 25),

            if (hasPaid)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [

                      Text("Discount: ₹ ${discountAmount.toStringAsFixed(2)}"),
                      Text("GST: ₹ ${gstAmount.toStringAsFixed(2)}"),

                      const Divider(),

                      Text(
                        "Final Paid: ₹ ${finalAmount.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        "Grand Total: ₹ ${grandTotal.toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
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