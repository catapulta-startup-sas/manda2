import 'dart:async';
import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

class PushNotification {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  Future<Map<String, dynamic>> sendMandadoDisponibleNotification(
      int numDestinos) async {
    final String serverToken =
        "AAAAXT7rgtM:APA91bGWyeM45QExf2z-EnMeNlwg9AfRxF6HXxSfmnfwkv3cSaI7UmW_i2yiXXwdpo6ppLFxNz-q5tnBMzb__eOgnHvK0ol1hJkfv97kvvSyYxQmIRlBTTta27enco54qigJcV4XCE6K";

    final response = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=$serverToken',
      },
      body: jsonEncode(
        <String, dynamic>{
          "to": "/topics/Colaborador",
          'notification': <String, dynamic>{
            'body': numDestinos == 1
                ? 'Hay un nuevo mandado disponible para ti.'
                : "Hay nuevos mandados disponibles para ti.",
            'title': numDestinos == 1
                ? 'Mandado disponible'
                : "Mandados disponibles",
            "sound": "default",
            "badge": 1,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'status': 'done'
          },
        },
      ),
    );

    print("RESPONSE: ${response.body}");

    /*
    if (json.decode(response.body)["success"] == 1) {
      print("NOTIFICACIÓN ENVIADA");
    } else {
      print("ERROR AL ENVIAR NOTIFICACIÓN: ${response.body}");
    }

     */
  }
}
