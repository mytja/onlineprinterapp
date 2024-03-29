import 'dart:convert';

import 'package:fl_flash/fl_flash.dart';
import 'package:flutter/material.dart';
import 'package:onlineprinterapp/crypto.dart';

import 'package:onlineprinterapp/dashboard.dart';
import 'package:onlineprinterapp/register.dart';
import 'package:onlineprinterapp/screens/exception.dart';
import 'package:onlineprinterapp/widgets/splashscreen.dart';
import 'package:onlineprinterapp/widgets/drawer.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:onlineprinterapp/constants/constants.dart';

import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Splash.preload();

  runApp(WaitingApp());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnlinePrinterApp',
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Login(),
          appBar: AppBar(
            title: Text("OnlinePrinterApp"),
          ),
          drawer: SettingsDrawer()),
      theme: Themes.LightTheme(),
      darkTheme: Themes.DarkTheme(),
      themeMode: Themes.Theme(),
    );
  }
}

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  LoginMain createState() => LoginMain();
}

class LoginUtils {
  Future<String> getResponse(
      String password, String username, bool retryWithShared) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('username') ?? "";
    String pass = prefs.getString('password') ?? "";
    if (pass != "" && user != "" && retryWithShared) {
      var response = await http.get(Uri.parse(SERVER_URL_LOGIN),
          headers: auth.getBasicHeader(username, password));
      return response.body.toString();
    } else if (password == "" || username == "" && retryWithShared == false) {
      print("None");
      return "None";
    } else {
      var response = await http.get(Uri.parse(SERVER_URL_LOGIN),
          headers: auth.getBasicHeader(username, password));
      return response.body.toString();
    }
  }

  Future<String> startLogin(String user, String pass, bool prefed) async {
    if (pass != "" && user != "") {
      var response = await http.get(Uri.parse(SERVER_URL_LOGIN),
          headers: auth.getBasicHeader(user, pass));
      return response.body.toString();
    } else {
      return "";
    }
  }
}

class LoginMain extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool retry = true;

  final loginutils = LoginUtils();

  Future<void> loginCheck(
      Map<String, dynamic> jsonL, BuildContext context) async {
    if (jsonL["responseCode"] == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      await prefs.setString("username", _usernameController.text);
      await prefs.setString("password", _passwordController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Dashboard(
                username: _usernameController.text,
                password: _passwordController.text)),
      );
    } else {
      Flash fail = Flash(
          mainText: Text("Failed to login"),
          id: "loginfailed",
          backgroundColor: Colors.red.shade400);
      FlashManager.add(fail);
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: <Widget>[
          (() {
            return MaterialFlash(
              ignore: ["printstatus", "registerfailed"],
              deleteAll: false,
            );
          }()),
          Container(height: 50),
          Text(
            "OnlinePrinter Login",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Container(
            height: 20,
          ),
          TextField(
            obscureText: false,
            controller: _usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Username or E-Mail',
            ),
            onSubmitted: (String text) async {
              try {
                String login = await loginutils.startLogin(
                    _usernameController.text, _passwordController.text, false);
                var jsonL = json.decode(login);
                await loginCheck(jsonL, context);
              } catch (e) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ExceptionApp(exception: e)),
                );
              }
            },
          ),
          Container(
            height: 5,
          ),
          TextField(
            obscureText: true,
            controller: _passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
            ),
            onSubmitted: (String text) async {
              if (_usernameController.text != "" &&
                  _passwordController.text != "") {
                try {
                  String login = await loginutils.startLogin(
                      _usernameController.text,
                      _passwordController.text,
                      false);
                  var jsonL = json.decode(login);
                  await loginCheck(jsonL, context);
                } catch (e) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExceptionApp(exception: e)),
                  );
                }
              }
            },
          ),
          Container(
            height: 10,
          ),
          ElevatedButton(
            child: Text("Login"),
            onPressed: () async {
              if (_usernameController.text != "" &&
                  _passwordController.text != "") {
                try {
                  String login = await loginutils.startLogin(
                      _usernameController.text,
                      _passwordController.text,
                      false);
                  var jsonL = json.decode(login);
                  await loginCheck(jsonL, context);
                } catch (e) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ExceptionApp(exception: e)),
                  );
                }
              }
            },
          ),
          Container(height: 20),
          GestureDetector(
            child: Text(
              "Don't have an account yet? Register here",
              style: TextStyle(color: Colors.blue),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Register()),
              );
            },
          )
        ]);
  }
}
