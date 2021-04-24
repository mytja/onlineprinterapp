import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:onlineprinterapp/constants/constants.dart';
import 'package:onlineprinterapp/main.dart';
import 'package:onlineprinterapp/settings.dart';
import 'package:onlineprinterapp/widgets/backbutton.dart';
import 'package:onlineprinterapp/widgets/drawer.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:onlineprinterapp/dashboard.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Background {
  static Future wait() async {
    final loginutils = LoginUtils();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String url = prefs.getString("url") ?? "";

    if (url != "") {
      updateVars(url);
    }

    if (SERVER_URL != "") {
      String user = prefs.getString('username') ?? "";
      String pass = prefs.getString('password') ?? "";
      String response = await loginutils.startLogin(user, pass);
      print(response);
      print(pass);
      print(user);
      if (response != "") {
        var jsonL = json.decode(response);
        if (jsonL["responseCode"] == 200) {
          return MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: Text("OnlinePrinterApp")),
              drawer: PrinterDrawer(password: pass, username: user),
              body: Dashboard(password: pass, username: user),
            ),
            theme: Themes.LightTheme(),
            darkTheme: Themes.DarkTheme(),
            themeMode: Themes.Theme(),
            debugShowCheckedModeBanner: false,
          );
        } else {
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
            debugShowCheckedModeBanner: false,
          );
        }
      } else {
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
          debugShowCheckedModeBanner: false,
        );
      }
    } else {
      SharedPreferences sp = await SharedPreferences.getInstance();
      return MaterialApp(
          theme: Themes.LightTheme(),
          darkTheme: Themes.DarkTheme(),
          themeMode: Themes.Theme(),
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            appBar: AppBar(
                title: Text("OnlinePrinterApp"), leading: BackButtonTop()),
            body: Settings(sp: sp),
          ));
    }
  }
}
