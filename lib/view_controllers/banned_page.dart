import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/functions/launch_whatsapp.dart';
import '../constants.dart';

class BannedPage extends StatefulWidget {
  @override
  _BannedPageState createState() => _BannedPageState();
}

class _BannedPageState extends State<BannedPage> {
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
              "Un administrador inhabilitó tu cuenta.",
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
          M2Button(
            title: "Escribir a soporte",
            backgroundColor: kGreenManda2Color,
            shadowColor: kGreenManda2Color.withOpacity(0.4),
            onPressed: () async {
              launchWhatsApp(context, contactoSoporte);
            },
          ),
          SizedBox(height: 48),
        ],
      ),
    );
  }
}
