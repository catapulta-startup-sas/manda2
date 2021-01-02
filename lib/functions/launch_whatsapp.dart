import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';
import 'm2_alert.dart';

/// Abre WhatsApp con el número indicado
void launchWhatsApp(BuildContext context, String phone) async {
  phone.replaceAll("+", "");
  if (phone.length == 10) {
    phone = "57$phone";
  }
  await canLaunch("https://wa.me/$phone")
      ? launch("https://wa.me/$phone")
      : showBasicAlert(
          context,
          "No pudimos abrir WhatsApp",
          "Por favor, instala WhatsApp e intenta de nuevo.",
        );
}
