import 'dart:convert';
import 'dart:io';

class Authenication {
  Map<String, String> getBasicHeader(String username, String password) {
    String usernamepassword = username + ":" + password;
    List<int> bytes = utf8.encode(usernamepassword);
    String base64Str = base64.encode(bytes);
    String basicheader = "Basic " + base64Str;
    Map<String, String> header = {
      HttpHeaders.authorizationHeader: basicheader,
    };
    //print(header);
    return header;
  }
}

final auth = Authenication();
