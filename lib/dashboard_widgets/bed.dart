import 'package:flutter/material.dart';
import 'package:onlineprinterapp/constants/constants.dart';
import 'package:onlineprinterapp/crypto.dart';
import 'package:onlineprinterapp/dashboard_widgets/archive.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class BedWidget extends StatelessWidget {
  BedWidget(
      {required this.jsonL, required this.username, required this.password});
  Map jsonL;
  String username;
  String password;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    Orientation or = MediaQuery.of(context).orientation;
    double w1 = width / 2 - 5 - 4;
    double w2 = width / 2 - 4;
    if (or == Orientation.landscape) {
      w1 = width / 2 / 2 - 5 - 4;
      w2 = width / 2 / 2 - 4;
    }
    try {
      return Card(
          child: Column(children: [
        const SizedBox(height: 10),
        const SizedBox(
            height: 20,
            child: const Center(
                child: const Text(
              'Bed',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ))),
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            SizedBox(
              width: w1,
              child: Text(
                'Current temperature',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              width: w2,
              child: Container(
                  width: w2,
                  child: (() {
                    if (jsonL != {} || jsonL["temp"] != null) {
                      if (jsonL["temp"]["bed"]["current"] is double) {
                        tempArchive.bedTempArchive
                            .add(jsonL["temp"]["bed"]["current"]);
                      }
                      return Text(
                        jsonL["temp"]["bed"]["current"].toString(),
                      );
                    }
                  }())),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 5,
            ),
            Container(
              width: w1,
              child: Text(
                'Target temperature',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
                width: w2,
                child: (() {
                  if (jsonL != {} || jsonL["temp"] != null) {
                    return Text(
                      jsonL["temp"]["bed"]["target"].toString(),
                    );
                  }
                }())),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
            width: width,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Temperature',
              ),
              onSubmitted: (String temp) async {
                try {
                  var temperature = int.parse(temp);
                  var response = await http.get(
                      Uri.parse(SERVER_URL_BED_SET + temperature.toString()),
                      headers: auth.getBasicHeader(username, password));
                  print(response.statusCode);
                } catch (e) {
                  print(e);
                }
              },
            )),
        const SizedBox(height: 10),
      ]));
    } catch (e) {
      return Container(height: 0);
    }
  }
}
