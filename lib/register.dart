// ignore_for_file: non_constant_identifier_names

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

class Register extends StatefulWidget {
  @override
  RegisterPage createState() => new RegisterPage();
}

class RegisterPage extends State<Register> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();

  final registerutils = RegisterUtils();

  void invalidRegister(int responseCode) {
    Flash _409 = Flash(
        id: "registerfailed",
        mainText: const Text(
          "Registration failed \nAccount already exists",
        ),
        backgroundColor: Colors.red.shade400);
    Flash _400 = Flash(
        id: "registerfailed",
        mainText: const Text(
          "Registration failed \nBad request \nApp hasn't provided enough credentials for login",
        ),
        backgroundColor: Colors.red.shade400);
    if (responseCode == 409) {
      FlashManager.add(_409);
    } else if (responseCode == 400) {
      FlashManager.add(_400);
    } else {
      Flash none = Flash(
          id: "registerfailed",
          mainText: Text(
            "Registration failed \nUnknown error: " + responseCode.toString(),
          ),
          backgroundColor: Colors.red.shade400);
      FlashManager.add(none);
    }
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
                Container(height: 10),
                (() {
                  return MaterialFlash(
                    ignore: ["printstatus", "loginfailed"],
                    deleteAll: false,
                  );
                }()),
                const SizedBox(height: 10),
                const Text(
                  "OnlinePrinter Registration",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
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
                const SizedBox(
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
                          invalidRegister(login);
                          setState(() {});
                        }
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
                Container(height: 10),
                Text(
                    "By clicking Register button, you agree to Terms of service")
              ]),
          appBar: AppBar(
            title: Text("OnlinePrinterApp"),
            leading: BackButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => App()),
                );
              },
            ),
          ),
        ),
        theme: Themes.LightTheme(),
        darkTheme: Themes.DarkTheme(),
        themeMode: Themes.Theme());
  }
}
