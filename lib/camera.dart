import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'constants/constants.dart';
import 'widgets/drawer.dart';
import 'old/mjpeg_player.dart';

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
  Widget build(BuildContext context) {
    print(SERVER_URL_WEBCAM);

    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows ||
        Platform.isMacOS) {
      return Center(
          child: ListView(children: [
        Container(
          height: 30,
        ),
        Center(
            child: Text(
          "Webcam Stream: ",
          style: TextStyle(fontSize: 26),
        )),
        MjpegView(
          url: SERVER_URL_WEBCAM,
        )
      ]));
    } else {
      return Center(
          child: ListView(children: [
        Container(
          height: 30,
        ),
        Center(
            child: Text(
          "Sorry, but webcam stream is not supported on this platform yet 😢",
          style: TextStyle(fontSize: 26),
        )),
      ]));
    }
  }
}
