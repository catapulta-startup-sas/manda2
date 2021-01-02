import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manda2/firebase/start_databases/get_constantes.dart';

Future<String> registrarTarjeta(
  String number,
  String cvv,
  String expMonth,
  String expYear,
  String cardHolder,
) async {
  var url = "https://production.wompi.co/v1/tokens/cards";
  var body = {
    "number": "$number",
    "cvc": "$cvv",
    "exp_month": "$expMonth",
    "exp_year": "$expYear",
    "card_holder": "$cardHolder",
  };
  var headers = {"authorization": "Bearer $pubKey"};
  var response = await http
      .post(url, headers: headers, body: json.encode(body))
      .catchError((e) {
    print("💩 ERROR EN REQUEST: $e");
  });
  String status = json.decode(response.body)["status"];
  if (status == "CREATED") {
    String cardToken = json.decode(response.body)["data"]["id"];
    return cardToken;
  } else {
    print(
        "💩 ERROR AL REGISTRAR TARJETA: ${response.statusCode} · ${json.decode(response.body)}");
    return null;
  }
}
