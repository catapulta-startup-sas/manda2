import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/view_controllers/Home/home.dart';
import 'package:manda2/view_controllers/Home/solicitud/solicitud_resumen_page.dart';

class Publicado extends StatefulWidget {
  Publicado({this.numDestinos});
  int numDestinos;
  @override
  _PublicadoState createState() => _PublicadoState(numDestinos: numDestinos);
}

class _PublicadoState extends State<Publicado> {
  _PublicadoState({this.numDestinos});

  int numDestinos;
@override

  @override
  Widget build(BuildContext context) {
    if (numDestinos == null) {
      numDestinos = 1;
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: kWhiteColor,
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
                      '¡Mandado solicitado!',
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
                    mandadoGlobal.tipoPago == 'Tarjeta de crédito'
                        ? 'Se han descontado ${formattedMoneyValue(10000 * numDestinos)} de tu tarjeta.'
                        : mandadoGlobal.tipoPago == 'Envíos redimibles'
                            ? numDestinos > 1
                                ? 'Se han redimido x$numDestinos envíos redimibles.'
                                : 'Se ha redimido x$numDestinos envío redimible.'
                            : "Recuerda pagar en efectivo a los colaboradores.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 13,
                        color: kBlackColor.withOpacity(0.5),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: Container()),
              Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: M2Button(
                  title: "Ver mandados",
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
      ),
    );
  }
}
