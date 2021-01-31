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

  Future<SharedPreferences> getInstanceSH() {
    return SharedPreferences.getInstance();
  }

  Future<dynamic> getFromPref(String prefName, Type type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (type is int) {
      var pref = prefs.getInt(prefName) ?? 0;
      return pref;
    } else if (type is String) {
      var pref = prefs.getString(prefName) ?? "";
      return pref;
    } else if (type is bool) {
      var pref = prefs.getBool(prefName);
    } else if (type is double) {
      var pref = prefs.getDouble(prefName);
    } else if (type is List<String>) {
      var pref = prefs.getStringList(prefName);
    } else {
      print("Unsupported type!");
      return ERR_UNSP;
    }
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
