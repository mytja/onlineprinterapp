import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/settings.dart';
import 'constants/constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loginutils = LoginUtils();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user = prefs.getString('username') ?? null;
  String pass = prefs.getString('password') ?? null;
  String response = await loginutils.startLogin(user, pass);
  if (response != "") {
    var jsonL = json.decode(response);
    if (jsonL["responseCode"] == 200) {
      runApp(DApp(username: user, password: pass));
    } else {
      runApp(App());
    }
  } else {
    runApp(App());
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return MaterialApp(
        title: 'OnlinePrinterApp',
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Login(),
          appBar: AppBar(
            title: Text("OnlinePrinterApp"),
          ),
          drawer: Drawer(
            child: Column(
              children: <Widget>[
                Container(
                  width: width,
                  child: DrawerHeader(
                    child: Text("OnlinePrinterApp - Dashboard"),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ),
                ListTile(
                  title: Text('Settings'),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Setting(sp: prefs)),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginMain createState() => LoginMain();
}

class LoginUtils {
  Future<String> getResponse(
      String password, String username, bool retryWithShared) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user = prefs.getString('username') ?? null;
    String pass = prefs.getString('password') ?? null;
    if (pass != null && user != null && retryWithShared) {
      var response = await http
          .get(SERVER_URL_LOGIN + "?username=" + user + "&password=" + pass);
      return response.body.toString();
    } else if (password == "" || username == "" && retryWithShared == false) {
      print("None");
      return "None";
    } else {
      var response = await http.get(
          SERVER_URL_LOGIN + "?username=" + username + "&password=" + password);
      return response.body.toString();
    }
  }

  Future<String> startLogin(String user, String pass) async {
    if (pass != null && user != null) {
      var response = await http
          .get(SERVER_URL_LOGIN + "?username=" + user + "&password=" + pass);
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
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: loginutils.getResponse(
            _passwordController.text,
            _usernameController.text,
            retry), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            var snapdata = snapshot.data;
            if (snapdata == "None") {
              children = <Widget>[
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
                ),
                Container(
                  height: 10,
                ),
                ElevatedButton(
                  child: Text("Login"),
                  onPressed: () {
                    setState(() {});
                  },
                )
              ];
            } else {
              var jsonL = json.decode(snapdata);
              print(jsonL);
              if (jsonL["responseCode"] == 200) {
                children = <Widget>[
                  AlertDialog(
                    title: Center(
                      child: Text('Yay!'),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Center(
                            child: Column(
                              children: [
                                Text(
                                  "200",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Text(
                                  "OK",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                                ),
                                Container(
                                  height: 20,
                                ),
                                Text(
                                  "👍",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30),
                                ),
                                Container(
                                  height: 20,
                                ),
                                Text(
                                  "You can go to dashboard",
                                  style: TextStyle(fontSize: 16),
                                ),
                                Container(
                                  height: 20,
                                ),
                                ElevatedButton(
                                    child: Text('Go to dashboard'),
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString(
                                          'username', _usernameController.text);
                                      await prefs.setString(
                                          'password', _passwordController.text);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DApp(
                                                  username:
                                                      _usernameController.text,
                                                  password:
                                                      _passwordController.text,
                                                )),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ];
              } else if (jsonL["responseCode"] == 403) {
                return AlertDialog(
                  title: Center(
                    child: Text('Oooops!'),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "403",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Text(
                                "Forbidden",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Container(
                                height: 20,
                              ),
                              Text(
                                "🤔",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Container(
                                height: 20,
                              ),
                              Text(
                                "You entered wrong login info",
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                height: 20,
                              ),
                              ElevatedButton(
                                  child: Text('Return back to login screen'),
                                  onPressed: () {
                                    _usernameController.text = "";
                                    _passwordController.text = "";
                                    setState(() {
                                      retry = false;
                                    });
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (jsonL["responseCode"] == 500) {
                return AlertDialog(
                  title: Center(
                    child: Text('Oooops!'),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(
                      children: <Widget>[
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "500",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Text(
                                "Internal Server Error",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                              Container(
                                height: 20,
                              ),
                              Text(
                                "🤔",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 30),
                              ),
                              Container(
                                height: 20,
                              ),
                              Text(
                                "Server had an internal error. Please try again",
                                style: TextStyle(fontSize: 16),
                              ),
                              Container(
                                height: 20,
                              ),
                              ElevatedButton(
                                  child: Text('Return back to login screen'),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Login()),
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
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
    );
  }
}
