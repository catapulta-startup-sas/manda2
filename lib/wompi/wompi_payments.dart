import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/wompi/wompi_acceptance_token.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus {
  PENDING,
  APPROVED,
  DECLINED,
  ERROR,
}

PaymentStatus paymentStatus = PaymentStatus.PENDING;

// Genera un pago
Future<void> generarPago(int transacValue, int cuotas) async {
  String referenceCode = "${user.id}~+~${user.payCount}";

  String ccx;
  //A es favorita
  if (user.userTks["creditCardA"] != null) {
    if (user.favoriteCreditCard ==
        user.userTks["creditCardA"]["lastFourDigits"]) {
      ccx = "A";
    }
  }
  //B es favorita
  if (user.userTks["creditCardB"] != null) {
    if (user.favoriteCreditCard ==
        user.userTks["creditCardB"]["lastFourDigits"]) {
      ccx = "B";
    }
  }
  //C es favorita
  if (user.userTks["creditCardC"] != null) {
    if (user.favoriteCreditCard ==
        user.userTks["creditCardC"]["lastFourDigits"]) {
      ccx = "C";
    }
  }

  String creditCardTokenId = user.userTks["creditCard$ccx"]["token"];

  Map<String, dynamic> userMap = {
    "payCount": user.payCount + 1,
  };
  await Firestore.instance
      .document("users/${user.id}")
      .updateData(userMap)
      .then((r) async {
    user.payCount = user.payCount + 1;

    String acceptanceToken = await getAcceptanceToken();

    var url = "https://production.wompi.co/v1/transactions";
    var body = {
      "acceptance_token": "$acceptanceToken",
      "amount_in_cents": transacValue * 100,
      "currency": "COP",
      "customer_email": "${user.email}",
      "payment_method": {
        "type": "CARD",
        "token": "$creditCardTokenId",
        "installments": cuotas
      },
      "reference": "$referenceCode",
    };
    var headers = {"authorization": "Bearer $pubKey"};
    var response = await http
        .post(url, headers: headers, body: json.encode(body))
        .catchError((e) {
      print("💩️ ERROR EN RESPONSE DE WOMPI: $e");
      paymentStatus = PaymentStatus.ERROR;
      return;
    });
    if (response.statusCode == 201) {
      String transactionId = json.decode(response.body)["data"]["id"];

      /// Response del POST exitoso
      while (paymentStatus == PaymentStatus.PENDING) {
        await Future.delayed(Duration(seconds: 3), () async {
          var confirmationResponse =
              await http.get("$url/$transactionId").catchError((e) {
            print("ERROR: $e");
          });
          if (confirmationResponse.statusCode == 200) {
            /// Request exitoso
            String paymentStatusString =
                json.decode(confirmationResponse.body)["data"]["status"];
            print("PAYMENT STATUS AFUERA: $paymentStatus");
            if (paymentStatusString == "APPROVED") {
              paymentStatus = PaymentStatus.APPROVED;
              print("PAYMENT STATUS DE APPROVED: $paymentStatus");
              return;
            } else if (paymentStatusString == "DECLINED") {
              print("PAYMENT STATUS DE DECLINED: $paymentStatus");
              paymentStatus = PaymentStatus.DECLINED;
              return;
            } else {
              paymentStatus = PaymentStatus.PENDING;
              print("PAYMENT STATUS SIGUE PENDING: $paymentStatus");
            }
          } else {
            /// Request ha fallado, pero no sabemos si debe repetir el pago
            print(
                "ERROR 2do RESPONSE: ${json.decode(confirmationResponse.body)}");
            paymentStatus = PaymentStatus.PENDING;
          }
        });
      }
    } else {
      /// Error al procesar el pago
      print("ERROR 1er RESPONSE: ${json.decode(response.body)}");
      paymentStatus = PaymentStatus.ERROR;
      return;
    }
  });
}
