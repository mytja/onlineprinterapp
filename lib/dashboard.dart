import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/widgets/waiting.dart';
import 'constants/constants.dart';
import 'widgets/drawer.dart';
import 'package:http/http.dart' as http;

class DApp extends StatelessWidget {
  DApp({required this.username, required this.password});

  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("OnlinePrinterApp")),
        drawer: PrinterDrawer(password: this.password, username: this.username),
        body: Dashboard(password: this.password, username: this.username),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    );
  }
}

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.username, required this.password})
      : super(key: key);

  final String username;
  final String password;

  @override
  DashboardMain createState() => DashboardMain();
}

/// This is the private State class that goes with MyStatefulWidget.
class DashboardMain extends State<Dashboard> {
  final waiting = Waiting();

  @override
  void initState() {
    super.initState();
    setState(() {
      const oneSecond = const Duration(seconds: 2);
      new Timer.periodic(oneSecond, (Timer t) => setState(() {}));
    });
  }

  Future<String> getPrinter() async {
    var response = await http.get(Uri.parse(SERVER_URL_PRINTER));
    return response.body.toString();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder<String>(
        future: getPrinter(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            String? snapdata = snapshot.data;
            if (snapdata != null) {
              var jsonL = json.decode(snapdata);
              children = <Widget>[
                Container(
                  height: 10,
                ),
                Container(
                  height: 35,
                  child: Center(
                    child: Text(
                      'Hello, ' + widget.username,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                    ),
                  ),
                ),
                Container(
                    height: 20,
                    child: Center(
                        child: Text(
                      'Welcome to OnlinePrinter Dashboard.',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ))),
                Container(
                  height: 20,
                ),
                Card(
                    child: Row(
                  children: [
                    Container(
                      width: 5,
                    ),
                    Container(
                      width: width / 2 - 5 - 4,
                      child: Text(
                        'Status',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Container(
                      width: width / 2 - 4,
                      child: Text(
                        jsonL["status"].toString(),
                      ),
                    ),
                  ],
                )),
                Container(
                  height: 20,
                ),
                Card(
                    child: Column(children: [
                  Container(
                      height: 20,
                      child: Center(
                          child: Text(
                        'Bed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ))),
                  Container(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 5,
                      ),
                      Container(
                        width: width / 2 - 5 - 4,
                        child: Text(
                          'Current temperature',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        width: width / 2 - 4,
                        child: Text(
                          jsonL["temp"]["bed"]["current"].toString(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 5,
                      ),
                      Container(
                        width: width / 2 - 5 - 4,
                        child: Text(
                          'Target temperature',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        width: width / 2 - 4,
                        child: Text(
                          jsonL["temp"]["bed"]["target"].toString(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Temperature',
                    ),
                    onSubmitted: (String temp) async {
                      try {
                        var temperature = int.parse(temp);
                        var response = await http.get(Uri.parse(
                            SERVER_URL_BED_SET +
                                temperature.toString() +
                                "?username=" +
                                widget.username +
                                "&password=" +
                                widget.password));
                        print(response.statusCode);
                      } catch (e) {
                        print(e);
                      }
                    },
                  ),
                ])),
                Container(
                  height: 20,
                ),
                Card(
                    child: Column(children: [
                  Container(
                      height: 20,
                      child: Center(
                          child: Text(
                        'Nozzle',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ))),
                  Container(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 5,
                      ),
                      Container(
                        width: width / 2 - 5 - 4,
                        child: Text(
                          'Current temperature',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        width: width / 2 - 4,
                        child: Text(
                          jsonL["temp"]["nozzle"]["current"].toString(),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 5,
                      ),
                      Container(
                        width: width / 2 - 5 - 4,
                        child: Text(
                          'Target temperature',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Container(
                        width: width / 2 - 4,
                        child: Text(
                          jsonL["temp"]["nozzle"]["target"].toString(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Temperature',
                    ),
                    onSubmitted: (String temp) async {
                      try {
                        var temperature = int.parse(temp);
                        var response = await http.get(Uri.parse(
                            SERVER_URL_NOZZLE_SET +
                                temperature.toString() +
                                "?username=" +
                                widget.username +
                                "&password=" +
                                widget.password));
                        print(response.statusCode);
                      } catch (e) {
                        print(e);
                      }
                    },
                  )
                ]))
              ];
            } else {
              children = [];
            }
          } else if (snapshot.hasError) {
            children = <Widget>[
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
            children = <Widget>[waiting.waiting()];
          }
          return ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: children,
          );
        });
  }
}
