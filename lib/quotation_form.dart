import 'package:flutter/material.dart';
import 'cuvette_screen.dart';

class QuotationForm extends StatefulWidget {
  const QuotationForm({super.key});

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {
  final _formKey = GlobalKey<FormState>();

  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final discountController = TextEditingController(); // percentage

  double totalPrice = 0;

  void calculateTotal() {
    final price = double.tryParse(priceController.text);
    final qty = double.tryParse(quantityController.text);
    final discountPercent = double.tryParse(discountController.text);

    if (price == null || qty == null || discountPercent == null) {
      setState(() => totalPrice = 0);
      return;
    }

    final subtotal = price * qty;
    final discountAmount = subtotal * (discountPercent / 100);

    setState(() {
      totalPrice = subtotal - discountAmount;
      if (totalPrice < 0) totalPrice = 0;
    });
  }

  bool isFormFilled() {
    return priceController.text.isNotEmpty &&
        quantityController.text.isNotEmpty &&
        discountController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Quotation Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PRICE
              TextFormField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter price" : null,
                onChanged: (_) => calculateTotal(),
              ),
              const SizedBox(height: 16),

              /// QUANTITY
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter quantity" : null,
                onChanged: (_) => calculateTotal(),
              ),
              const SizedBox(height: 16),

              /// DISCOUNT %
              TextFormField(
                controller: discountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Discount (%)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Enter discount %" : null,
                onChanged: (_) => calculateTotal(),
              ),

              const SizedBox(height: 30),

              /// TOTAL PRICE DISPLAY
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total Price : ₹ ${totalPrice.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              /// SAVE & NEXT
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isFormFilled()
                      ? () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CuvetteScreen(
                            totalPrice: totalPrice,
                          ),
                        ),
                      );
                    }
                  }
                      : null,
                  child: const Text("Save & Next"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
