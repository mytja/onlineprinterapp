import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.username}) : super(key: key);

  final String username;

  @override
  DashboardMain createState() => DashboardMain();
}

class DashboardMain extends State<Dashboard> {
  Future<String> getResponse() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String username = widget.username;
    String usertext = "Hi, " + username;

    return MaterialApp(
      home: Scaffold(
        body: Column(children: <Widget>[
          Container(
            height: 25,
          ),
          Text(
            "Hello, " + username,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          Text(
            "Welcome to OnlinePrinter Dashboard",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          )
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
                title: Text('Orders'),
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Work in progress",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              ),
              ListTile(
                title: Text('Camera stream'),
                onTap: () {
                  Fluttertoast.showToast(
                      msg: "Work in progress",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
