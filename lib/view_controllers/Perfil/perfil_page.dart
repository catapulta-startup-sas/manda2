import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/get_dispositivo_type.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/view_controllers/Perfil/configuracion/configuracion.dart';
import 'package:manda2/view_controllers/Perfil/direcciones/direcciones.dart';
import 'package:manda2/view_controllers/Perfil/soporte_page.dart';
import 'package:manda2/view_controllers/Perfil/tarjetas/mis_tarjetas.dart';
import 'package:manda2/views/perfil_view.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Envios_redimibles/redimibles.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_pro',
    minDays: 0,
    minLaunches: 0,
    remindDays: 0,
    remindLaunches: 0,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: kLightGreyColor,
        actionsForegroundColor: kBlackColor,
        border: Border.all(color: kTransparent, width: 0),
        middle: Container(
          child: Text(
            "Perfil",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: PerfilView(
        handleRateTap: handleRateTap,
        handleSerDomiciliarioTap: _handleSerDomiciliarioTap,
        handleSoporteTap: _handleSoporteTap,
        handleMisTarjetasTap: handleMisTarjetasTap,
        handleEnviosTap: handleEnviosTap,
        handleLugaresTap: handleLugaresTap,
        handleConfiguracionTap: handleConfiguracionTap,
        handleDescargaApp: _handleDescargaApp,
      ),
    );
  }

  void handleMisTarjetasTap() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => Tarjetas()));
  }

  void handleLugaresTap() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => Direcciones()));
  }

  void handleEnviosTap() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => Redimibles()));
  }

  void handleConfiguracionTap() {
    Navigator.push(
        context, CupertinoPageRoute(builder: (context) => Configuracion()));
  }

  void _handleSoporteTap() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => Soporte(),
      ),
    );
  }

  void _handleSerDomiciliarioTap() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: dispositivo == Dispositivo.ios
            ? Text("Serás redirigido a la App Store.")
            : Text("Serás redirigido a la Play Store."),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: dispositivo == Dispositivo.ios
                ? Text("Ir a la App Store")
                : Text("Ir a la Play Store"),
            onPressed: () {
              _launchURLTiendas(dispositivo == Dispositivo.ios);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _launchURLTiendas(bool isIos) async {
    String url;
    if (isIos) {
      url = linkAppStoreDomis;
    } else {
      url = linkPlayStoreDomis;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void handleRateTap() {
    _rateMyApp.init().then((_) {
      _rateMyApp.showStarRateDialog(
        context,
        title: 'What do you think about Our App?',
        message: 'Please leave a rating',
        actionsBuilder: (_, stars) {
          return [
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                await _rateMyApp
                    .callEvent(RateMyAppEventType.rateButtonPressed);
                _uploadReviewedBuyers();
                Navigator.pop<RateMyAppDialogButton>(
                  context,
                  RateMyAppDialogButton.rate,
                );
              },
            ),
          ];
        },
        dialogStyle: DialogStyle(
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
          messagePadding: EdgeInsets.only(bottom: 20.0),
        ),
        starRatingOptions: StarRatingOptions(),
        onDismissed: () => _rateMyApp.callEvent(
          RateMyAppEventType.laterButtonPressed,
        ),
      );
    });
  }

  void _uploadReviewedBuyers() async {
    Map<String, dynamic> userMap = {
      "hasReviewedBuyers": true,
    };

    print("⏳ ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${user.id}")
        .updateData(userMap)
        .then((r) {
      print("✔️ USER ACTUALIZADO");
      setState(() {
        user.hasReviewedBuyers = true;
      });
    }).catchError((e) {
      print("💩 ERROR AL ACTUALIZAR USER: $e");
    });
  }

  void _handleDescargaApp() async {
    await canLaunch(updateURL)
        ? launch(updateURL)
        : showBasicAlert(
            context,
            'No pudimos actualizar el app',
            'Por favor, vuelve a intentar.',
          );
  }
}
