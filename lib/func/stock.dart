import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

const url = 'https://apistocks.p.rapidapi.com';

class Stock {
  final String name;
  final double price;
  final String symbol;

  Stock(this.name, this.symbol, this.price);

  Future<Map<String, double>> getLast7DaysPrice() async {
    var headers = {
      'X-RapidAPI-Key': '22f33d4312msh9d02f01a0a61cabp1b11ebjsnb119cc325a50',
      'X-RapidAPI-Host': 'apistocks.p.rapidapi.com'
    };

    var response = await http.get(
        Uri.parse(
            "$url/daily?symbol=$symbol&dateStart=${getDateFromSevenDaysAgo()}&dateEnd=${getCurrentDate()}"),
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      Map<String, double> values = {};

      for (int i = 0; i < 5; i++) {
        String date = responseBody["Results"][i]["Date"];
        double close =
            double.parse(responseBody["Results"][i]["Close"].toString());
        values[date] = close;
      }

      print(values.toString());
      return values;
    } else {
      throw Exception(
          'Failed to load data from server: ${response.statusCode}');
    }
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getDateFromSevenDaysAgo() {
    DateTime now = DateTime.now();
    DateTime sevenDaysAgo = now.subtract(const Duration(days: 7));
    String formattedDate = DateFormat('yyyy-MM-dd').format(sevenDaysAgo);
    return formattedDate;
  }
}
