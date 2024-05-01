import 'dart:collection';

import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:rocnikovka_investicni_dashboard/func/stock.dart';

Map<String, dynamic> defaultInput = {
  "flwCount": 2,
  "followed": [
    {"name": "Apple", "symbol": "AAPL"},
    {"name": "Google", "symbol": "GOOG"}
  ]
};

Future<int> getNumberOfFollowedItems() async {
  await createDataJSON();
  Map<String, dynamic> jsonData = await loadJSON();
  return jsonData["flwCount"];
}

Future<void> createDataJSON() async {
  if (await doesDataJsonExist()) {
    return;
  }
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  final Directory investFolder =
      Directory("${documentsDirectory.path}/InvestDashboard/");
  if (!await investFolder.exists()) {
    await investFolder.create(recursive: true);
  }
  String filePath = '${documentsDirectory.path}/InvestDashboard/data.json';
  File file = File(filePath);
  await file.writeAsString(json.encode(defaultInput));
}

Future<bool> doesDataJsonExist() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String filePath = '${documentsDirectory.path}/InvestDashboard/data.json';
  File file = File(filePath);
  return await file.exists();
}

Future<Map<String, dynamic>> loadJSON() async {
  Directory documentsDirectory = await getApplicationDocumentsDirectory();
  String filePath = '${documentsDirectory.path}/InvestDashboard/data.json';
  print(filePath); // For testing
  File file = File(filePath);
  String jsonString = await file.readAsString();
  return json.decode(jsonString);
}

Future<List<Stock>> getAllFollowedStocks() async {
  Map<String, dynamic> loadedJson = await loadJSON();
  List<Stock> returnList = [];
  for (int i = 0; i < loadedJson["flwCount"]; i++) {
    returnList.add(convertJsonToStock(loadedJson["followed"][i]));
  }
  return returnList;
}

Stock convertJsonToStock(var item) {
  String name = item["name"];
  String symbol = item["symbol"];
  return Stock(name, symbol);
}
