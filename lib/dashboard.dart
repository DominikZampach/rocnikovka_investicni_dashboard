import 'package:flutter/material.dart';
import 'package:rocnikovka_investicni_dashboard/add_stock_page.dart';
import 'package:rocnikovka_investicni_dashboard/func/files.dart';
import 'package:rocnikovka_investicni_dashboard/func/stock.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int itemCount = 0;
  late List<Stock> followedStocksList = [];
  final TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);
  late Stock selectedStock = Stock("None", "NNNN");

  @override
  void initState() {
    setState(() {
      setVariables();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setVariables() async {
    int itemCountCall = await getNumberOfFollowedItems();
    List<Stock> followedStocksListCall = await getAllFollowedStocks();
    setState(() {
      itemCount = itemCountCall;
      followedStocksList = followedStocksListCall;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarDashboard(context),
      body: bodyDashboard(context),
    );
  }

  Container bodyDashboard(BuildContext context) {
    return Container(
        color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            bodyDashboardListFollowedStocks(context),
            bodyDashboardGraph(context)
          ],
        ));
  }

  Column bodyDashboardGraph(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 4 * 0.15,
        ),
        Container(
            height: MediaQuery.of(context).size.height / 4 * 2.7,
            width: MediaQuery.of(context).size.width * 0.38,
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
                border: Border.all(
                    width: 1,
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(.3)),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            child: drawGraphOfStock()),
        Padding(
          padding: const EdgeInsets.only(top: 30.0),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red.shade300),
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddStockPage()));
              },
              child: Text(
                "Add stock",
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03,
                    color: Colors.white),
              )),
        )
      ],
    );
  }

  Container bodyDashboardListFollowedStocks(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),
      width: MediaQuery.of(context).size.width * 0.6,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
            border: Border.all(
                color: Theme.of(context).colorScheme.secondary.withOpacity(.3)),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(.3),
                      border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(.3)),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: ListTile(
                    onTap: () async {
                      listTileOnTap(index, context);
                    },
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "${followedStocksList[index].symbol} - ${followedStocksList[index].name}",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.05),
                        ),
                        FutureBuilder<double?>(
                          future: followedStocksList[index].currentPrice(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              return Text(
                                "${snapshot.data} \$",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.05),
                              );
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void listTileOnTap(int index, BuildContext context) {
    setState(() {
      selectedStock = followedStocksList[index];
    });
  }

  Widget drawGraphOfStock() {
    if (selectedStock.name == "None") {
      return Container(
        color: Colors.transparent,
      );
    }
    return SfCartesianChart(
      title:
          ChartTitle(text: '${selectedStock.name} - (${selectedStock.symbol})'),
      legend: const Legend(
        isVisible: false,
      ),
      primaryXAxis: const CategoryAxis(interval: 1),
      primaryYAxis: const NumericAxis(
        labelFormat: '{value}\$',
        interval: 5,
      ),
      series: <CartesianSeries>[
        LineSeries<ChartData, String>(
          color: Colors.grey.shade800,
          name: selectedStock.name,
          dataSource: selectedStock.getColumnData(),
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.price,
          markerSettings: const MarkerSettings(isVisible: true),
        )
      ],
      tooltipBehavior: _tooltipBehavior,
    );
  }

  AppBar appBarDashboard(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height / 9.5,
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(.3),
      title: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 7),
        child: const Text(
          "Dashboard",
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

//TODO stránka na API: https://rapidapi.com/api4stocks/api/apistocks