import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formato_fecha.dart';

class EstadoMandado extends StatefulWidget {
  EstadoMandado({
    @required this.contactoName,
    @required this.direccion,
    this.imageRoute,
    @required this.estado,
    this.color,
    this.onTap,
    this.identificador,
    this.referencia,
    this.relevantDateTimeMSE,
    this.showsProgress,
    this.estadoDelMandado,
    this.isVencido,
  });
  final String contactoName;
  final String direccion;
  final String imageRoute;
  final String estado;
  final String identificador;
  final String referencia;
  final bool showsProgress;
  final int relevantDateTimeMSE;
  final Color color;
  final Function onTap;
  bool isVencido;
  EstadoDelMandado estadoDelMandado;

  @override
  _EstadoMandadoState createState() => _EstadoMandadoState();
}

enum EstadoDelMandado {
  publicado,
  recogido,
  tomado,
  entregado,
  vencido,
}

class _EstadoMandadoState extends State<EstadoMandado> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(17, 20, 17, 0),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            width: MediaQuery.of(context).size.width - 34,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: kRadiusAll,
              boxShadow: [
                BoxShadow(
                  color: kBlackColorOpacity.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ///Contacto
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 19,
                        child: Text(
                          widget.contactoName,
                          style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 14, color: kBlackColor)),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.all(0),
                        child: Text(
                          "Detalles",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: kGreenManda2Color)),
                        ),
                        onPressed: widget.onTap,
                      ),
                    ],
                  ),
                ),

                ///Direccion
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            widget.direccion ?? "",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: kBlackColorOpacity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                    ],
                  ),
                ),

                ///estado icono
                !widget.showsProgress
                    ? Row(
                        children: <Widget>[
                          Text(
                            widget.estado,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: widget.color ?? kBlackColorOpacity,
                              ),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Image(
                            image: AssetImage(
                              widget.imageRoute ?? 'images/enCamino.png',
                            ),
                            width: 30,
                          )
                        ],
                      )
                    : Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 7),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  widget.estadoDelMandado ==
                                          EstadoDelMandado.publicado
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: kTransparent,
                                                borderRadius: kRadiusAll,
                                              ),
                                              child: Image.asset(
                                                'images/publicado.png',
                                                color: kBlackColorOpacity,
                                              ),
                                            ),
                                            Text(
                                              dateFormattedFromDateTime(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      widget
                                                          .relevantDateTimeMSE)),
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: widget.color ??
                                                      kBlackColorOpacity,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          height: 9,
                                          width: 9,
                                          decoration: BoxDecoration(
                                            color: kTransparent,
                                            borderRadius: kRadiusAll,
                                          ),
                                        ),
                                  Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width *
                                        0.13,
                                    decoration: BoxDecoration(
                                      color: kTransparent,
                                      borderRadius: kRadiusAll,
                                    ),
                                  ),
                                  widget.estadoDelMandado ==
                                          EstadoDelMandado.tomado
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: kTransparent,
                                                borderRadius: kRadiusAll,
                                              ),
                                              child: Image.asset(
                                                'images/domiciliario.png',
                                                color: kBlackColorOpacity,
                                              ),
                                            ),
                                            Text(
                                              dateFormattedFromDateTime(DateTime
                                                  .fromMillisecondsSinceEpoch(
                                                      widget
                                                          .relevantDateTimeMSE)),
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: widget.color ??
                                                      kBlackColorOpacity,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          height: 9,
                                          width: 9,
                                          decoration: BoxDecoration(
                                            color: kTransparent,
                                            borderRadius: kRadiusAll,
                                          ),
                                        ),
                                  Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width *
                                        0.13,
                                    decoration: BoxDecoration(
                                      color: kTransparent,
                                      borderRadius: kRadiusAll,
                                    ),
                                  ),
                                  widget.estadoDelMandado ==
                                          EstadoDelMandado.recogido
                                      ? Column(
                                          children: <Widget>[
                                            Container(
                                              height: 30,
                                              width: 30,
                                              decoration: BoxDecoration(
                                                color: kTransparent,
                                                borderRadius: kRadiusAll,
                                              ),
                                              child: Image.asset(
                                                'images/domiciliario.png',
                                                color: kBlackColorOpacity,
                                              ),
                                            ),
                                            Text(
                                              dateFormattedFromDateTime(
                                                DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                  widget.relevantDateTimeMSE,
                                                ),
                                              ),
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 13,
                                                  color: widget.color ??
                                                      kBlackColorOpacity,
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Container(
                                          height: 9,
                                          width: 9,
                                          decoration: BoxDecoration(
                                            color: kTransparent,
                                            borderRadius: kRadiusAll,
                                          ),
                                        ),
                                  Container(
                                    height: 2,
                                    width: MediaQuery.of(context).size.width *
                                        0.13,
                                    decoration: BoxDecoration(
                                      color: kTransparent,
                                      borderRadius: kRadiusAll,
                                    ),
                                  ),
                                  Container(
                                    height: 9,
                                    width: 9,
                                    decoration: BoxDecoration(
                                      color: kTransparent,
                                      borderRadius: kRadiusAll,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///LINEA DE ESTADO
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  height: 9,
                                  width: 9,
                                  decoration: BoxDecoration(
                                    color: kGreenManda2Color,
                                    borderRadius: kRadiusAll,
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
                                  decoration: BoxDecoration(
                                    color: widget.estadoDelMandado ==
                                                EstadoDelMandado.tomado ||
                                            widget.estadoDelMandado ==
                                                EstadoDelMandado.recogido
                                        ? kGreenManda2Color
                                        : kBlackColorOpacity,
                                    borderRadius: kRadiusAll,
                                  ),
                                ),
                                Container(
                                  height: 9,
                                  width: 9,
                                  decoration: BoxDecoration(
                                    color: widget.estadoDelMandado ==
                                                EstadoDelMandado.tomado ||
                                            widget.estadoDelMandado ==
                                                EstadoDelMandado.recogido
                                        ? kGreenManda2Color
                                        : kBlackColorOpacity,
                                    borderRadius: kRadiusAll,
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
                                  decoration: BoxDecoration(
                                    color: widget.estadoDelMandado ==
                                            EstadoDelMandado.recogido
                                        ? kGreenManda2Color
                                        : kBlackColorOpacity,
                                    borderRadius: kRadiusAll,
                                  ),
                                ),
                                Container(
                                  height: 9,
                                  width: 9,
                                  decoration: BoxDecoration(
                                    color: widget.estadoDelMandado ==
                                            EstadoDelMandado.recogido
                                        ? kGreenManda2Color
                                        : kBlackColorOpacity,
                                    borderRadius: kRadiusAll,
                                  ),
                                ),
                                Container(
                                  height: 2,
                                  width:
                                      MediaQuery.of(context).size.width * 0.13,
                                  decoration: BoxDecoration(
                                    color: kBlackColorOpacity,
                                    borderRadius: kRadiusAll,
                                  ),
                                ),
                                Container(
                                  height: 9,
                                  width: 9,
                                  decoration: BoxDecoration(
                                    color: kBlackColorOpacity,
                                    borderRadius: kRadiusAll,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                widget.estado,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    color: widget.isVencido
                                        ? kRedActive
                                        : kBlackColor,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),

                ///identificador
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 20),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 19,
                        child: Text(
                          'Identificador',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: kBlackColorOpacity)),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Container(
                        height: 19,
                        child: Text(
                          widget.identificador,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: kBlackColorOpacity)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
