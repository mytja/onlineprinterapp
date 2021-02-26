import 'dart:convert';
import 'order.dart';

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
                width: width / 2,
                child: Text("Filename",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            Container(width: 10),
            Container(
                width: width / 10,
                child:
                    Text("ID", style: TextStyle(fontWeight: FontWeight.bold))),
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
