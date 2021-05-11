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

import 'package:fl_flash/fl_flash.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, required this.username, required this.password})
      : super(key: key);

  final String username;
  final String password;

  @override
  DashboardWidget createState() => DashboardWidget();
}

class DashboardWidget extends State<Dashboard> {
  Map jsonArchive = {};

  static Timer? timer;

  @override
  void initState() {
    super.initState();
    const oneSecond = const Duration(seconds: 2);
    timer = Timer.periodic(oneSecond, (Timer t) async {
      String snapdata =
          await DashboardUtils.getPrinter(widget.username, widget.password);
      bool stateRefresh = false;
      try {
        json.decode(snapdata);
        stateRefresh = true;
      } catch (e) {
        stateRefresh = false;
      }
      if (stateRefresh) {
        setState(() {});
      }
    });
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: DashboardUtils.getPrinter(widget.username, widget.password),
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
              if (jsonL["status"] == "Printing" ||
                  jsonL["status"] == "Operational" ||
                  jsonL["status"] == "Printing from SD") {
                Flash status = Flash(
                    mainText: Text("Status: " + jsonL["status"],
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.green.shade400,
                    icon: Icon(Icons.check));
                FlashManager.add(status);
              } else {
                Flash status = Flash(
                    mainText: Text("Status: " + jsonL["status"],
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.red.shade300,
                    icon: Icon(Icons.cancel));
                FlashManager.add(status);
              }
              app = MaterialApp(
                home: Scaffold(
                  appBar: AppBar(title: Text("OnlinePrinterApp")),
                  drawer: PrinterDrawer(
                      password: widget.password, username: widget.username),
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
                              'Hello, ' + widget.username,
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
                        (() {
                          return MaterialFlash(limit: 1);
                        }()),
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
                                child: Container(
                                    width: width / 2 - 4,
                                    child: (() {
                                      if (jsonL != {} ||
                                          jsonL != null ||
                                          jsonL["temp"] != null) {
                                        return Text(
                                          jsonL["temp"]["bed"]["current"]
                                              .toString(),
                                        );
                                      }
                                    }())),
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
                                  child: (() {
                                    if (jsonL != {} ||
                                        jsonL != null ||
                                        jsonL["temp"] != null) {
                                      return Text(
                                        jsonL["temp"]["bed"]["target"]
                                            .toString(),
                                      );
                                    }
                                  }())),
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
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                              Container(
                                  width: width / 2 - 4,
                                  child: (() {
                                    if (jsonL != {} ||
                                        jsonL != null ||
                                        jsonL["temp"] != null) {
                                      return Text(
                                        jsonL["temp"]["nozzle"]["current"]
                                            .toString(),
                                      );
                                    }
                                  }())),
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
                                child: Container(
                                    width: width / 2 - 4,
                                    child: (() {
                                      if (jsonL != {} ||
                                          jsonL != null ||
                                          jsonL["temp"] != null) {
                                        return Text(
                                          jsonL["temp"]["nozzle"]["target"]
                                              .toString(),
                                        );
                                      }
                                    }())),
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
                        ])),
                        (() {
                          bool canAbort = false;
                          try {
                            canAbort =
                                json.decode(snapshot.data)["abort"]["canAbort"];
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
                                            widget.username +
                                            "&password=" +
                                            widget.password));
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
  static Future<String> getPrinter(String username, String password) async {
    var printer = await http.get(Uri.parse(SERVER_URL_PRINTER +
        "?username=" +
        username +
        "&password=" +
        password));
    return printer.body.toString();
  }
}
