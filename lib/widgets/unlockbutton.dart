import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onlineprinterapp/constants/constants.dart';

class UnlockButton extends StatelessWidget {
  UnlockButton({required this.password, required this.username});

  final String username;
  final String password;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async {
        print("Unlocking");
        String uri = SERVER_URL_UNLOCK_PRINTER +
            "?username=" +
            username +
            "&password=" +
            password;
        http.post(Uri.parse(uri));
      },
      label: const Text('Unlock'),
      icon: const Icon(Icons.lock_open),
    );
  }
}
