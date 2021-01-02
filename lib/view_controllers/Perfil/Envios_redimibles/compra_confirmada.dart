import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/view_controllers/Home/home.dart';
import 'package:manda2/view_controllers/Home/solicitud/solicitud_q1_page.dart';

class Confirmada extends StatefulWidget {
  Confirmada({
    this.precio,
  });

  final int precio;

  @override
  _ConfirmadaState createState() => _ConfirmadaState(
        precio: precio,
      );
}

class _ConfirmadaState extends State<Confirmada> {
  _ConfirmadaState({
    this.precio,
  });

  final int precio;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
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
                    'Compra realizada',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 18,
                        color: kBlackColor,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Center(
                child: Text(
                  'Se han descontado ${formattedMoneyValue(precio)} de tu tarjeta',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 13,
                      color: kBlackColor.withOpacity(0.5),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: M2Button(
                title: "Ir al inicio",
                backgroundColor: kGreenManda2Color,
                shadowColor: kGreenManda2Color.withOpacity(0.4),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Home(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
