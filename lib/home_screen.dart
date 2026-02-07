import 'package:flutter/material.dart';
import 'quotation_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Main Screen")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text("Challan")),
            ElevatedButton(onPressed: () {}, child: const Text("Bill")),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuotationForm()),
                );
              },
              child: const Text("Quotation"),
            ),
          ],
        ),
      ),
    );
  }
}
