import 'package:flutter/material.dart';
import 'price_calculation_screen.dart';

class QuotationForm extends StatefulWidget {
  const QuotationForm({super.key});

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // Country Code
  String selectedCountryCode = "+91";

  final List<String> countryCodes = [
    "+91 (Ind)",
    "+1 (USA)",
    "+44 (UK)",
    "+61 (Aus)",
    "+971 (UAE)",
    "+81 (Jap)",
    "+49 (Ger)",
    "+33 (Fra)",
    "+55 (Bra)",
    "+65 (Sin)",
    "+39 (Ita)",
    "+62 (Indo)"
  ];

  // Customer Type
  String selectedCustomerType = "Hospital";

  final List<String> customerTypes = [
    "Hospital",
    "Labs",
    "Clinic",
    "NGO's",
    "Others",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF6F8),
      body: SafeArea(
        child: Column(
          children: [

            // ================= HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: const [
                  Icon(Icons.description, color: Colors.teal),
                  SizedBox(width: 10),
                  Text(
                    "New Quotation",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ],
              ),
            ),

            // ================= BODY =================
            Expanded(
              child: Container(
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [

                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [

                            const Text(
                              "Customer Details",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Customer Name
                            buildTextField(
                              controller: nameController,
                              label: "Customer Name",
                              icon: Icons.person,
                            ),

                            const SizedBox(height: 20),

                            // Contact Number Row
                            Row(
                              children: [

                                // Country Code (40%)
                                Expanded(
                                  flex: 4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.teal),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedCountryCode,
                                        isExpanded: true,
                                        items: countryCodes.map((code) {
                                          return DropdownMenuItem(
                                            value: code.split(" ")[0],
                                            child: Text(
                                              code,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setState(() {
                                            selectedCountryCode = value!;
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Contact Number (60%)
                                Expanded(
                                  flex: 6,
                                  child: buildTextField(
                                    controller: contactController,
                                    label: "Contact Number",
                                    icon: Icons.phone,
                                    keyboardType: TextInputType.phone,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Address
                            buildTextField(
                              controller: addressController,
                              label: "Customer Address",
                              icon: Icons.location_on,
                              maxLines: 3,
                            ),

                            const SizedBox(height: 20),

                            // Customer Type Dropdown
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.teal),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: selectedCustomerType,
                                  isExpanded: true,
                                  icon: const Icon(Icons.arrow_drop_down, color: Colors.teal),
                                  items: customerTypes.map((type) {
                                    return DropdownMenuItem(
                                      value: type,
                                      child: Text(type),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCustomerType = value!;
                                    });
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // NEXT BUTTON
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PriceCalculationScreen(
                                      customerName: nameController.text,
                                      customerContact:
                                      "$selectedCountryCode ${contactController.text}",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Colors.teal,
                                      Color(0xFF009688),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Center(
                                  child: Text(
                                    "Next",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= REUSABLE TEXTFIELD =================
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.teal),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.teal),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
