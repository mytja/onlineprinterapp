import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants/constants.dart';

/// This is the stateful widget that the main application instantiates.
class Order extends StatefulWidget {
  Order({Key key, this.id, this.username, this.password}) : super(key: key);

  final int id;
  final String username;
  final String password;

  @override
  OrderMain createState() => OrderMain();
}

/// This is the private State class that goes with MyStatefulWidget.
class OrderMain extends State<Order> {
  Future<String> getOrder(String password, String username, int id) async {
    if (password == "" || username == "") {
      print("None!");
      return "None";
    } else {
      String url = SERVER_URL_ORDER +
          id.toString() +
          "?username=" +
          username +
          "&password=" +
          password;
      print(url);
      var response = await http.get(url);
      return response.body.toString();
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text("OnlinePrinterApp"),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<String>(
        future: getOrder(widget.password, widget.username,
            widget.id), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            var jsonL = json.decode(snapshot.data);
            print(jsonL["responseCode"]);
            if (jsonL["responseCode"] == 200) {
              children = <Widget>[
                Container(
                  height: 20,
                ),
                Row(children: [
                  Container(
                    width: 5,
                  ),
                  Container(
                      width: width / 3 - 5,
                      child: Text("Filename",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      width: width / 3 * 2, child: Text(jsonL["filename"]))
                ]),
                Row(children: [
                  Container(
                    width: 5,
                  ),
                  Container(
                      width: width / 3 - 5,
                      child: Text("ID",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      width: width / 3 * 2, child: Text(jsonL["id"].toString()))
                ]),
                Row(children: [
                  Container(
                    width: 5,
                  ),
                  Container(
                      width: width / 3 - 5,
                      child: Text("Status",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(width: width / 3 * 2, child: Text(jsonL["status"]))
                ]),
                Row(children: [
                  Container(
                    width: 5,
                  ),
                  Container(
                      width: width / 3 - 5,
                      child: Text("Old filename",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(width: width / 3 * 2, child: Text(jsonL["file"]))
                ]),
                Row(children: [
                  Container(
                    width: 5,
                  ),
                  Container(
                      width: width / 3 - 5,
                      child: Text("Start",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                  Container(
                      width: width / 3 * 2,
                      child: ElevatedButton(
                        child: Text("START"),
                        onPressed: () async {
                          var r = await http.get(SERVER_URL_ORDER_START +
                              jsonL["id"].toString() +
                              "?username=" +
                              widget.username +
                              "&password=" +
                              widget.password);
                          print(r.body);
                          var jsonL2 = json.decode(r.body);
                          if (jsonL2["responseCode"] == 204) {
                            return AlertDialog(
                              title: Text('Printing'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Successfully started to print.'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          }
                        },
                      ))
                ]),
              ];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
              Container(
                height: 20,
              ),
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = <Widget>[
              Container(
                height: 20,
              ),
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              children: children,
            ),
          );
        },
      ),
    ));
  }
}
