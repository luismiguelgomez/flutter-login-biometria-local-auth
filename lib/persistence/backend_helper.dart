import 'package:http/http.dart' as http;

class BackendHelper {
  static const String _server = "script.google.com";

  static Future<int> sendData(jsonData) async {
    var client = http.Client();
    int code = -1;
    try {
      var response = await client.post(
          Uri.https(_server,
              "macros/s/AKfycbxyTUNg1eNPGjPKt_cNhz6RYPTZFsqaD-1hLYb5gdFbv5QedrG3Geb1paU6s_URgfm0-Q/exec"),
          body: {'acc': '2', 'tbl': 'Contacts', 'data': jsonData});
          code =  response.statusCode;
    } finally {
      client.close();
    }
    return code;
  }
}
