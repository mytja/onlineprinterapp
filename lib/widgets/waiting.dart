import 'package:flutter/material.dart';

class Waiting {
  Widget waiting() {
    return Center(
        child: Column(children: [
      Container(
        height: 20,
      ),
      SizedBox(
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
}
