import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import '../constants.dart';

class M2CellView extends StatelessWidget {
  M2CellView({
    @required this.descuento,
    @required this.cantidad,
    @required this.precio,
  });
  double descuento;
  int cantidad;
  int precio;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 155,
      height: 250,
      decoration: BoxDecoration(
          border: Border.all(color: kWhiteColor),
          borderRadius: kRadiusAll,
          color: kWhiteColor),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                height: 125,
                width: 255,
                decoration: BoxDecoration(
                    borderRadius: kRadiusOnlyTop,
                    image: DecorationImage(
                        image: AssetImage('images/paquetes.png'),
                        fit: BoxFit.fitWidth)),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Center(
                  child: Image(
                    image: AssetImage('images/redimiblesPaquetes.png'),
                    height: 70,
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding:  EdgeInsets.fromLTRB(15, MediaQuery.of(context).size.height * 0.013, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[

                descuento == 0
                    ? Container()
                    : Container(
                      child: FittedBox(
                        child: Text("${(descuento * 100).round()}% off",
                  style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w600)),
                ),
                      ),
                    ),
                Row(
                  children: <Widget>[
                    Container(
                      child: FittedBox(
                        child: Text("x$cantidad ${cantidad == 1 ? "envío" : "envíos"}",
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w300,
                                    color: kBlackColor.withOpacity(0.5)))),
                      ),
                    ),

                  ],
                ),
                Container(child: FittedBox(child: Text(formattedMoneyValue(precio)))),
              ],
            ),
          )
        ],
      ),
    );
  }
}
