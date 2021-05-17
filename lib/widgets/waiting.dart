import 'package:flutter/material.dart';

class Waiting extends StatelessWidget {
  Widget waiting() {
    return Center(
        child: Column(children: [
      const SizedBox(
        height: 20,
      ),
      const SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Waiting for server to respond...'),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Please wait'),
      )
    ]));
  }

  Widget build(BuildContext context) {
    return Column(children: [
      const SizedBox(
        height: 20,
      ),
      const SizedBox(
        child: CircularProgressIndicator(),
        width: 60,
        height: 60,
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Waiting for server to respond...'),
      ),
      const Padding(
        padding: EdgeInsets.only(top: 16),
        child: Text('Please wait'),
      )
    ]);
  }
}
