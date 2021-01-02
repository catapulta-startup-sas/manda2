import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/functions/get_dispositivo_type.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants.dart';

class ActualizarPage extends StatefulWidget {
  @override
  _ActualizarPageState createState() => _ActualizarPageState();
}

class _ActualizarPageState extends State<ActualizarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 2, child: Container()),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: kTransparent),
              borderRadius: kRadiusAll,
              image: DecorationImage(
                image: AssetImage("images/iconoApp.png"),
                fit: BoxFit.cover,
              ),
            ),
            height: MediaQuery.of(context).size.width * 0.2,
            width: MediaQuery.of(context).size.width * 0.2,
          ),
          SizedBox(height: 48),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Text(
              "Esta versión de Manda2 expiró. Por favor, visita ${dispositivo == Dispositivo.ios ? "App" : "Play"} Store para actualizarla.",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: kBlackColor,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(child: Container()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: 28),
            child: Text(
              "Las actualizaciones son gratuitas.",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: kBlackColorOpacity,
                ),
              ),
            ),
          ),
          M2Button(
            title: "Actualizar Manda2",
            backgroundColor: kGreenManda2Color,
            shadowColor: kGreenManda2Color.withOpacity(0.4),
            onPressed: () async {
              if (await canLaunch(updateURL)) {
                await launch(updateURL);
              } else {
                throw 'Could not launch $updateURL';
              }
            },
          ),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}
