import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/constants/constants.dart';

class PositionController extends StatelessWidget {
  PositionController({required this.username, required this.password});

  final String username;
  final String password;

  Widget build(BuildContext context) {
    Future<void> controlPrinter(
        String mode, String username, String password) async {
      Uri uri = Uri.parse(SERVER_URL_CONTROL +
          "?mode=" +
          mode +
          "&username=" +
          username +
          "&password=" +
          password);
      await http.get(uri);
    }

    return Card(
        child: Column(children: [
      Container(height: 10),
      Center(child: Text("Printer control", style: TextStyle(fontSize: 25))),
      Container(height: 10),
      Center(
          child: IconButton(
        icon: Icon(Icons.arrow_upward),
        onPressed: () async {
          print("up");
          await controlPrinter("up", this.username, this.password);
        },
      )),
      Center(
          child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center, //Center Column contents vertically,
              crossAxisAlignment: CrossAxisAlignment
                  .center, //Center Column contents horizontally,
              children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                print("left");
                await controlPrinter("left", this.username, this.password);
              },
            ),
            Container(width: 50),
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () async {
                print("home");
                await controlPrinter("home", this.username, this.password);
              },
            ),
            Container(width: 50),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () async {
                print("right");
                await controlPrinter("right", this.username, this.password);
              },
            ),
          ])),
      Center(
          child: IconButton(
        icon: Icon(Icons.arrow_downward),
        onPressed: () async {
          print("down");
          await controlPrinter("down", this.username, this.password);
        },
      )),
    ]));
  }
}
