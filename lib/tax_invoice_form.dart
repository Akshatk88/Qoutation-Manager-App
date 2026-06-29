import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'product_pricing_screen.dart';

class TaxInvoiceForm extends StatefulWidget {
  const TaxInvoiceForm({super.key});

  @override
  State<TaxInvoiceForm> createState() => _TaxInvoiceFormState();
}

class _TaxInvoiceFormState extends State<TaxInvoiceForm> {

  String selectedInvoiceYear = "26-27";
  String selectedQuotationYear = "26-27";

  final List<String> financialYears = [
    "26-27",
    "27-28",
    "28-29",
    "29-30",
    "30-31",
    "31-32",
    "32-33",
    "33-34",
    "34-35",
    "35-36",
  ];

  final invoiceSuffixController = TextEditingController();
  final quotationSuffixController = TextEditingController();

  final invoiceDateController = TextEditingController();
  final quotationDateController = TextEditingController();

  final buyerOrderNoController = TextEditingController();
  final buyerOrderDateController = TextEditingController();

  final customerNameController = TextEditingController();
  final customerAddressController = TextEditingController();

  InputDecoration inputDecoration(
      String label,
      IconData icon,
      ) {
    return InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.teal,
      ),
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Future<void> pickDate(
      TextEditingController controller,
      ) async {
    DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2024),
      lastDate: DateTime(2035),
      initialDate: DateTime.now(),
    );

    if (picked != null) {
      controller.text =
      "${picked.day}/${picked.month}/${picked.year}";
    }
  }

  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        bool opened = await Geolocator.openLocationSettings();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Please turn on your location services",
            ),
          ),
        );

        return;
      }

      permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      Position position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
      await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      String address = [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((e) => e != null && e.isNotEmpty).join(", ");

      setState(() {
        customerAddressController.text = address;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D8F8A),

      appBar: AppBar(
        title: const Text("Tax Invoice"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: Container(
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

          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20),
            ),

            child: Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                children: [

                  /// Invoice Number

                  DropdownButtonFormField<String>(
                    value: selectedInvoiceYear,
                    decoration: InputDecoration(
                      labelText: "Invoice Financial Year",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    items: financialYears.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedInvoiceYear = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: invoiceSuffixController,
                    decoration: InputDecoration(
                      prefixText:
                      "CEMD/$selectedInvoiceYear/",
                      labelText: "Invoice No",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller: invoiceDateController,
                    readOnly: true,
                    onTap: () =>
                        pickDate(invoiceDateController),
                    decoration: inputDecoration(
                      "Invoice Date",
                      Icons.calendar_month,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Quotation Number

                  DropdownButtonFormField<String>(
                    value: selectedQuotationYear,
                    decoration: InputDecoration(
                      labelText:
                      "Quotation Financial Year",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                    items: financialYears.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedQuotationYear = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    controller: quotationSuffixController,
                    decoration: InputDecoration(
                      prefixText:
                      "CEMD-Q/$selectedQuotationYear/",
                      labelText: "Quotation No",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                    quotationDateController,
                    readOnly: true,
                    onTap: () => pickDate(
                      quotationDateController,
                    ),
                    decoration: inputDecoration(
                      "Quotation Date",
                      Icons.calendar_month,
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                    buyerOrderNoController,
                    decoration: inputDecoration(
                      "Buyer Order No",
                      Icons.shopping_cart,
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                    buyerOrderDateController,
                    readOnly: true,
                    onTap: () => pickDate(
                      buyerOrderDateController,
                    ),
                    decoration: inputDecoration(
                      "Buyer Order Date",
                      Icons.calendar_month,
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                    customerNameController,
                    decoration: inputDecoration(
                      "Customer Name",
                      Icons.person,
                    ),
                  ),

                  const SizedBox(height: 15),

                  TextField(
                    controller:
                    customerAddressController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText:
                      "Customer Address",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.location_on,
                          color: Colors.teal,
                        ),
                        onPressed:
                        getCurrentLocation,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                        if (customerNameController.text.isEmpty ||
                            customerAddressController.text.isEmpty ||
                            invoiceSuffixController.text.isEmpty) {

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Please fill all required fields",
                              ),
                            ),
                          );

                          return;
                        }

                        String invoiceNo =
                            "CEMD/$selectedInvoiceYear/${invoiceSuffixController.text}";

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductPricingScreen(
                              invoiceNumber: invoiceNo,
                              customerName: customerNameController.text,
                              customerAddress: customerAddressController.text,
                              customerContact: buyerOrderNoController.text,
                            ),
                          ),
                        );
                      },
                      style:
                      ElevatedButton.styleFrom(
                        backgroundColor:
                        Colors.teal,
                        foregroundColor:
                        Colors.white,
                        padding:
                        const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                      ),
                      child: const Text(
                        "Next",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}