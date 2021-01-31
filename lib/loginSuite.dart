import 'dart:convert';

import 'package:http/http.dart' as http;
import 'constants/constants.dart';

class LoginSuite {
  dynamic login(String username, String password) async {
    try {
      var response = await http.post(SERVER_URL_LOGIN, body: {
        'username': username,
        'password': password
      }).timeout(new Duration(seconds: 2));
      if (response.statusCode == 200) {
        return json.encode(response.body);
      } else {
        return 403;
      }
    } catch (e) {
      return 408;
    }
  }
}
