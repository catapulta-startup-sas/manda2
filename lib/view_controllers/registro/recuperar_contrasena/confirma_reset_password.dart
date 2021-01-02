import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:manda2/constants.dart';

class ConfirmacionResetPassword extends StatefulWidget {
  @override
  _ConfirmacionResetPasswordState createState() =>
      _ConfirmacionResetPasswordState();
}

class _ConfirmacionResetPasswordState extends State<ConfirmacionResetPassword> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: CatapultaScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Image(
                    image: AssetImage('images/exito.png'),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.04,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      '¡El email se envió exitosamente!',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 18,
                              color: kBlackColor,
                              fontWeight: FontWeight.w400)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.04,
                child: Center(
                  child: FittedBox(
                    child: Text(
                      'Sigue las instrucciones del email y restaura tu contraseña',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 13,
                              color: kBlackColor.withOpacity(0.5),
                              fontWeight: FontWeight.w400)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: M2Button(
                  title: "Iniciar sesión",
                  backgroundColor: kGreenManda2Color,
                  shadowColor: kGreenManda2Color.withOpacity(0.4),
                  onPressed: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => IniciarSesion(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
