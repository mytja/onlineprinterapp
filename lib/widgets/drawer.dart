import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/constants.dart';
import '../orders.dart';
import '../dashboard.dart';
import '../camera.dart';
import '../settings.dart';

class PrinterDrawer extends StatefulWidget {
  PrinterDrawer({this.password, this.username});

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
      var response = await http.get(SERVER_URL_ORDERS +
          "?username=" +
          username +
          "&password=" +
          password);
      return response.body.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

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
                color: Colors.blue,
              ),
            ),
          ),
          ListTile(
            title: Text("Dashboard"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DApp(
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
