import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ContainerDireccion extends StatelessWidget {
  String contactoName;
  String direccionCompleta;
  Function onTap;
  bool isDeleting;
  bool yaSeleccionado;
  Color colorContainer;
  bool isInMisDirecciones;

  ContainerDireccion({
    this.contactoName,
    this.direccionCompleta,
    this.onTap,
    this.yaSeleccionado,
    this.isDeleting,
    this.isInMisDirecciones,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 10, 17, 0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          width: MediaQuery.of(context).size.width - 34,
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: kRadiusAll,
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(15, 25, 10, 25),
                child: Container(
                  height: 50,
                  width: 50,
                  color: kWhiteColor,
                  child: Image(
                    image: AssetImage(
                      'images/tarjetaDir.png',
                    ),
                    color: kGreenManda2Color,
                    height: 20,
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          contactoName,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: kBlackColor,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 20,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          direccionCompleta,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: kBlackColorOpacity,
                              fontSize: 15,
                            ),
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
              isDeleting ?? false
                  ? Container(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(kBlackColorOpacity),
                        strokeWidth: 3,
                      ),
                    )
                  : yaSeleccionado
                      ? Container()
                      : isInMisDirecciones ?? false
                          ? Expanded(
                              child: Image(
                                height: 12,
                                image: AssetImage('images/adelante.png'),
                              ),
                            )
                          : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
