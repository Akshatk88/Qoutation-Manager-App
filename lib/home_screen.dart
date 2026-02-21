import 'dart:math';
import 'package:flutter/material.dart';
import 'package:quotation_app/quotation_form.dart';
import 'quotation_form.dart';

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

    // ECG Left → Right Animation
    ecgAnimation = Tween<double>(begin: -200, end: 200).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );

    // Fade Animation for Text
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
      backgroundColor: const Color(0xFFEFF6F8),
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
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal,
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
                  children: [

                    // // Animated ECG (Left → Right)
                    // AnimatedBuilder(
                    //   animation: ecgAnimation,
                    //   builder: (_, child) {
                    //     return Positioned(
                    //       top: 120,
                    //       left: ecgAnimation.value,
                    //       child: Opacity(
                    //         opacity: 0.25,
                    //         child: Image.asset(
                    //           "assets/images/ecg.png",
                    //           width: 150,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        const SizedBox(height: 25),

                        // Medium Device Image Centered
                        Image.asset(
                          "assets/images/device.png",
                          height: 160,
                        ),

                        const SizedBox(height: 25),

                        // Fade Text Section
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
                              SizedBox(height: 6),
                              Text(
                                "Smart Diagnostic Portal",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "Empowering Diagnostics through Innovation.",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black45,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  buildButton(context, "Challan", Icons.local_shipping, () {}),
                  const SizedBox(height: 15),
                  buildButton(context, "Bill", Icons.receipt_long, () {}),
                  const SizedBox(height: 15),
                  buildButton(context, "Quotation", Icons.description, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QuotationForm(),
                      ),
                    );
                  }),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
    );
  }
}
