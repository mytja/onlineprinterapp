import 'dart:convert';

import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  Orders({Key key, this.title, this.username, this.password, this.json})
      : super(key: key);

  final String title;
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
    double height = MediaQuery.of(context).size.height;

    var jsonL = json.decode(widget.json);
    var jsonOrders = jsonL["orders"];

    print(jsonOrders);
    print(jsonOrders[0]);

    return MaterialApp(
        home: Scaffold(
      body: Column(children: <Widget>[
        Container(
          height: 20,
        ),
        Row(
          children: <Widget>[
            Container(width: 5),
            Container(
                width: width / 4,
                child: Text("Name",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                width: width / 4,
                child: Text("Filename",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                width: width / 4,
                child: Text("Status",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(
                width: width / 4 - 5,
                child:
                    Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
          ],
        ),
        /*
        ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: jsonOrders.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 50,
                  width: double.infinity,
                  //color: colorfromhex(jsonOrders[index]["color"]),
                  child: Row(
                    children: <Widget>[
                      Text(jsonOrders[index]["oldFilename"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(jsonOrders[index]["filename"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(jsonOrders[index]["status"],
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(jsonOrders[index]["date"].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(jsonOrders[index]["id"].toString(),
                          style: TextStyle(fontWeight: FontWeight.bold))
                    ],
                  ));
            })
            */
      ]),
      appBar: AppBar(title: Text("OnlinePrinterApp")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text("OnlinePrinterApp - Dashboard"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text("Dashboard"),
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            ListTile(
              title: Text('Orders'),
            ),
          ],
        ),
      ),
    ));
  }
}
