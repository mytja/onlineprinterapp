import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants/constants.dart';

import 'printerror.dart';

/// This is the stateful widget that the main application instantiates.
class Order extends StatefulWidget {
  Order(
      {Key? key,
      required this.id,
      required this.username,
      required this.password})
      : super(key: key);

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
      var response = await http.get(Uri.parse(url));
      return response.body.toString();
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                String? snapdata = snapshot.data;
                if (snapdata != null) {
                  var jsonL = json.decode(snapdata);
                  print(jsonL);
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
                            width: width / 3 * 2,
                            child: Text(jsonL["filename"]))
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
                            width: width / 3 * 2,
                            child: Text(jsonL["id"].toString()))
                      ]),
                      Row(children: [
                        Container(
                          width: 5,
                        ),
                        Container(
                            width: width / 3 - 5,
                            child: Text("Status",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Container(
                            width: width / 3 * 2, child: Text(jsonL["status"]))
                      ]),
                      Row(children: [
                        Container(
                          width: 5,
                        ),
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
                                var r = await http.get(Uri.parse(
                                    SERVER_URL_ORDER_START +
                                        jsonL["id"].toString() +
                                        "?username=" +
                                        widget.username +
                                        "&password=" +
                                        widget.password));
                                print(r.body);
                                var jsonL2 = json.decode(r.body);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PrintError(
                                            responseCode:
                                                jsonL2["responseCode"],
                                          )),
                                );
                              },
                            ))
                      ]),
                    ];
                  } else {
                    children = [];
                  }
                } else {
                  children = [];
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
