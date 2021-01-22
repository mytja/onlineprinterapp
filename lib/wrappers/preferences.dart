import 'package:shared_preferences/shared_preferences.dart';
import 'package:onlineprinterapp/constants/errors.dart';

class SP {
  addToPref(String prefName, val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (val is int) {
      prefs.setInt(prefName, val);
    } else if (val is String) {
      prefs.setString(prefName, val);
    } else if (val is bool) {
      prefs.setBool(prefName, val);
    } else if (val is double) {
      prefs.setDouble(prefName, val);
    } else if (val is List<String>) {
      prefs.setStringList(prefName, val);
    } else {
      print("Unsupported type!");
      return ERR_UNSP;
    }
  }

  getFromPref(String prefName, Type type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var pref;
    if (type is int) {
      pref = prefs.getInt(prefName);
    } else if (type is String) {
      pref = prefs.getString(prefName);
    } else if (type is bool) {
      pref = prefs.getBool(prefName);
    } else if (type is double) {
      pref = prefs.getDouble(prefName);
    } else if (type is List<String>) {
      pref = prefs.getStringList(prefName);
    } else {
      print("Unsupported type!");
      return ERR_UNSP;
    }
    return pref;
  }

  void removeFromPref(String prefName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(prefName);
  }

  void reloadPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
  }
}
