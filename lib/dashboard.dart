import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/screens/exception.dart';
import 'package:onlineprinterapp/widgets/splashscreen.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:onlineprinterapp/widgets/waiting.dart';
import 'constants/constants.dart';
import 'widgets/drawer.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.username, required this.password})
      : super(key: key);

  final String username;
  final String password;

  @override
  DashboardMain createState() => DashboardMain();
}

class DashboardWidget {
  DashboardWidget(
      {required this.username, required this.password, required this.context});

  final String username;
  final String password;
  final BuildContext context;

  Map jsonArchive = {};

  Widget buildWidget() {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: DashboardUtils.getPrinter(username, password),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Widget app;
          if (snapshot.hasData) {
            String? snapdata = snapshot.data[0];
            if (snapdata != null) {
              Map jsonL = {};
              try {
                jsonL = json.decode(snapdata);
                jsonArchive = jsonL;
              } catch (e) {
                print("Using JSON archive");
                jsonL = jsonArchive;
              }
              app = MaterialApp(
                home: Scaffold(
                  appBar: AppBar(title: Text("OnlinePrinterApp")),
                  drawer: PrinterDrawer(
                      password: this.password, username: this.username),
                  body: ListView(
                      physics: BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        Container(
                          height: 10,
                        ),
                        Container(
                          height: 35,
                          child: Center(
                            child: Text(
                              'Hello, ' + username,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 26),
                            ),
                          ),
                        ),
                        Container(
                            height: 20,
                            child: Center(
                                child: Text(
                              'Welcome to OnlinePrinter Dashboard.',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                        username +
                                        "&password=" +
                                        password));
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
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
                                        username +
                                        "&password=" +
                                        password));
                                print(response.statusCode);
                              } catch (e) {
                                print(e);
                              }
                            },
                          )
                        ])),
                        (() {
                          bool canAbort = false;
                          try {
                            canAbort =
                                json.decode(snapshot.data[1])["canAbort"];
                          } catch (e) {
                            canAbort = false;
                          }
                          if (canAbort == true) {
                            return Card(
                                child: Column(children: [
                              Container(
                                  height: 20,
                                  child: Center(
                                      child: Text(
                                    'Print',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ))),
                              Container(
                                height: 10,
                              ),
                              ElevatedButton(
                                  child: Text("Abort print"),
                                  onPressed: () async {
                                    http.Response response = await http.get(
                                        Uri.parse(SERVER_URL_ABORT_PRINT +
                                            "?username=" +
                                            username +
                                            "&password=" +
                                            password));
                                    print(response.body.toString());
                                    print(response.statusCode);
                                  }),
                            ]));
                          } else {
                            return Container(height: 1);
                          }
                        }())
                      ]),
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
            } else {
              app = ExceptionApp(
                exception: "Request has returned null",
              );
            }
          } else if (snapshot.hasError) {
            print("Error");
            app = MaterialApp(
              home: Scaffold(
                  body: ListView(children: [
                Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                )
              ])),
              theme: Themes.LightTheme(),
              darkTheme: Themes.DarkTheme(),
              themeMode: Themes.Theme(),
            );
          } else {
            app = MaterialApp(
              home: Scaffold(
                  body: ListView(
                      children: [Splash(), Container(height: 20), Waiting()])),
              theme: Themes.LightTheme(),
              darkTheme: Themes.DarkTheme(),
              themeMode: Themes.Theme(),
            );
          }
          return app;
        });
  }
}

class DashboardUtils {
  static Future<List<String>> getPrinter(
      String username, String password) async {
    var printer = await http.get(Uri.parse(SERVER_URL_PRINTER));
    var canAbort = await http.get(Uri.parse(SERVER_URL_ABORT_PRINT_CHECK +
        "?username=" +
        username +
        "&password=" +
        password));
    return [printer.body.toString(), canAbort.body.toString()];
  }
}

/// This is the private State class that goes with MyStatefulWidget.
class DashboardMain extends State<Dashboard> {
  static Timer? timer;

  @override
  void initState() {
    super.initState();
    const oneSecond = const Duration(seconds: 2);
    timer = new Timer.periodic(oneSecond, (Timer t) {
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return DashboardWidget(
            username: widget.username,
            password: widget.password,
            context: context)
        .buildWidget();
  }
}
