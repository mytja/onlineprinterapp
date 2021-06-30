import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/constants/constants.dart';
import 'package:onlineprinterapp/crypto.dart';

class PositionController extends StatelessWidget {
  PositionController({required this.username, required this.password});

  final String username;
  final String password;

  Widget build(BuildContext context) {
    Future<void> controlPrinter(String mode, String username, String password,
        int? x, int? y, int? z) async {
      Uri uri = Uri.parse(SERVER_URL_CONTROL +
          "?command=" +
          mode +
          "&x=" +
          x.toString() +
          "&y=" +
          y.toString() +
          "&z=" +
          z.toString());
      await http.get(uri, headers: auth.getBasicHeader(username, password));
    }

    return Card(
        child: Column(children: [
      const SizedBox(height: 10),
      const Center(
          child: const Text("Printer control",
              style: const TextStyle(fontSize: 25))),
      const SizedBox(height: 10),
      Row(
          mainAxisAlignment:
              MainAxisAlignment.center, //Center Column contents vertically,
          crossAxisAlignment:
              CrossAxisAlignment.center, //Center Column contents horizontally,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment
                    .center, //Center Column contents vertically,
                crossAxisAlignment: CrossAxisAlignment
                    .center, //Center Column contents horizontally,
                children: [
                  Center(
                      child: IconButton(
                    icon: const Icon(Icons.arrow_upward),
                    onPressed: () async {
                      print("up");
                      await controlPrinter(
                          "jog", this.username, this.password, 0, 10, 0);
                    },
                  )),
                  Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, //Center Column contents vertically,
                          crossAxisAlignment: CrossAxisAlignment
                              .center, //Center Column contents horizontally,
                          children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () async {
                            print("left");
                            await controlPrinter(
                                "jog", this.username, this.password, -10, 0, 0);
                          },
                        ),
                        const SizedBox(width: 50),
                        IconButton(
                          icon: const Icon(Icons.home),
                          onPressed: () async {
                            print("home");
                            await controlPrinter(
                                "home", this.username, this.password, 0, 0, 0);
                          },
                        ),
                        const SizedBox(width: 50),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward),
                          onPressed: () async {
                            print("right");
                            await controlPrinter(
                                "jog", this.username, this.password, 10, 0, 0);
                          },
                        ),
                      ])),
                  Center(
                      child: IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () async {
                      print("down");
                      await controlPrinter(
                          "jog", this.username, this.password, 0, -10, 0);
                    },
                  )),
                ]),
            const SizedBox(width: 40),
            Column(children: [
              IconButton(
                icon: const Icon(Icons.arrow_upward),
                onPressed: () async {
                  print("up-z");
                  await controlPrinter(
                      "jog", this.username, this.password, 0, 0, 10);
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_downward),
                onPressed: () async {
                  print("down-z");
                  await controlPrinter(
                      "jog", this.username, this.password, 0, 0, -10);
                },
              )
            ])
          ])
    ]));
  }
}
