import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../constants.dart';

class ContainerAspirante extends StatelessWidget {
  ContainerAspirante(
      {this.vehiculo, this.nombre, this.fotoPerfilUrl, this.onTap});
  String nombre;
  String fotoPerfilUrl;
  String vehiculo;
  Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
        child: Container(
          height: 89,
          width: MediaQuery.of(context).size.width - 34,
          decoration:
              BoxDecoration(borderRadius: kRadiusAll, color: kWhiteColor),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(17, 18, 10, 16),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kTransparent),
                        borderRadius: kRadiusAll,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Color(0x50D1D1D1),
                        highlightColor: Color(0x01D1D1D1),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: kTransparent),
                            borderRadius: kRadiusAll,
                            color: Colors.lightBlue[100],
                          ),
                          height: 53,
                          width: 53,
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Image(
                              image: NetworkImage(fotoPerfilUrl),
                            ),
                          ),
                        ),
                      ),
                      height: 55,
                      width: 53,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: kTransparent),
                        borderRadius: kRadiusAll,
                        image: DecorationImage(
                          image: NetworkImage(fotoPerfilUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 55,
                      width: 53,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ///Nombre
                  Padding(
                    padding: EdgeInsets.only(top: 24, bottom: 2),
                    child: Container(
                        height: 25,
                        width: MediaQuery.of(context).size.width * 0.55,
                        child: Row(
                          children: <Widget>[
                            Text(
                              nombre ?? "",
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 14, color: kBlackColor)),
                            ),
                          ],
                        )),
                  ),

                  /// Comentario
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.55,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          vehiculo ?? "bicicleta",
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 13,
                                  color: kBlackColorOpacity,
                                  fontWeight: FontWeight.w300)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Image(
                  height: 12,
                  image: AssetImage('images/adelante.png'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
