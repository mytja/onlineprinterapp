import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/about.dart';
import 'package:onlineprinterapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../orders.dart';
import '../dashboard.dart';
import '../camera.dart';
import '../settings.dart';

class PrinterDrawer extends StatefulWidget {
  PrinterDrawer({required this.password, required this.username});

  final String username;
  final String password;

  @override
  PrinterDrawerApp createState() => PrinterDrawerApp();
}

class PrinterDrawerApp extends State<PrinterDrawer> {
  Future<String> getOrders(String password, String username) async {
    if (password == "" || username == "") {
      print("None!");
      return "None";
    } else {
      var response = await http.get(Uri.parse(SERVER_URL_ORDERS +
          "?username=" +
          username +
          "&password=" +
          password));
      return response.body.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    var brightness = MediaQuery.of(context).platformBrightness;

    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: width,
            child: DrawerHeader(
              child: Text("OnlinePrinterApp - Dashboard"),
              decoration: BoxDecoration(
                color: (() {
                  if (brightness == Brightness.dark) {
                    return Colors.grey.shade900;
                  } else {
                    return Colors.blue;
                  }
                }()),
              ),
            ),
          ),
          ListTile(
            title: Text("Dashboard"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Dashboard(
                          username: widget.username,
                          password: widget.password,
                        )),
              );
            },
          ),
          ListTile(
            title: Text('Orders'),
            onTap: () async {
              var r = await getOrders(widget.password, widget.username);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Orders(
                          username: widget.username,
                          password: widget.password,
                          json: r,
                        )),
              );
            },
          ),
          ListTile(
            title: Text('Camera Stream'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Camera(
                          username: widget.username,
                          password: widget.password,
                        )),
              );
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Setting(
                        username: widget.username,
                        password: widget.password,
                        sp: prefs)),
              );
            },
          ),
          ListTile(
            title: Text('About'),
            onTap: () async {
              http.Response response = await http.get(Uri.parse(
                  "https://api.github.com/repos/mytja/onlineprinterapp"));
              String text = response.body.toString();
              Map<String, dynamic> jsonL = json.decode(text);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => About(
                            projectJSON: jsonL,
                            username: widget.username,
                            password: widget.password,
                          )));
            },
          ),
          Spacer(),
          ListTile(
            title: Text('Logout'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove("username");
              prefs.remove("password");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => App()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SettingsDrawer extends StatefulWidget {
  SettingsDrawer();

  @override
  SettingDrawer createState() => SettingDrawer();
}

class SettingDrawer extends State<SettingsDrawer> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: width,
            child: DrawerHeader(
              child: Text("OnlinePrinterApp - Dashboard"),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Setting(sp: prefs)),
              );
            },
          ),
        ],
      ),
    );
  }
}
