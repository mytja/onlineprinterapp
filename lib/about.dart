import 'package:flutter/material.dart';
import 'package:onlineprinterapp/constants/constants.dart';
import 'package:onlineprinterapp/widgets/backbutton.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  About({required this.projectJSON});

  final Map<String, dynamic> projectJSON;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("OnlinePrinterApp"),
          leading: BackButtonTop(),
        ),
        body: AboutState(projectJSON: projectJSON),
      ),
      theme: Themes.LightTheme(),
      darkTheme: Themes.DarkTheme(),
      themeMode: Themes.Theme(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AboutState extends StatefulWidget {
  AboutState({Key? key, required this.projectJSON}) : super(key: key);

  final Map<String, dynamic> projectJSON;

  @override
  AboutScreen createState() => AboutScreen();
}

/// This is the private State class that goes with MyStatefulWidget.
class AboutScreen extends State<AboutState> {
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return ListView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      children: [
        Card(
          child: Column(
            children: [
              Center(child: Text("Project", style: TextStyle(fontSize: 25))),
              Container(height: 10),
              Row(children: [
                Container(
                    width: width / 5,
                    child: Image.asset("assets/logo-small.png")),
                Container(width: 5),
                Column(
                  children: [
                    Text("OnlinePrinterApp", style: TextStyle(fontSize: 25)),
                    Text(
                        widget.projectJSON["stargazers_count"].toString() +
                            " star(s)",
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text(
                        widget.projectJSON["forks_count"].toString() +
                            " fork(s)",
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                    Text(VERSION,
                        style: TextStyle(fontSize: 18, color: Colors.grey)),
                  ],
                )
              ]),
            ],
          ),
        ),
        GestureDetector(
            onTap: () async {
              if (await canLaunch("https://github.com/mytja")) {
                await launch("https://github.com/mytja");
              }
            },
            child: Card(
              child: Column(
                children: [
                  Center(
                      child: Text("The main developer",
                          style: TextStyle(fontSize: 25))),
                  Row(children: [
                    Container(
                        width: width / 5,
                        child: Image.network(
                            "https://avatars.githubusercontent.com/u/52399966?v=4")),
                    Container(width: 5),
                    Column(
                      children: [
                        Text("mytja", style: TextStyle(fontSize: 25)),
                        Text("👋 It's me!",
                            style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    )
                  ]),
                ],
              ),
            )),
      ],
    );
  }
}
