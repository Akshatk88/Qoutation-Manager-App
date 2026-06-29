import 'package:flutter/material.dart';
import 'widgets/animated_button.dart';
import 'cuvette_pricing_screen.dart';


class ProductPricingScreen extends StatefulWidget {
  final String invoiceNumber;
  final String customerName;
  final String customerAddress;
  final String customerContact;

  const ProductPricingScreen({
    super.key,
    required this.invoiceNumber,
    required this.customerName,
    required this.customerAddress,
    required this.customerContact,
  });

  @override
  State<ProductPricingScreen> createState() =>
      _ProductPricingScreenState();
}

class _ProductPricingScreenState
    extends State<ProductPricingScreen> {

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
    double price =
        double.tryParse(priceController.text) ?? 0;

    double quantity =
        double.tryParse(quantityController.text) ?? 0;

    double discount =
        double.tryParse(discountController.text) ?? 0;

    double subtotal = price * quantity;

    double discountAmount =
        subtotal * discount / 100;

    double afterDiscount =
        subtotal - discountAmount;

    double gstAmount =
        afterDiscount * selectedGst / 100;

    setState(() {
      finalPrice = afterDiscount + gstAmount;
    });
  }

  void saveAndNext() {

    if (priceController.text.isEmpty ||
        quantityController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Please enter Unit Price and Quantity",
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            CuvettePricingScreen(
              invoiceNumber: widget.invoiceNumber,
              customerName: widget.customerName,
              customerContact: widget.customerContact,
              customerAddress: widget.customerAddress,

              deviceAmount: finalPrice,

              devicePrice:
              double.tryParse(priceController.text) ?? 0,

              deviceQty:
              int.tryParse(quantityController.text) ?? 1,

              deviceDiscount:
              double.tryParse(discountController.text) ?? 0,

              deviceGst: selectedGst,
            )
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
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.teal,
      ),
      labelText: label,
      labelStyle:
      const TextStyle(color: Colors.teal),
      filled: true,
      fillColor: const Color(0xFFF2F2F2),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.teal,
          width: 1.5,
        ),
        borderRadius:
        BorderRadius.circular(15),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
        const BorderSide(color: Colors.teal),
        borderRadius:
        BorderRadius.circular(15),
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
                horizontal: 20,
                vertical: 15,
              ),
              child: Row(
                children: const [

                  Icon(
                    Icons.medical_services,
                    color: Colors.white,
                  ),

                  SizedBox(width: 10),

                  Text(
                    "Device Pricing",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight:
                      FontWeight.bold,
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
                  padding:
                  const EdgeInsets.all(20),

                  child: Container(
                    padding:
                    const EdgeInsets.all(20),

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

                        Text(
                          "Invoice No: ${widget.invoiceNumber}",
                          style: const TextStyle(
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),

                        const SizedBox(height: 25),

                        TextField(
                          controller:
                          priceController,
                          keyboardType:
                          TextInputType.number,

                          decoration:
                          buildInputDecoration(
                            "Device Price",
                            Icons.currency_rupee,
                          ),
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller:
                          quantityController,
                          keyboardType:
                          TextInputType.number,

                          decoration:
                          buildInputDecoration(
                            "Quantity",
                            Icons.shopping_cart,
                          ),
                        ),

                        const SizedBox(height: 20),

                        DropdownButtonFormField<double>(
                          value: selectedGst,

                          decoration:
                          buildInputDecoration(
                            "GST (%)",
                            Icons.percent,
                          ),

                          items: [5, 12, 18]
                              .map(
                                (e) =>
                                DropdownMenuItem(
                                  value:
                                  e.toDouble(),
                                  child:
                                  Text("$e%"),
                                ),
                          )
                              .toList(),

                          onChanged: (value) {

                            setState(() {
                              selectedGst =
                              value!;
                            });

                            calculateTotal();
                          },
                        ),

                        const SizedBox(height: 20),

                        TextField(
                          controller:
                          discountController,

                          keyboardType:
                          TextInputType.number,

                          decoration:
                          buildInputDecoration(
                            "Discount (%)",
                            Icons.discount,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          "Final Amount : ₹ ${finalPrice.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight:
                            FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),

                        const SizedBox(height: 30),

                        AnimatedButton(
                          text: "Save & Next",
                          onTap: saveAndNext,
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