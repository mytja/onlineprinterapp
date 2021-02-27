import 'dart:convert';

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

/// This is the private State class that goes with MyStatefulWidget.
class DashboardMain extends State<Dashboard> {
  Future<String> getPrinter() async {
    var response = await http.get(SERVER_URL_PRINTER);
    return response.body.toString();
  }

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

    return MaterialApp(
        home: Scaffold(
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
              onTap: () {},
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
          ],
        ),
      ),
      body: FutureBuilder<String>(
        future: getPrinter(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            var jsonL = json.decode(snapshot.data);
            children = <Widget>[
              Container(
                height: 10,
              ),
              Text(
                'Hello, ' + widget.username,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              Text(
                'Welcome to OnlinePrinter Dashboard.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Container(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    width: 5,
                  ),
                  Container(
                    width: width / 2 - 5,
                    child: Text(
                      'Status',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width / 2,
                    child: Text(
                      jsonL["status"].toString(),
                    ),
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Container(
                  height: 20,
                  child: Center(
                      child: Text(
                    'Bed',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    width: width / 2 - 5,
                    child: Text(
                      'Current temperature',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width / 2,
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
                    width: width / 2 - 5,
                    child: Text(
                      'Target temperature',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width / 2,
                    child: Text(
                      jsonL["temp"]["bed"]["target"].toString(),
                    ),
                  ),
                ],
              ),
              Container(
                height: 20,
              ),
              Container(
                  height: 20,
                  child: Center(
                      child: Text(
                    'Nozzle',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
                    width: width / 2 - 5,
                    child: Text(
                      'Current temperature',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width / 2,
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
                    width: width / 2 - 5,
                    child: Text(
                      'Target temperature',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Container(
                    width: width / 2,
                    child: Text(
                      jsonL["temp"]["nozzle"]["target"].toString(),
                    ),
                  ),
                ],
              ),
            ];
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
            children = <Widget>[
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
          return Column(
            children: children,
          );
        },
      ),
    ));
  }
}
