import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/llamar.dart';
import 'package:shimmer/shimmer.dart';

class ContainerInfo extends StatelessWidget {
  ContainerInfo({
    this.fotoPerfilURL,
    this.noDocumento,
    this.telefono,
    this.nombre,
    this.onTap,
  });
  String nombre;
  String noDocumento;
  String telefono;
  String fotoPerfilURL;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17, 20, 17, 20),
      child: Container(
        height: 121,
        width: MediaQuery.of(context).size.width - 34,
        decoration: BoxDecoration(borderRadius: kRadiusAll, color: kWhiteColor),
        child: Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 19),
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kTransparent),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: Shimmer.fromColors(
                      baseColor: Color(0x50D1D1D1),
                      highlightColor: Color(0x01D1D1D1),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: kTransparent),
                          borderRadius: BorderRadius.circular(9),
                          color: Colors.lightBlue[100],
                        ),
                        height: 77,
                        width: 74,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Image(
                            image: NetworkImage(fotoPerfilURL),
                          ),
                        ),
                      ),
                    ),
                    height: 77,
                    width: 74,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kTransparent),
                      borderRadius: BorderRadius.circular(9),
                      image: DecorationImage(
                        image: NetworkImage(fotoPerfilURL),
                        fit: BoxFit.cover,
                      ),
                    ),
                    height: 77,
                    width: 74,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ///Nombre
                Padding(
                  padding: EdgeInsets.only(left: 17),
                  child: Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      nombre,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 14, color: kBlackColorOpacity)),
                    ),
                  ),
                ),

                /// Telefono
                Row(
                  children: <Widget>[
                    /// numero
                    Padding(
                      padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
                      child: Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              noDocumento,
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 13,
                                      color: kBlackColor,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// icono
                    GestureDetector(
                      onTap: () {
                        llamar(context, telefono);
                      },
                      child: Container(
                        height: 20,
                        child: Image(
                          image: AssetImage('images/celular.png'),
                          color: kGreenManda2Color,
                        ),
                      ),
                    )
                  ],
                ),

                /// Comprador
                Padding(
                  padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
                  child: GestureDetector(
                    onTap: onTap,
                    child: Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          child: Text(
                            'Ver datos bancarios',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 13,
                                    color: kGreenManda2Color,
                                    fontWeight: FontWeight.w300)),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
