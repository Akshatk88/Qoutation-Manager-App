import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quotation_app/quotation_form.dart';
import 'quotation_form.dart';
import 'tax_invoice_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> ecgAnimation;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    ecgAnimation = Tween<double>(begin: -200, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D8F8A),
      body: SafeArea(
        child: Column(
          children: [

            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset("assets/images/logo.jpg", height: 40),
                  const Text(
                    "Cutting Edge Medical Devices",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // ================= MAIN BODY =================
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFD8EEF3),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(ecgAnimation.value, 0),
                          child: Opacity(
                            opacity: 0.15,
                            child: Image.asset(
                              "assets/images/ecg.png",
                              height: 230,
                              fit: BoxFit.contain,
                            ),
                          ),
                        );
                      },
                    ),

                    Image.asset(
                      "assets/images/device.png",
                      height: 190,
                    ),

                    FadeTransition(
                      opacity: fadeAnimation,
                      child: const Column(
                        children: [
                          Text(
                            "SCINTIGLO",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: 200),
                          Text(
                            "Smart Diagnostic Portal",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ================= BUTTON SECTION =================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Column(
                children: [

                  // 1️⃣ Quotation First
                  buildButton(context, "Quotation", Icons.description, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuotationForm(),
                      ),
                    );
                  }),

                  const SizedBox(height: 15),

                  // 2️⃣ Bill Invoice
                  buildButton(context, "Proforma Invoice", Icons.receipt_long, () {}),

                  const SizedBox(height: 15),

                  // 3️⃣ Challan
                  buildButton(context, "Challan", Icons.local_shipping, () {}),

                  const SizedBox(height: 15),
                  // Tax Invoice
                buildButton(
                  context,
                  "Tax Invoice",
                  Icons.receipt_long,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const TaxInvoiceForm(),
                      ),
                    );
                  },
                ),
                  const SizedBox(height: 15),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(
      BuildContext context,
      String text,
      IconData icon,
      VoidCallback onTap,
      ) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        splashColor: Colors.teal.withOpacity(0.2),
        highlightColor: Colors.teal.withOpacity(0.1),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.teal, width: 1.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.teal),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}