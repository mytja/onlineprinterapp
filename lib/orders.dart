import 'dart:convert';
import 'package:onlineprinterapp/widgets/drawer.dart';

import 'order.dart';

import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  Orders(
      {Key? key,
      required this.username,
      required this.password,
      required this.json})
      : super(key: key);

  final String username;
  final String password;
  final String json;

  @override
  OrdersMain createState() => OrdersMain();
}

class OrdersMain extends State<Orders> {
  Color colorfromhex(String color) {
    String hex = color.replaceAll("#", "");
    Color col = Color(int.parse(hex, radix: 16)).withOpacity(1.0);
    return col;
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    var jsonL = json.decode(widget.json);
    var jsonOrders = jsonL["orders"];

    print(jsonOrders);

    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            body: Column(children: <Widget>[
              Container(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  Container(width: 5),
                  Container(
                      width: width / 2,
                      child: Text("Filename",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(width: 10),
                  Container(
                      width: width / 10,
                      child: Text("ID",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      width: width / 3 - 6,
                      child: Text("Details",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ],
              ),
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8),
                  itemCount: jsonOrders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      height: 50,
                      width: width,
                      child: Row(
                        children: <Widget>[
                          Container(
                              width: width / 2,
                              child: Text(jsonOrders[index]["filename"])),
                          Container(
                            width: 5,
                            color: colorfromhex(jsonOrders[index]["color"]),
                          ),
                          Container(width: 5),
                          Container(
                              width: width / 10,
                              child: Text(
                                jsonOrders[index]["id"].toString(),
                              )),
                          Container(
                              width: width / 3 - 6,
                              child: ElevatedButton(
                                child: Text("DETAILS"),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Order(
                                              id: jsonOrders[index]["id"],
                                              username: widget.username,
                                              password: widget.password,
                                            )),
                                  );
                                },
                              ))
                        ],
                      ),
                    );
                  })
            ]),
            appBar: AppBar(title: Text("OnlinePrinterApp")),
            drawer: PrinterDrawer(
                username: widget.username, password: widget.password)));
  }
}
