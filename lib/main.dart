import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/dashboard.dart';
import 'package:http/http.dart' as http;
import 'constants/constants.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Title',
        home: Scaffold(
          body: Login(),
          appBar: AppBar(
            title: Text("OnlinePrinterApp"),
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

class LoginMain extends State<Login> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<String> getResponse(String password, String username) async {
    if (password == "" || username == "") {
      print("None");
      return "None";
    } else {
      var response = await http.get(
          SERVER_URL_LOGIN + "?username=" + username + "&password=" + password);
      return response.body.toString();
    }
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: getResponse(
            _passwordController.text,
            _usernameController
                .text), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            var snapdata = snapshot.data;
            if (snapdata == "None") {
              print("None snapdata");
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
                      child: Text('Oooops!'),
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
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Dashboard(
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
