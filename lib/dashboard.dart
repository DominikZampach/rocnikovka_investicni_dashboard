import 'package:flutter/material.dart';
import 'package:rocnikovka_investicni_dashboard/func/files.dart';
import 'package:rocnikovka_investicni_dashboard/func/stock.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int itemCount = 0;
  late List<Stock> followedStocksList = [];

  @override
  void initState() {
    setState(() {
      setVariables();
    });
    super.initState();
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
  void dispose() {
    super.dispose();
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
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Container(
                color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
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
                            onTap: () {},
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "${followedStocksList[index].symbol} - ${followedStocksList[index].name}",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                ),
                                Text(
                                  "${followedStocksList[index].price} \$",
                                  style: TextStyle(
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.05),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(25),
              width: MediaQuery.of(context).size.width * 0.4,
              child: const Placeholder(
                color: Colors.blue,
              ),
            )
          ],
        ));
  }

  AppBar appBarDashboard(BuildContext context) {
    return AppBar(
      toolbarHeight: MediaQuery.of(context).size.height / 9.5,
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(.3),
      title: Padding(
        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 7),
        child: Text(
          "Dashboard",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

//TODO stránka na API: https://rapidapi.com/api4stocks/api/apistocks