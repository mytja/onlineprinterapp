import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/dashboard_widgets/archive.dart';
import 'package:onlineprinterapp/dashboard_widgets/layout.dart';
import 'package:onlineprinterapp/screens/exception.dart';
import 'package:onlineprinterapp/widgets/splashscreen.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:onlineprinterapp/widgets/unlockbutton.dart';
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

  void abortPrintFlash(int responseCode) {
    if (300 > responseCode && responseCode > 199) {
      Flash startprint = Flash(
          id: "startprint",
          mainText: Text(
            "Successfully started to print",
          ),
          icon: Icon(Icons.check),
          backgroundColor: Colors.green.shade400);
      FlashManager.add(startprint);
      setState(() {});
    } else {
      Flash startprint = Flash(
          id: "startprint",
          mainText: Text(
            "Failed to start a print. \nSomething is already printing",
          ),
          icon: Icon(Icons.cancel),
          backgroundColor: Colors.red.shade400);
      FlashManager.add(startprint);
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    //print(nozzleTempArchive);
    return FutureBuilder<String>(
        future: DashboardUtils.getPrinter(widget.username, widget.password),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (tempArchive.bedTempArchive.length > 12) {
            tempArchive.bedTempArchive.removeAt(0);
          }
          if (tempArchive.nozzleTempArchive.length > 12) {
            tempArchive.nozzleTempArchive.removeAt(0);
          }
          Widget app;
          if (snapshot.hasData) {
            String? snapdata = snapshot.data;
            if (snapdata != null) {
              Map jsonL = {};
              try {
                jsonL = json.decode(snapdata);
                jsonArchive = jsonL;
              } catch (e) {
                print("Using JSON archive");
                jsonL = jsonArchive;
              }
              //print(jsonL);
              if (jsonL["status"] == "Printing" ||
                  jsonL["status"] == "Operational" ||
                  jsonL["status"] == "Printing from SD") {
                Flash status = Flash(
                    id: "printstatus",
                    mainText: Text("Status: " + jsonL["status"],
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold)),
                    backgroundColor: Colors.green.shade400,
                    icon: Icon(Icons.check));
                FlashManager.add(status);
              } else {
                if (jsonL["status"] != null) {
                  Flash status = Flash(
                      id: "printstatus",
                      mainText: Text("Status: " + jsonL["status"],
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.red.shade300,
                      icon: Icon(Icons.cancel));
                  FlashManager.add(status);
                }
              }
              app = MaterialApp(
                home: Scaffold(
                    floatingActionButton: UnlockButton(
                        password: widget.password, username: widget.username),
                    appBar: AppBar(title: Text("OnlinePrinterApp")),
                    drawer: PrinterDrawer(
                        password: widget.password, username: widget.username),
                    body: DashboardLayout(
                        jsonL: jsonL,
                        username: widget.username,
                        password: widget.password)),
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
