import 'dart:async';

import 'package:flutter/material.dart';
import 'package:onlineprinterapp/widgets/waiting.dart';
import 'constants/constants.dart';
import 'widgets/drawer.dart';
import 'package:http/http.dart' as http;
//import 'old/mjpeg_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Camera extends StatelessWidget {
  Camera({this.username, this.password});

  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("OnlinePrinterApp")),
      drawer: PrinterDrawer(password: this.password, username: this.username),
      body: CameraStream(password: this.password, username: this.username),
    ));
  }
}

class CameraStream extends StatefulWidget {
  CameraStream({Key key, this.username, this.password}) : super(key: key);

  final String username;
  final String password;

  @override
  CameraStreamMain createState() => CameraStreamMain();
}

/// This is the private State class that goes with MyStatefulWidget.
class CameraStreamMain extends State<CameraStream> {
  final waiting = Waiting();

  @override
  void initState() {
    super.initState();
    setState(() {
      const oneSecond = const Duration(seconds: 2);
      new Timer.periodic(oneSecond, (Timer t) => setState(() {}));
    });
  }

  Future<String> getPrinter() async {
    var response = await http.get(SERVER_URL_PRINTER);
    return response.body.toString();
  }

  Widget build(BuildContext context) {
    return Center(
        child: WebView(
      initialUrl: SERVER_URL_WEBCAM,
    ));
  }
}
