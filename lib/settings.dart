import 'package:fl_flash/fl_flash.dart';
import 'package:flutter/material.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/constants.dart';

import 'package:onlineprinterapp/widgets/splashscreen.dart';

class Setting extends StatelessWidget {
  Setting({this.username, this.password, required this.sp});

  final String? username;
  final String? password;
  final SharedPreferences sp;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Themes.LightTheme(),
        darkTheme: Themes.DarkTheme(),
        themeMode: Themes.Theme(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            title: Text("OnlinePrinterApp"),
            leading: BackButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WaitingApp()),
                );
              },
            ),
          ),
          body: Settings(
              password: this.password, username: this.username, sp: this.sp),
        ));
  }
}

class Settings extends StatefulWidget {
  Settings({Key? key, this.username, this.password, required this.sp})
      : super(key: key);

  final String? username;
  final String? password;
  final SharedPreferences sp;

  @override
  SettingsMain createState() => SettingsMain();
}

/// This is the private State class that goes with MyStatefulWidget.
class SettingsMain extends State<Settings> {
  Future<void> _showMyDialog() async {
    Flash startprint = Flash(
        id: "url",
        mainText: Text(
          "Please enter valid URL",
          style: TextStyle(fontSize: 26),
        ),
        icon: Icon(Icons.error),
        backgroundColor: Colors.red.shade400);
    FlashManager.add(startprint);
    setState(() {});
  }

  final myController = TextEditingController();

  Widget build(BuildContext context) {
    String url = widget.sp.getString('url') ?? "";
    print(url);

    if (url == "") {
      Flash startprint = Flash(
          id: "url",
          mainText: Text("Please setup correct URL before login",
              style: TextStyle(color: Colors.black, fontSize: 15)),
          icon: Icon(Icons.warning, color: Colors.black),
          backgroundColor: Colors.yellow.shade300);
      FlashManager.add(startprint);
    }

    double width = MediaQuery.of(context).size.width;

    myController.text = url;

    return ListView(
        physics: const BouncingScrollPhysics(
            parent: const AlwaysScrollableScrollPhysics()),
        children: [
          const SizedBox(
            height: 10,
          ),
          const Center(child: Text("Settings", style: TextStyle(fontSize: 26))),
          const SizedBox(
            height: 5,
          ),
          MaterialFlash(limit: 1, ignore: ["printerstatus"]),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              const Text("URL", style: const TextStyle(fontSize: 20)),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                  width: width / 10 * 8,
                  child: TextFormField(
                    controller: myController,
                    obscureText: false,
                    decoration: const InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'URL',
                        hintText: "Type in your OnlinePrinter server URL"),
                    onFieldSubmitted: (String text) async {
                      if (Uri.parse(text).isAbsolute == true) {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        print(text.substring(text.length - 1));
                        if (text.substring(text.length - 1) != "/") {
                          text += "/";
                        }
                        await sp.setString("url", text);
                        updateVars(text);
                        Flash startprint = Flash(
                            id: "url",
                            mainText: Text("Successfully updated URL",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                            icon: Icon(Icons.warning, color: Colors.black),
                            backgroundColor: Colors.green.shade400);
                        FlashManager.add(startprint);
                        setState(() {});
                      } else {
                        _showMyDialog();
                      }
                    },
                  ))
            ],
          )
        ]);
  }
}
