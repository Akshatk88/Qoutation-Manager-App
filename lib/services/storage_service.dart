import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveData(Map<String, String> data) async {
    final prefs = await SharedPreferences.getInstance();
    data.forEach((k, v) => prefs.setString(k, v));
  }

  static Future<Map<String, String>> getData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'price': prefs.getString('price') ?? '',
      'discount': prefs.getString('discount') ?? '',
      'quantity': prefs.getString('quantity') ?? '',
      'totalPrice': prefs.getString('totalPrice') ?? '',
      'cuvette': prefs.getString('cuvette') ?? '',
      'paymentType': prefs.getString('paymentType') ?? '',
    };
  }
}
