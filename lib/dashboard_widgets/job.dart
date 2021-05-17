import 'package:flutter/material.dart';

// ignore: must_be_immutable
class JobWidget extends StatelessWidget {
  JobWidget({required this.jsonL});
  Map jsonL;

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Orientation or = MediaQuery.of(context).orientation;
    double w1 = width / 2 - 5 - 4;
    double w2 = width / 2 - 4;
    if (or == Orientation.landscape) {
      w1 = width / 2 / 2 - 5 - 4;
      w2 = width / 2 / 2 - 4;
    }

    if (jsonL["job"]["job"] != null) {
      return Card(
          child: Column(children: [
        const SizedBox(height: 10),
        const SizedBox(
            height: 20,
            child: const Center(
                child: const Text(
              'Job',
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
                'Finished (%)',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              width: w2,
              child: Container(
                  width: w2,
                  child: (() {
                    if (jsonL != {} || jsonL["job"] != null) {
                      return Text(
                        jsonL["job"]["progress"]["completion"].toString() + "%",
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
                'Name',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
                width: w2,
                child: (() {
                  if (jsonL != {} || jsonL["job"] != null) {
                    return Text(
                      jsonL["job"]["job"]["file"]["name"].toString(),
                    );
                  }
                }())),
          ],
        ),
        const SizedBox(height: 10),
      ]));
    } else {
      return Container(height: 0);
    }
  }
}
