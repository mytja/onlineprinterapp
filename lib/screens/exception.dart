import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/widgets/themedata.dart';
import '../constants/constants.dart';

class Exception {
  static List<Widget> exception(Object? exception) {
    return [
      Text("Yikes!", style: TextStyle(fontSize: 30)),
      Text("There was an exception in the app.",
          style: TextStyle(fontSize: 25)),
      Text(
          "Please, try to restart the app, clean cache in your app, or open a issue on bug tracker"),
      Text("Exception: " + exception.toString()),
    ];
  }
}

class ExceptionApp extends StatefulWidget {
  ExceptionApp({this.exception});

  final Object? exception;

  @override
  ExceptionScreen createState() => ExceptionScreen();
}

class ExceptionScreen extends State<ExceptionApp> {
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
    return MaterialApp(
        theme: Themes.LightTheme(),
        darkTheme: Themes.DarkTheme(),
        themeMode: Themes.Theme(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text("OnlinePrinterApp - Exception in the app"),
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                Text("Yikes!", style: TextStyle(fontSize: 30)),
                Text("There was an exception in the app.",
                    style: TextStyle(fontSize: 25)),
                Text(
                    "Please, try to restart the app, clean cache in your app, or open a issue on bug tracker"),
                Text("Exception: " + widget.exception.toString()),
              ],
            )));
  }
}
