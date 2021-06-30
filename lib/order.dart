import 'dart:convert';

import 'package:fl_flash/fl_flash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/crypto.dart';
import 'package:onlineprinterapp/screens/exception.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'constants/constants.dart';

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
      String url = SERVER_URL_ORDER + id.toString();
      print(url);
      var response = await http.get(Uri.parse(url),
          headers: auth.getBasicHeader(username, password));
      return response.body.toString();
    }
  }

  void startPrintFlash(int responseCode) {
    if (300 > responseCode && responseCode > 199) {
      Flash startprint = Flash(
          id: "startprint",
          mainText: const Text(
            "Successfully started to print",
          ),
          icon: Icon(Icons.check),
          backgroundColor: Colors.green.shade400);
      FlashManager.add(startprint);
      setState(() {});
    } else {
      Flash startprint = Flash(
          id: "startprint",
          mainText: const Text(
            "Failed to start a print. \nSomething is already printing",
          ),
          icon: Icon(Icons.cancel),
          backgroundColor: Colors.red.shade400);
      FlashManager.add(startprint);
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
        theme: Themes.LightTheme(),
        darkTheme: Themes.DarkTheme(),
        themeMode: Themes.Theme(),
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
                      const SizedBox(height: 10),
                      MaterialFlash(
                        ignore: ["printstatus", "registerfailed"],
                        deleteAll: true,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(children: [
                        const SizedBox(
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
                        const SizedBox(
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
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                            width: width / 3 - 5,
                            child: Text("Status",
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        Container(
                            width: width / 3 * 2, child: Text(jsonL["status"]))
                      ]),
                      const SizedBox(
                        width: 5,
                      ),
                      Row(children: [
                        const SizedBox(
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
                                var r = await http.get(
                                    Uri.parse(SERVER_URL_ORDER_START +
                                        jsonL["id"].toString()),
                                    headers: auth.getBasicHeader(
                                        widget.username, widget.password));
                                print(r.body);
                                var jsonL2 = json.decode(r.body);
                                startPrintFlash(jsonL2["responseCode"]);
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
                children = Exception.exception(snapshot.error);
              } else {
                children = <Widget>[
                  Container(
                    height: 20,
                  ),
                  Center(
                      child: SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  )),
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }
              return Center(
                child: ListView(
                  physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  children: children,
                ),
              );
            },
          ),
        ));
  }
}
