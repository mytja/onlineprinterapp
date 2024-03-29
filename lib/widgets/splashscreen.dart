import 'dart:async' show Completer;
import 'package:flutter/material.dart';
import 'package:onlineprinterapp/backgroundRun.dart';
import 'package:onlineprinterapp/widgets/themedata.dart';
import 'package:onlineprinterapp/widgets/waiting.dart';

class Splash extends StatelessWidget {
  static AssetImage _getAssetImage() => AssetImage('assets/logo-small.png');

  static Future<void> preload() async {
    final ImageStream imageStream =
        _getAssetImage().resolve(ImageConfiguration.empty);
    final Completer completer = Completer();
    final ImageStreamListener listener = ImageStreamListener(
      (ImageInfo imageInfo, bool synchronousCall) => completer.complete(),
      onError: (e, stackTrace) => completer.completeError(e, stackTrace),
    );
    imageStream.addListener(listener);
    return completer.future
        .whenComplete(() => imageStream.removeListener(listener));
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Image(image: _getAssetImage()));
  }
}

class WaitingApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Background.wait(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(body: Splash()),
            theme: Themes.LightTheme(),
            darkTheme: Themes.DarkTheme(),
            themeMode: Themes.Theme(),
          );
        } else {
          return snapshot.data;
        }
      },
    );
  }
}

class DashboardSplashScreen extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: ListView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              children: [Splash(), const SizedBox(height: 20), Waiting()])),
      theme: Themes.LightTheme(),
      darkTheme: Themes.DarkTheme(),
      themeMode: Themes.Theme(),
    );
  }
}
