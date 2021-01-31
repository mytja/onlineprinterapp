import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'wrappers/preferences.dart';
import 'login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OnlinePrinterApp',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Start(title: 'OnlinePrinterApp'),
    );
  }
}

class Start extends StatefulWidget {
  Start({Key key, this.title}) : super(key: key);

  final String title;

  @override
  TryLogin createState() => TryLogin();
}

class TryLogin extends State<Start> {
  SP sp;

  Future<SharedPreferences> getInstance() {
    return SharedPreferences.getInstance();
  }

  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2,
      textAlign: TextAlign.center,
      child: FutureBuilder<SharedPreferences>(
          future: getInstance(), // a previously-obtained Future<String> or null
          // ignore: missing_return
          builder: (BuildContext context,
              AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.hasData) {
              SharedPreferences shp = snapshot.data;
              String username = shp.getString("username");
              String password = shp.getString("password");
              print(username);
              print(password);

              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Login(
                          password: password,
                          username: username,
                        )),
              );
            } else {
              return Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      child: CircularProgressIndicator(),
                      width: 60,
                      height: 60,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text('Awaiting result...'),
                    )
                  ],
                ),
              );
            }
          }),
    );
  }
}
