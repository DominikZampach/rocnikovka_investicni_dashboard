import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

const url = 'https://apistocks.p.rapidapi.com';

class Stock {
  final String name;
  final String symbol;
  Map<String, double>? last14DaysPrice;

  Stock(this.name, this.symbol);

  Future<Map<String, double>> getLast7DaysPrice() async {
    var headers = {
      'X-RapidAPI-Key': '22f33d4312msh9d02f01a0a61cabp1b11ebjsnb119cc325a50',
      'X-RapidAPI-Host': 'apistocks.p.rapidapi.com'
    };

    var response = await http.get(
        Uri.parse(
            "$url/daily?symbol=$symbol&dateStart=${getDateFromFourteenDaysAgo()}&dateEnd=${getCurrentDate()}"),
        headers: headers);

    if (response.statusCode == 200) {
      Map<String, dynamic> responseBody = json.decode(response.body);
      Map<String, double> values = {};

      for (int i = 0; i < responseBody["Results"].length; i++) {
        String date = responseBody["Results"][i]["Date"];
        double close =
            double.parse(responseBody["Results"][i]["Close"].toString());
        values[date] = close;
      }

      //print(values.toString());
      last14DaysPrice = values;
      return values;
    } else {
      throw Exception(
          'Failed to load data from server: ${response.statusCode}');
    }
  }

  Future<double?> currentPrice() async {
    await getLast7DaysPrice();
    String currentDate = getCurrentDate();
    if (last14DaysPrice![currentDate] == null) {
      List<DateTime> dates =
          last14DaysPrice!.keys.map((key) => DateTime.parse(key)).toList();
      dates.sort((a, b) => b.compareTo(a));
      DateTime newestDate = dates.first;
      String formatedNewestDate = DateFormat('yyyy-MM-dd').format(newestDate);
      return last14DaysPrice![formatedNewestDate];
    }
    return last14DaysPrice![currentDate];
  }

  String getCurrentDate() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    return formattedDate;
  }

  String getDateFromFourteenDaysAgo() {
    DateTime now = DateTime.now();
    DateTime fourteenDaysAgo = now.subtract(const Duration(days: 14));
    String formattedDate = DateFormat('yyyy-MM-dd').format(fourteenDaysAgo);
    return formattedDate;
  }

  List<ChartData>? getColumnData() {
    List<DateTime> dates =
        last14DaysPrice!.keys.map((key) => DateTime.parse(key)).toList();
    dates.sort((a, b) => b.compareTo(a));

    List<String> formatedDates = [];
    dates.forEach((element) {
      formatedDates.add(DateFormat('yyyy-MM-dd').format(element));
    });
    formatedDates = formatedDates.reversed.toList();
    //print(formatedDates);

    List<ChartData> columnData = [];
    for (int i = 0; i < formatedDates.length; i++) {
      columnData.add(ChartData(
          formatedDates[i].substring(5), last14DaysPrice![formatedDates[i]]!));
    }
    //columnData.forEach((element) {
    //  print("${element.date} - ${element.price}");
    //});
    return columnData;
  }
}

class ChartData {
  ChartData(this.date, this.price);
  final String date;
  final double price;
}
