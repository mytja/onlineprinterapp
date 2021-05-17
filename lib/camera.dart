import 'package:flutter/material.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:onlineprinterapp/widgets/xyz_controller.dart';

import 'constants/constants.dart';
import 'widgets/drawer.dart';
import 'mjpeg/mjpeg_player.dart';

class Camera extends StatelessWidget {
  Camera({required this.username, required this.password});

  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Themes.LightTheme(),
        darkTheme: Themes.DarkTheme(),
        themeMode: Themes.Theme(),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(title: Text("OnlinePrinterApp")),
          drawer:
              PrinterDrawer(password: this.password, username: this.username),
          body: CameraStream(password: this.password, username: this.username),
        ));
  }
}

class CameraStream extends StatefulWidget {
  CameraStream({Key? key, required this.username, required this.password})
      : super(key: key);

  final String username;
  final String password;

  @override
  CameraStreamMain createState() => CameraStreamMain();
}

/// This is the private State class that goes with MyStatefulWidget.
class CameraStreamMain extends State<CameraStream> {
  Widget build(BuildContext context) {
    print(SERVER_URL_WEBCAM);
    return Center(
        child: ListView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            children: [
          const SizedBox(
            height: 30,
          ),
          Card(
              child: Column(children: [
            const SizedBox(height: 10),
            const Center(
                child: const Text(
              "Webcam Stream: ",
              style: const TextStyle(fontSize: 26),
            )),
            const SizedBox(height: 5),
            MjpegView(
              url: SERVER_URL_WEBCAM,
            ),
            const SizedBox(height: 10),
          ])),
          const SizedBox(height: 20),
          PositionController(
              username: widget.username, password: widget.password),
        ]));
  }
}
