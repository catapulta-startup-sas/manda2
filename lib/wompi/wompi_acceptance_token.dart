import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manda2/firebase/start_databases/get_constantes.dart';

Future<String> getAcceptanceToken() async {
  var url = "https://production.wompi.co/v1/merchants";
  var response = await http.get("$url/$pubKey").catchError((e) {
    print("ERROR: $e");
  });

  String acceptanceToken = json.decode(response.body)["data"]
      ["presigned_acceptance"]["acceptance_token"];
  return acceptanceToken;
}
