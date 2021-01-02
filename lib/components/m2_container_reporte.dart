import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';

class ContainerReporte extends StatelessWidget {
  ContainerReporte(
      {this.comentario,
      this.nombre,
      this.fotoPerfilURL,
      this.onTap,
      this.isDomi,
      this.fecha});

  String nombre;
  String fotoPerfilURL;
  String comentario;
  Function onTap;
  bool isDomi;
  String fecha;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.fromLTRB(10, 30, 10, 30),
        width: MediaQuery.of(context).size.width - 34,
        decoration: BoxDecoration(borderRadius: kRadiusAll, color: kWhiteColor),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(6, 0, 12, 0),
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
                ///Nombre y comprador
                Row(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                nombre,
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 14, color: kBlackColor)),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Text(
                              isDomi ? 'Colaborador' : 'Comprador',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14, color: kBlackColorOpacity)),
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),

                /// Comentario
                Row(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                comentario,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: kBlackColorOpacity,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(),
                            ),
                            Image(
                              image: AssetImage('images/adelante.png'),
                              height: 15,
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(height: 10),
                Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Text(
                        fecha ?? 'hoy',
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 13,
                                color: kBlackColorOpacity,
                                fontWeight: FontWeight.w300)),
                      ),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
