import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';

class ContainerEstadisticas extends StatelessWidget {
  ContainerEstadisticas({
    this.envios,
    this.nombre,
    this.fotoPerfilURL,
    this.onTap,
    this.efectivo,
    this.tarjeta,
    this.numMandados,
  });
  String nombre;
  String fotoPerfilURL;
  int envios;
  int numMandados;
  double efectivo;
  double tarjeta;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
        child: Container(
          height: 121,
          width: MediaQuery.of(context).size.width - 34,
          decoration:
              BoxDecoration(borderRadius: kRadiusAll, color: kWhiteColor),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(17, 26, 10, 47),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kTransparent),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Color(0x50D1D1D1),
                        highlightColor: Color(0x01D1D1D1),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kTransparent),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.lightBlue[100],
                          ),
                          height: 46,
                          width: 46,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Image(
                              image: NetworkImage(fotoPerfilURL),
                            ),
                          ),
                        ),
                      ),
                      height: 46,
                      width: 46,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kTransparent),
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(fotoPerfilURL),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 46,
                      width: 46,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ///Nombre Y # mandados
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: 22,
                        ),
                        child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.32,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                child: Text(
                                  nombre,
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 14, color: kBlackColor)),
                                ),
                              ),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 24),
                        child: Container(
                            height: 20,
                            width: MediaQuery.of(context).size.width * 0.35,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: FittedBox(
                                child: Text(
                                  "${numMandados} mandados",
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 14,
                                          color: kGreenManda2Color)),
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),

                  /// Envios redimibles
                  Row(
                    children: <Widget>[
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                'Envíos redimibles',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        color: kBlackColorOpacity)),
                              ),
                            ),
                          )),
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              child: Text(
                                envios > 1
                                    ? 'x$envios envíos'
                                    : 'x$envios envío',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        color: kBlackColorOpacity)),
                              ),
                            ),
                          )),
                    ],
                  ),

                  /// Efectico
                  Row(
                    children: <Widget>[
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                'Efectivo ',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        color: kBlackColorOpacity)),
                              ),
                            ),
                          )),
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              child: Text(
                                formattedMoneyValue((efectivo).toInt()),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: kBlackColorOpacity,
                                  ),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),

                  /// Tarjetas
                  Row(
                    children: <Widget>[
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.32,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                'Tarjeta de crédito',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        color: kBlackColorOpacity)),
                              ),
                            ),
                          )),
                      Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              child: Text(
                                formattedMoneyValue(tarjeta.toInt()),
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 13,
                                        color: kBlackColorOpacity)),
                              ),
                            ),
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
