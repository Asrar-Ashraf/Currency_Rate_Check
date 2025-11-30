import 'dart:convert';

import 'package:http/http.dart' as http;

class Apiservice {
  static const String _key = "fe90ea3c0efd9bebe7ced7d8";
  static const String _baseurl = "https://v6.exchangerate-api.com/v6/$_key";

  Future<Map<String, dynamic>> fetchdata(String currency) async {
    final url = Uri.parse("$_baseurl/latest/$currency");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to load data");
    }
  }

  Future<List<String>> getCurrencyKeys(String currency) async {
    final data = await fetchdata(currency);
    final rates = data["conversion_rates"] as Map<String, dynamic>;
    return rates.keys.toList();
  }
}
