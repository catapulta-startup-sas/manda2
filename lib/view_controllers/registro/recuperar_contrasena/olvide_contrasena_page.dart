import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_recuperar_text_field.dart';
import 'package:manda2/firebase/handles/reset_password_handle.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/view_controllers/registro/recuperar_contrasena/confirma_reset_password.dart';

class OlvidePassword extends StatefulWidget {
  @override
  _OlvidePasswordState createState() => _OlvidePasswordState();
}

class _OlvidePasswordState extends State<OlvidePassword> {
  String email;
  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;
  bool isSendingCodeToMail = false;
  Color iconEmailColor = kBlackColor;
  RegExp emailRegExp = RegExp("[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
      "\\@" +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
      "(" +
      "\\." +
      "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
      ")+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        backgroundColor: kLightGreyColor,
        border: Border(
          bottom: BorderSide(
            color: kLightGreyColor,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: FittedBox(
          child: Text(
            "Restaurar contraseña",
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
      body: CatapultaScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            M2TextFieldRecuperar(
              title: "E-mail",
              text: "mariano@manda2.app",
              color: iconEmailColor,
              imageRoute: "images/mail.png",
              keyboardType: TextInputType.emailAddress,
              bottomText:
                  'Enviaremos un mensaje a tu e-mail con indicaciones para restaurar tu contraseña.',
              helpText: '',
              width: MediaQuery.of(context).size.width * 0.15,
              width2: MediaQuery.of(context).size.width * 0.47,
              onChanged: (text) {
                setState(() {
                  email = text;
                  if (emailRegExp.hasMatch(email)) {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                    iconEmailColor = kGreenManda2Color;
                  } else if (email == '') {
                    iconEmailColor = kBlackColor;
                  } else {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                    iconEmailColor = kRedActive;
                  }
                });
              },
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: M2Button(
                title: "Continuar",
                isLoading: isSendingCodeToMail,
                backgroundColor: buttonBackgroundColor,
                shadowColor: buttonShadowColor,
                onPressed: () {
                  if (email == null || email == "") {
                    showBasicAlert(context, "Por favor, ingresa tu email.", "");
                  } else {
                    _sendCodeToMail(context, email);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _sendCodeToMail(context, email) {
    setState(() {
      isSendingCodeToMail = true;
    });
    print("⏳ ENVIARÉ EMAIL");
    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((r) {
      setState(() {
        isSendingCodeToMail = false;
      });
      print("✔️ EMAIL ENVIADO");
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ConfirmacionResetPassword(),
        ),
      );
    }).catchError((e) {
      print("💩 ERROR AL ENVIAR EMAIL: $e");
      if (e is PlatformException) {
        handleResetPasswordError(context, e.code);
      }
      setState(() {
        isSendingCodeToMail = false;
      });
    });
  }
}
