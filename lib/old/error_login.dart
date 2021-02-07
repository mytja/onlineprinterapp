import 'dart:convert';

import 'package:flutter/material.dart';
import '../login.dart';

class Error extends StatefulWidget {
  Error({Key key, this.error_code, this.error_name, this.error_description})
      : super(key: key);

  final String error_name;
  final String error_code;
  final String error_description;

  @override
  ErrorScreen createState() => ErrorScreen();
}

class ErrorScreen extends State<Error> {
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login Error'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Drawer Header'),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {},
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    height: 20,
                  ),
                  Text(
                    "Oooops!",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    widget.error_code,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Text(
                    widget.error_name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Container(
                    height: 20,
                  ),
                  Text(
                    "🤔",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  Container(
                    height: 20,
                  ),
                  ElevatedButton(
                      child: Text('Return back to login screen'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
