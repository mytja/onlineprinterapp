import 'package:flutter/material.dart';
import 'package:onlineprinterapp/dashboard.dart';
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

class BackButtonPop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

class BackButtonDashboard extends StatelessWidget {
  BackButtonDashboard({required this.username, required this.password});

  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    return BackButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  Dashboard(username: username, password: password),
            ));
      },
    );
  }
}
