import 'package:flutter/cupertino.dart';
import 'package:flutter_alert/flutter_alert.dart';

void showBasicAlert(BuildContext context, String title, String message) {
  showAlert(
    context: context,
    title: title,
    body: message,
    actions: [
      AlertAction(
        text: "Aceptar",
        isDefaultAction: true,
      ),
    ],
  );
}
