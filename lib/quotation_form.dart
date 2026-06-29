import 'package:flutter/material.dart';
import 'price_calculation_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:country_picker/country_picker.dart';

class QuotationForm extends StatefulWidget {
  const QuotationForm({super.key});

  @override
  State<QuotationForm> createState() => _QuotationFormState();
}

class _QuotationFormState extends State<QuotationForm> {

  final TextEditingController quotationController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String selectedCountryCode = "+91";
  String selectedFlag = "🇮🇳";

  String selectedCustomerType = "Hospital";

  final List<String> customerTypes = [
    "Hospital",
    "Labs",
    "Clinic",
    "NGO's",
    "Others",
  ];

  // ================= QUOTATION NUMBER GENERATOR =================
  void generateQuotationNumber() {
    final now = DateTime.now();
    final number = now.millisecondsSinceEpoch.toString().substring(10);
     quotationController.text = "CEMD-Q/25-26/$number";
  }

  // ================= LOCATION FUNCTION =================
  Future<void> getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enable location services")),
        );
        return;
      }

      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Location permission permanently denied"),
          ),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        forceAndroidLocationManager: true,
        timeLimit: const Duration(seconds: 20),
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to fetch address")),
        );
        return;
      }

      Placemark place = placemarks.first;

      String fullAddress = [
        place.name,
        place.street,
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((element) => element != null && element!.isNotEmpty).join(", ");

      setState(() {
        addressController.text = fullAddress;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch location")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF5D8F8A),
      body: SafeArea(
        child: Column(
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: const [
                  Icon(Icons.description, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "New Quotation",
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

                            const SizedBox(height: 20),

                            // ================= QUOTATION NUMBER =================
                            Row(
                              children: [

                                Expanded(
                                  flex: 7,
                                  child: TextField(
                                    controller: quotationController,
                                    decoration: InputDecoration(
                                      prefixIcon: const Icon(Icons.confirmation_number, color: Colors.teal),
                                      labelText: "Qtn No.",
                                      labelStyle: const TextStyle(color: Colors.teal),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(color: Colors.teal, width: 2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    minimumSize: const Size(80, 55),
                                  ),
                                  onPressed: generateQuotationNumber,
                                  child: const Text(
                                    "Auto",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 25),

                            buildTextField(
                              controller: nameController,
                              label: "Customer Name",
                              icon: Icons.person,
                            ),

                            const SizedBox(height: 20),

                            Row(
                              children: [

                                Expanded(
                                  flex: 4,
                                  child: InkWell(
                                    onTap: () {
                                      showCountryPicker(
                                        context: context,
                                        showPhoneCode: true,
                                        onSelect: (Country country) {
                                          setState(() {
                                            selectedCountryCode = "+${country.phoneCode}";
                                            selectedFlag = country.flagEmoji;
                                          });
                                        },
                                      );
                                    },
                                    child: Container(
                                      height: 60,
                                      padding: const EdgeInsets.symmetric(horizontal: 6),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.teal),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [

                                          Text(
                                            selectedFlag,
                                            style: const TextStyle(fontSize: 18),
                                          ),

                                          const SizedBox(width: 4),

                                          Flexible(
                                            child: Text(
                                              selectedCountryCode,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          const Icon(Icons.arrow_drop_down, size: 20),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

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

                            TextField(
                              controller: addressController,
                              maxLines: 3,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.location_on,
                                      color: Colors.teal),
                                  onPressed: getCurrentLocation,
                                ),
                                labelText: "Customer Address",
                                labelStyle:
                                const TextStyle(color: Colors.teal),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                minimumSize:
                                const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PriceCalculationScreen(
                                      quotationNumber: quotationController.text,
                                      customerName: nameController.text,
                                      customerContact:
                                      "$selectedCountryCode ${contactController.text}",
                                      customerAddress:
                                      addressController.text,
                                    ),
                                  ),
                                );
                              },
                              child: const Text(
                                "Next",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}