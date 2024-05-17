import 'package:flutter/material.dart';
import 'package:rocnikovka_investicni_dashboard/dashboard.dart';
import 'package:rocnikovka_investicni_dashboard/func/files.dart';
import 'package:rocnikovka_investicni_dashboard/func/stock.dart';

final List<Stock> allStocks = [
  Stock("Apple", "AAPL"),
  Stock("Microsoft", "MSFT"),
  Stock("Amazon.com", "AMZN"),
  Stock("Meta Platforms", "META"),
  Stock("Tesla", "TSLA"),
  Stock("Netflix", "NFLX"),
  Stock("NVIDIA", "NVDA"),
  Stock("Johnson & Johnson", "JNJ"),
  Stock("JPMorgan Chase &", "JPM"),
  Stock("Visa", "V"),
  Stock("Alphabet", "GOOGL"),
  Stock("Bank of America", "BAC"),
  Stock("Adobe", "ADBE"),
  Stock("Coca-Cola", "KO"),
  Stock("Intel", "INTC"),
  Stock("McDonald's", "MCD"),
  Stock("Mastercard", "MA"),
  Stock("Chevron", "CVX"),
  Stock("Pfizer", "PFE"),
  Stock("Eli Lilly", "LLY")
];

class AddStockPage extends StatefulWidget {
  const AddStockPage({super.key, required this.followedStocks});
  final List<Stock> followedStocks;

  @override
  State<AddStockPage> createState() => _AddStockPageState();
}

class _AddStockPageState extends State<AddStockPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarAddStockPage(context),
        body: Container(
          color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
          child: Container(
              margin: const EdgeInsets.only(
                  top: 30.0, bottom: 30.0, left: 40.0, right: 40.0),
              decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.secondary.withOpacity(.3),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(.3)),
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
              child: ListView.builder(
                itemCount: allStocks.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 14.0, right: 14.0),
                    child: Container(
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
                          onTap: () async {},
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${allStocks[index].symbol} - ${allStocks[index].name}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.05),
                              ),
                              addOrRemoveButton(allStocks[index])
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )),
        ));
  }

  IconButton addOrRemoveButton(Stock currentStock) {
    for (int i = 0; i < widget.followedStocks.length; i++) {
      if (currentStock.symbol == widget.followedStocks[i].symbol) {
        return IconButton.filledTonal(
          onPressed: () {
            setState(() {
              for (int i = 0; i < widget.followedStocks.length; i++) {
                if (widget.followedStocks[i].symbol == currentStock.symbol) {
                  widget.followedStocks.removeAt(i);
                  break;
                }
              }
            });
          },
          icon: const Icon(Icons.remove),
          color: Colors.white60,
          style: IconButton.styleFrom(backgroundColor: Colors.red),
          iconSize: 45,
        );
      }
    }
    return IconButton.filledTonal(
      onPressed: () {
        setState(() {
          widget.followedStocks.add(currentStock);
        });
      },
      icon: const Icon(Icons.add),
      color: Colors.white60,
      style: IconButton.styleFrom(backgroundColor: Colors.green),
      iconSize: 45,
    );
  }

  AppBar appBarAddStockPage(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(.3),
      toolbarHeight: 70,
      leading: leadingAddStockPage(context),
      title: const Padding(
        padding: EdgeInsets.only(top: 10),
        child: Text(
          "List of stocks",
          style: TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
        ),
      ),
      centerTitle: true,
    );
  }

  Padding leadingAddStockPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: IconButton(
        onPressed: () async {
          await saveFollowedStocks(widget.followedStocks);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Dashboard()));
        },
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
        highlightColor: Colors.transparent,
        iconSize: 45,
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.black,
        ),
        color: Theme.of(context).colorScheme.secondary.withOpacity(.3),
      ),
    );
  }
}
