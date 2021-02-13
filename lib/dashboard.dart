import 'package:flutter/material.dart';
import 'constants/constants.dart';
import 'orders.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  Dashboard({Key key, this.username, this.password}) : super(key: key);

  final String username;
  final String password;

  @override
  DashboardMain createState() => DashboardMain();
}

class DashboardMain extends State<Dashboard> {
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

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    String username = widget.username;
    String usertext = "Hi, " + username;

    return MaterialApp(
      routes: {
        'orders': (context) => Orders(
              username: widget.username,
              password: widget.password,
            ),
      },
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
                title: Text("Dashboard"),
              ),
              ListTile(
                title: Text('Orders'),
                onTap: () async {
                  var json = await getOrders(widget.password, widget.username);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Orders(
                            username: widget.username,
                            password: widget.password,
                            json: json)),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
