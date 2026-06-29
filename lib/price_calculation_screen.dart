import 'package:flutter/material.dart';
import 'cuvette_screen.dart';
import 'widgets/animated_button.dart';


class PriceCalculationScreen extends StatefulWidget {
  final String quotationNumber; // ✅ Add this
  final String customerName;
  final String customerContact;
  final String customerAddress;
  // ✅ ADD
  // ED

  const PriceCalculationScreen({
    super.key,
    required this.quotationNumber, // ✅ Add this
    required this.customerName,
    required this.customerContact,
    required this.customerAddress, // ✅ ADDED
  });

  @override
  State<PriceCalculationScreen> createState() =>
      _PriceCalculationScreenState();
}

class _PriceCalculationScreenState
    extends State<PriceCalculationScreen> {

  final priceController = TextEditingController();
  final quantityController = TextEditingController();
  final discountController = TextEditingController();

  double selectedGst = 5;
  double finalPrice = 0;

  @override
  void initState() {
    super.initState();
    priceController.addListener(calculateTotal);
    quantityController.addListener(calculateTotal);
    discountController.addListener(calculateTotal);
  }

  void calculateTotal() {
    double price = double.tryParse(priceController.text) ?? 0;
    double quantity = double.tryParse(quantityController.text) ?? 0;
    double discountPercent =
        double.tryParse(discountController.text) ?? 0;

    double subtotal = price * quantity;
    double total;

    if (discountPercent == 0) {
      total = subtotal;
    } else {
      double afterGstRemove =
          subtotal - (subtotal * selectedGst / 100);

      double afterDiscount =
          afterGstRemove -
              (afterGstRemove * discountPercent / 100);

      total =
          afterDiscount +
              (afterDiscount * selectedGst / 100);
    }

    setState(() {
      finalPrice = total;
    });
  }

  void validateAndProceed() {
    if (priceController.text.isEmpty ||
        quantityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Please enter Unit Price and Quantity"),
        ),
      );
      return;
    }

    if (finalPrice <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text("Total amount must be greater than 0"),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CuvetteScreen(
          QtnNumber: widget.quotationNumber,
          customerName: widget.customerName,
          customerContact: widget.customerContact,
          customerAddress: widget.customerAddress, // ✅ FIXED
          baseAmount: finalPrice,
        ),
      ),
    );
  }

  @override
  void dispose() {
    priceController.dispose();
    quantityController.dispose();
    discountController.dispose();
    super.dispose();
  }

  InputDecoration buildInputDecoration(
      String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.teal),
      labelText: label,
      labelStyle: const TextStyle(color: Colors.teal),
      filled: true,
      fillColor: const Color(0xFFF2F2F2),
      focusedBorder: OutlineInputBorder(
        borderSide:
        const BorderSide(color: Colors.teal, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
        const BorderSide(color: Colors.teal),
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 15),
              child: Row(
                children: const [
                  Icon(Icons.calculate,
                      color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "Price Calculation",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF779DA8),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
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
                      children: [

                        const SizedBox(height: 10),

                        TextField(
                          controller: priceController,
                          keyboardType: TextInputType.number,
                          decoration: buildInputDecoration(
                              "Unit Price",
                              Icons.currency_rupee),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: quantityController,
                          keyboardType: TextInputType.number,
                          decoration: buildInputDecoration(
                              "Quantity",
                              Icons.shopping_cart),
                        ),

                        const SizedBox(height: 20),

                        DropdownButtonFormField<double>(
                          value: selectedGst,
                          decoration: buildInputDecoration(
                              "Select GST (%)",
                              Icons.percent),
                          items: [5, 12, 18]
                              .map((gst) =>
                              DropdownMenuItem(
                                value: gst.toDouble(),
                                child: Text("$gst%"),
                              ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedGst = value!;
                            });
                            calculateTotal();
                          },
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller: discountController,
                          keyboardType: TextInputType.number,
                          decoration: buildInputDecoration(
                              "Discount (%)",
                              Icons.discount),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          "Final Amount: ₹ ${finalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),

                        const SizedBox(height: 30),

                        AnimatedButton(
                          text: "Save & Next",
                          onTap: validateAndProceed,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}