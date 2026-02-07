import 'package:flutter/material.dart';

class FinalScreen extends StatelessWidget {
  final double totalPrice;
  final String cuvette;
  final String payment;

  const FinalScreen({
    super.key,
    required this.totalPrice,
    required this.cuvette,
    required this.payment,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Final Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total Price: ₹ $totalPrice"),
            Text("Cuvette: $cuvette"),
            Text("Payment: $payment"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Share"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("View PDF"),
            ),
          ],
        ),
      ),
    );
  }
}
