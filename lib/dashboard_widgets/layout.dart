import 'dart:io' show Platform;

import 'package:fl_flash/fl_flash.dart';
import 'package:flutter/material.dart';
import 'package:onlineprinterapp/dashboard_widgets/abort.dart';
import 'package:onlineprinterapp/dashboard_widgets/archive.dart';
import 'package:onlineprinterapp/dashboard_widgets/bed.dart';
import 'package:onlineprinterapp/dashboard_widgets/job.dart';
import 'package:onlineprinterapp/dashboard_widgets/nozzle.dart';
import 'package:onlineprinterapp/widgets/chart.dart';

// ignore: must_be_immutable
class DashboardLayout extends StatelessWidget {
  DashboardLayout(
      {required this.jsonL, required this.username, required this.password});
  Map jsonL;
  String username;
  String password;

  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (Platform.isWindows ||
        Platform.isLinux ||
        orientation == Orientation.landscape) {
      return ListView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 35,
              child: Center(
                child: Text(
                  'Hello, ' + username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
            ),
            const SizedBox(
                height: 20,
                child: const Center(
                    child: const Text(
                  'Welcome to OnlinePrinter Dashboard.',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ))),
            Container(
              height: 20,
            ),
            (() {
              return MaterialFlash(limit: 1);
            }()),
            const SizedBox(
              height: 20,
            ),
            Row(children: [
              Expanded(
                  child: Column(children: [
                BedWidget(jsonL: jsonL, username: username, password: password),
                NozzleWidget(
                    jsonL: jsonL, username: username, password: password),
                AbortWidget(
                    jsonL: jsonL, username: username, password: password)
              ])),
              Expanded(
                  child: Column(children: [
                JobWidget(jsonL: jsonL),
                Card(
                    child: LineChartPrinter(
                        bedTemp: tempArchive.bedTempArchive,
                        nozzleTemp: tempArchive.nozzleTempArchive)),
              ]))
            ]),
          ]);
    } else {
      return ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: [
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 35,
              child: Center(
                child: Text(
                  'Hello, ' + username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
              ),
            ),
            const SizedBox(
                height: 20,
                child: const Center(
                    child: const Text(
                  'Welcome to OnlinePrinter Dashboard.',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ))),
            const SizedBox(
              height: 20,
            ),
            MaterialFlash(limit: 1),
            const SizedBox(
              height: 20,
            ),
            JobWidget(jsonL: jsonL),
            BedWidget(jsonL: jsonL, username: username, password: password),
            NozzleWidget(jsonL: jsonL, username: username, password: password),
            Card(
                child: LineChartPrinter(
                    bedTemp: tempArchive.bedTempArchive,
                    nozzleTemp: tempArchive.nozzleTempArchive)),
            AbortWidget(jsonL: jsonL, username: username, password: password)
          ]);
    }
  }
}
