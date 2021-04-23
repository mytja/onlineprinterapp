import 'package:flutter/material.dart';
import 'package:onlineprinterapp/main.dart';

class BackButtonTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => App()),
        );
      },
    );
  }
}
