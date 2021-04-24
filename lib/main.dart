import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:onlineprinterapp/dashboard.dart';
import 'package:onlineprinterapp/splashscreen.dart';
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
      var response = await http.get(Uri.parse(
          SERVER_URL_LOGIN + "?username=" + user + "&password=" + pass));
      return response.body.toString();
    } else if (password == "" || username == "" && retryWithShared == false) {
      print("None");
      return "None";
    } else {
      var response = await http.get(Uri.parse(SERVER_URL_LOGIN +
          "?username=" +
          username +
          "&password=" +
          password));
      return response.body.toString();
    }
  }

  Future<String> startLogin(String user, String pass) async {
    if (pass != "" && user != "") {
      var response = await http.get(Uri.parse(
          SERVER_URL_LOGIN + "?username=" + user + "&password=" + pass));
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

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Wrong login info'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('403 - Forbidden'),
                Text('You entered wrong login info.')
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> loginCheck(
      Map<String, dynamic> jsonL, BuildContext context) async {
    if (jsonL["responseCode"] == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("username", _usernameController.text);
      await prefs.setString("password", _passwordController.text);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DApp(
                username: _usernameController.text,
                password: _passwordController.text)),
      );
    } else {
      _showMyDialog();
    }
  }

  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
          if (_usernameController.text != "" &&
              _passwordController.text != "") {
            String login = await loginutils.startLogin(
                _usernameController.text, _passwordController.text);
            var jsonL = json.decode(login);
            await loginCheck(jsonL, context);
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
            String login = await loginutils.startLogin(
                _usernameController.text, _passwordController.text);
            var jsonL = json.decode(login);
            await loginCheck(jsonL, context);
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
            String login = await loginutils.startLogin(
                _usernameController.text, _passwordController.text);
            var jsonL = json.decode(login);
            await loginCheck(jsonL, context);
          }
        },
      )
    ]);
  }
}
