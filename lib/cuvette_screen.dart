import 'package:flutter/material.dart';
import 'final_screen.dart';

class CuvetteScreen extends StatefulWidget {
  final double totalPrice;

  const CuvetteScreen({
    super.key,
    required this.totalPrice,
  });

  @override
  State<CuvetteScreen> createState() => _CuvetteScreenState();
}

class _CuvetteScreenState extends State<CuvetteScreen> {
  String selectedCuvette = "50";
  String paymentType = ""; // Free / Paid
  double cuvetteAmount = 0;

  void showPaidPopup() {
    final TextEditingController amountController =
    TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Enter Cuvette Amount"),
        content: TextField(
          controller: amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: "Enter amount",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final value = double.tryParse(amountController.text);
              if (value != null && value > 0) {
                setState(() {
                  cuvetteAmount = value;
                  paymentType = "Paid";
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double finalTotal =
        widget.totalPrice + (paymentType == "Paid" ? cuvetteAmount : 0);

    return Scaffold(
      appBar: AppBar(title: const Text("Assign Cuvette")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TOTAL PRICE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                "Total Price : ₹ ${finalTotal.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// CUVETTE DROPDOWN
            const Text(
              "Assigned Cuvette",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedCuvette,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: "50", child: Text("50 Cuvette")),
                DropdownMenuItem(value: "100", child: Text("100 Cuvette")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCuvette = value!;
                });
              },
            ),

            const SizedBox(height: 30),

            /// PAYMENT TYPE BUTTONS
            const Text(
              "Payment Type",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      paymentType == "Free" ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        paymentType = "Free";
                        cuvetteAmount = 0;
                      });
                    },
                    child: const Text("Free"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      paymentType == "Paid" ? Colors.blue : Colors.grey,
                    ),
                    onPressed: showPaidPopup,
                    child: const Text("Paid"),
                  ),
                ),
              ],
            ),

            const Spacer(),

            /// SAVE & NEXT
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: paymentType.isEmpty
                    ? null
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FinalScreen(
                        totalPrice: finalTotal,
                        cuvette: selectedCuvette,
                        payment: paymentType,
                      ),
                    ),
                  );
                },
                child: const Text("Save & Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
