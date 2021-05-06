import 'package:flutter/material.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/constants.dart';

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
                Navigator.pop(context);
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
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Invalid URL'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('You entered invalid URL.'),
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
        });
  }

  final myController = TextEditingController();

  Widget build(BuildContext context) {
    String url = widget.sp.getString('url') ?? "";
    print(url);

    double width = MediaQuery.of(context).size.width;

    myController.text = url;

    return ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: [
          Container(
            height: 10,
          ),
          Row(
            children: [
              Container(
                width: 10,
              ),
              Text("URL", style: TextStyle(fontSize: 20)),
              Container(
                width: 10,
              ),
              Container(
                  width: width / 10 * 8,
                  child: TextFormField(
                    controller: myController,
                    obscureText: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'URL',
                        hintText: url),
                    onFieldSubmitted: (String text) async {
                      if (Uri.parse(text).isAbsolute == true) {
                        SharedPreferences sp =
                            await SharedPreferences.getInstance();
                        print(text.substring(text.length - 1));
                        if (text.substring(text.length - 1) != "/") {
                          text += "/";
                        }
                        await sp.setString("url", text + "/");
                        updateVars(text);
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
