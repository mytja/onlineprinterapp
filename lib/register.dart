import 'dart:convert';

import 'package:fl_flash/fl_flash.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/constants/constants.dart';
import 'package:onlineprinterapp/main.dart';
import 'package:onlineprinterapp/screens/exception.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';

class RegisterUtils {
  Future<int> register(String password, String username, String email,
      String firstName, String lastName) async {
    String url = SERVER_URL_REGISTER +
        "?username=" +
        username +
        "&password=" +
        base64Encode(utf8.encode(password)) +
        "&email=" +
        email +
        "&fname=" +
        firstName +
        "&lname=" +
        lastName;
    print(url);
    var response = await http.post(Uri.parse(url));
    print(response.statusCode);
    return response.statusCode;
  }
}

class Register extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();

  final registerutils = RegisterUtils();

  Future<void> _showMyDialog(int responseCode, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        if (responseCode == 409) {
          return AlertDialog(
            title: Text('Registration failed'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('409 - Conflict'),
                  Text('Account already exists.')
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
        } else if (responseCode == 400) {
          return AlertDialog(
            title: Text('Registration failed'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('400 - Bad request'),
                  Text(
                      "App hasn't provided enough data and account couldn't be created")
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
        } else {
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
        }
      },
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'OnlinePrinterApp',
        home: Scaffold(
            resizeToAvoidBottomInset: false,
            body: ListView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                children: <Widget>[
                  Container(height: 50),
                  Text(
                    "OnlinePrinter Registration",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Container(
                    height: 20,
                  ),
                  TextField(
                    obscureText: false,
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-Mail',
                    ),
                  ),
                  TextField(
                    obscureText: false,
                    controller: _usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                  ),
                  TextField(
                    obscureText: false,
                    controller: _fnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'First name',
                    ),
                  ),
                  TextField(
                    obscureText: false,
                    controller: _lnameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Last name',
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
                    child: Text("Register"),
                    onPressed: () async {
                      if (_usernameController.text != "" &&
                          _passwordController.text != "" &&
                          _emailController.text != "" &&
                          _lnameController.text != "" &&
                          _fnameController.text != "") {
                        try {
                          int login = await registerutils.register(
                              _passwordController.text,
                              _usernameController.text,
                              _emailController.text,
                              _fnameController.text,
                              _lnameController.text);
                          if (login == 201) {
                            Flash account = Flash(
                                mainText: Text("Account created successfully",
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold)),
                                backgroundColor: Colors.green.shade300,
                                icon: Icon(Icons.check));
                            FlashManager.add(account);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) => App()));
                          } else {
                            _showMyDialog(login, context);
                          }
                        } catch (e) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ExceptionApp(exception: e)),
                          );
                        }
                      }
                    },
                  ),
                  Container(height: 10),
                  Text(
                      "By clicking Register button, you agree to Terms of service")
                ]),
            appBar: AppBar(
              title: Text("OnlinePrinterApp"),
            ),
            drawer: BackButton()),
        theme: Themes.LightTheme(),
        darkTheme: Themes.DarkTheme(),
        themeMode: Themes.Theme());
  }
}
