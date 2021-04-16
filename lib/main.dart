import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/settings.dart';
import 'package:onlineprinterapp/widgets/drawer.dart';
import 'constants/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loginutils = LoginUtils();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('username') ?? "";
  String pass = prefs.getString('password') ?? "";
  String response = await loginutils.startLogin(user, pass);
  if (response != "") {
    var jsonL = json.decode(response);
    if (jsonL["responseCode"] == 200) {
      runApp(MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: Text("OnlinePrinterApp")),
          drawer: PrinterDrawer(password: pass, username: user),
          body: Dashboard(password: pass, username: user),
        ),
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ));
    } else {
      runApp(MaterialApp(
        title: 'OnlinePrinterApp',
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Login(),
            appBar: AppBar(
              title: Text("OnlinePrinterApp"),
            ),
            drawer: SettingsDrawer()),
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        debugShowCheckedModeBanner: false,
      ));
    }
  } else {
    runApp(MaterialApp(
      title: 'OnlinePrinterApp',
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Login(),
          appBar: AppBar(
            title: Text("OnlinePrinterApp"),
          ),
          drawer: SettingsDrawer()),
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
    ));
  }
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
            drawer: SettingsDrawer()));
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
            if (jsonL["responseCode"] == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DApp(
                        username: _usernameController.text,
                        password: _passwordController.text)),
              );
            }
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
            if (jsonL["responseCode"] == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DApp(
                        username: _usernameController.text,
                        password: _passwordController.text)),
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
            String login = await loginutils.startLogin(
                _usernameController.text, _passwordController.text);
            var jsonL = json.decode(login);
            if (jsonL["responseCode"] == 200) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DApp(
                        username: _usernameController.text,
                        password: _passwordController.text)),
              );
            }
          }
        },
      )
    ]);
  }
}
