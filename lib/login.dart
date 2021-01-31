import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/loginSuite.dart';
import 'wrappers/preferences.dart';
import 'package:http/http.dart' as http;
import 'constants/constants.dart';

class Login extends StatefulWidget {
  Login({Key key, this.title, this.username, this.password}) : super(key: key);

  final String title;
  final String username;
  final String password;

  @override
  LoginMain createState() => LoginMain();
}

class LoginMain extends State<Login> {
  SP sp;

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginSuite ls;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Column(
          children: <Widget>[
            Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 20,
                    ),
                    Text(
                      "OnlinePrinter Login",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Container(
                      height: 20,
                    ),
                    Container(
                      width: width - 50,
                      child: TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your email or username',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter username or email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      width: width - 50,
                      child: TextFormField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your password',
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a password';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      height: 60,
                      width: width,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState.validate()) {
                                // Process data.
                              }

                              if (_usernameController.text != null &&
                                  _passwordController.text != null) {
                                print("Okay!");
                                var login = await ls.login(
                                    _usernameController.text,
                                    _passwordController.text);
                                if (login == 408) {
                                  return AlertDialog(
                                      title: Text('Login Failed!'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Timeout error on our server...'),
                                            Text('\u1F62C		'),
                                          ],
                                        ),
                                      ));
                                }
                                if (login == 403) {
                                  return AlertDialog(
                                      title: Text('Login Failed!'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(
                                                'Did you enter wrong login information?'),
                                            Text('\u1F914	'),
                                          ],
                                        ),
                                      ));
                                }
                              }
                            },
                            child: Text('Submit'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
