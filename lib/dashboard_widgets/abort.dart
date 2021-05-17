import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/constants/constants.dart';

// ignore: must_be_immutable
class AbortWidget extends StatelessWidget {
  AbortWidget(
      {required this.jsonL, required this.username, required this.password});
  Map jsonL;
  String username;
  String password;

  Widget build(BuildContext context) {
    bool canAbort = false;
    try {
      canAbort = jsonL["abort"]["canAbort"];
    } catch (e) {
      canAbort = false;
    }
    if (canAbort == true) {
      return Card(
          child: Column(children: [
        const SizedBox(height: 10),
        const SizedBox(
            height: 20,
            child: const Center(
                child: const Text(
              'Print',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ))),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
            child: Text("Abort print"),
            onPressed: () async {
              http.Response response = await http.get(Uri.parse(
                  SERVER_URL_ABORT_PRINT +
                      "?username=" +
                      username +
                      "&password=" +
                      password));
              print(response.body.toString());
              print(response.statusCode);
            }),
        const SizedBox(height: 10),
      ]));
    } else {
      return Container(height: 0);
    }
  }
}
