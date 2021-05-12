// ignore_for_file: non_constant_identifier_names

String SERVER_URL = "";
String SERVER_URL_API = SERVER_URL + "api";
String SERVER_URL_LOGIN = SERVER_URL + "api/auth/login";
String SERVER_URL_ORDERS = SERVER_URL + "api/orders/getAll";
String SERVER_URL_ORDER = SERVER_URL + "api/order/";
String SERVER_URL_ORDER_START = SERVER_URL + "api/orders/start/";
String SERVER_URL_PRINTER = SERVER_URL + "api/printer";
String SERVER_URL_BED_SET = SERVER_URL + "api/printer/bed/";
String SERVER_URL_WEBCAM = SERVER_URL + "webcam/stream";
String SERVER_URL_NOZZLE_SET = SERVER_URL + "api/printer/tool/";
String SERVER_URL_ABORT_PRINT = SERVER_URL + "api/order/abort";
String SERVER_URL_REGISTER = SERVER_URL + "api/auth/register";
String SERVER_URL_UNLOCK_PRINTER = SERVER_URL + "api/printer/unlock";

const String VERSION = "Stable 1.1.1";

void updateVars(String baseURL) {
  print(baseURL);
  if (baseURL.substring(baseURL.length - 1) == "/") {
    SERVER_URL = baseURL;
    SERVER_URL_API = SERVER_URL + "api";
    SERVER_URL_LOGIN = SERVER_URL + "api/auth/login";
    SERVER_URL_ORDERS = SERVER_URL + "api/orders/getAll";
    SERVER_URL_ORDER = SERVER_URL + "api/order/";
    SERVER_URL_ORDER_START = SERVER_URL + "api/orders/start/";
    SERVER_URL_PRINTER = SERVER_URL + "api/printer";
    SERVER_URL_BED_SET = SERVER_URL + "api/printer/bed/";
    SERVER_URL_WEBCAM = SERVER_URL + "webcam/stream";
    SERVER_URL_NOZZLE_SET = SERVER_URL + "api/printer/tool/";
    SERVER_URL_ABORT_PRINT = SERVER_URL + "api/order/abort";
    SERVER_URL_REGISTER = SERVER_URL + "api/auth/register";
    SERVER_URL_UNLOCK_PRINTER = SERVER_URL + "api/printer/unlock";
  }
}
