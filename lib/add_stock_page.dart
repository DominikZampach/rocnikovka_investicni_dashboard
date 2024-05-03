import 'package:flutter/material.dart';

class AddStockPage extends StatelessWidget {
  const AddStockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarAddStockPage(context),
        body: Container(
            color: Theme.of(context).colorScheme.secondary.withOpacity(.3)));
  }

  AppBar appBarAddStockPage(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      leading: leadingAddStockPage(context),
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(.3),
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
        onPressed: () {
          Navigator.pop(context);
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
