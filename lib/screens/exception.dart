import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/crypto.dart';
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
      var response = await http.get(Uri.parse(SERVER_URL_ORDERS),
          headers: auth.getBasicHeader(username, password));
      return response.body.toString();
    }
  }

  static Widget app(Object? exception, BuildContext? context) {
    return MaterialApp(
        theme: Themes.LightTheme(),
        darkTheme: Themes.DarkTheme(),
        themeMode: Themes.Theme(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            appBar: AppBar(
              title: Text("OnlinePrinterApp - Exception"),
              leading: BackButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
            ),
            body: ListView(
              shrinkWrap: true,
              children: [
                Container(height: 5),
                Center(child: Text("Yikes!", style: TextStyle(fontSize: 30))),
                Center(
                    child: Text("There was an exception in the app",
                        style: TextStyle(fontSize: 25))),
                Container(height: 5),
                Center(
                    child: Text(
                        "Please, try to restart the app, clean cache in your app, or open a issue on bug tracker")),
                Container(height: 10),
                Center(child: Text("Exception: " + exception.toString())),
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return app(widget.exception, context);
  }
}
