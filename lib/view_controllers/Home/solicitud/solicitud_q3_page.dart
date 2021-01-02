import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/view_controllers/Home/solicitud/q2_formulario_page.dart';
import 'package:manda2/view_controllers/Home/solicitud/q3_set_places_page.dart';

class SolicitudQ3 extends StatefulWidget {
  SolicitudQ3({
    this.cantidad,
    this.categoria,
    this.lugarString,
    this.origen,
  });
  int cantidad;
  Categoria categoria;
  String lugarString;
  Lugar origen;
  Mandado mandado;

  @override
  _SolicitudQ3State createState() => _SolicitudQ3State(
        cantidad: cantidad,
        categoria: categoria,
        lugarString: lugarString,
        origen: origen,
      );
}

class _SolicitudQ3State extends State<SolicitudQ3> {
  _SolicitudQ3State({
    this.cantidad,
    this.categoria,
    this.lugarString,
    this.origen,
  });
  int cantidad;
  Categoria categoria;
  String lugarString;
  Lugar origen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        border: Border(
          bottom: BorderSide(
            color: kTransparent,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        backgroundColor: kLightGreyColor,
        middle: FittedBox(
          child: Text(
            "Solicitud de mandado",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 17,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                        color: kBlackColorOpacity,
                        borderRadius: kRadiusAll,

                      ),
                    ),
                    Container(
                      height: 4,
                      width: 50,
                      decoration: BoxDecoration(
                        color: kBlackColor,
                        borderRadius: kRadiusAll,

                      ),
                    ),
                  ],
                ),
                Text(' 3/3',
                    style: TextStyle(
                        fontSize: 12
                    )
                ),
                SizedBox(width: 16),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Container(

                height: 200,
                width: MediaQuery.of(context).size.width - 35,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('¿A dónde lo llevamos?',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: kBlackColor
                      )
                    ),),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Q3SetPlaces(
                              numDestinos: cantidad,
                              categoria: categoria,
                              tagOrigen: lugarString,
                              origen: origen,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 67 ,
                        width: 266,
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
                        child: Center(
                          child: Text('Editar lugares',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 14,
                                    color: kBlackColor
                                )
                            ),),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
