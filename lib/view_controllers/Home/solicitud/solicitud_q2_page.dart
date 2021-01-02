import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/view_controllers/Home/solicitud/q2_formulario_page.dart';

class SolicitudQ2 extends StatefulWidget {
  SolicitudQ2({this.cantidad, this.categoria});
  int cantidad;
  Categoria categoria;

  @override
  _SolicitudQ2State createState() =>
      _SolicitudQ2State(cantidad: cantidad, categoria: categoria);
}

class _SolicitudQ2State extends State<SolicitudQ2> {
  _SolicitudQ2State({this.cantidad, this.categoria});
  int cantidad;
  Categoria categoria;
  String lugar;

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
                      width: 100 / 3,
                      decoration: BoxDecoration(
                        color: kBlackColor,
                        borderRadius: kRadiusAll,
                      ),
                    ),
                  ],
                ),
                Text(' 2/3', style: TextStyle(fontSize: 12)),
                SizedBox(width: 16),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 32),
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
                width: MediaQuery.of(context).size.width - 35,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '¿Dónde lo recogemos?',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 15)),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          lugar = 'Mi domicilio';
                        });
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => Q2Formulario(
                              vieneMiDomicilio: true,
                              catidad: cantidad,
                              categoria: categoria,
                              tagLugarString: lugar,
                            ),
                          ),
                        );
                      },
                      child: Container(
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
                        height: 67,
                        width: 266,
                        child: Center(
                          child: Text(
                            'En mi domicilio',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 14, color: kBlackColor)),
                          ),
                        ),
                      ),
                    ),
                    CupertinoButton(
                      onPressed: () {
                        setState(() {
                          lugar = 'Otro lugar';
                        });
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => Q2Formulario(
                                      vieneMiDomicilio: false,
                                      catidad: cantidad,
                                      categoria: categoria,
                                      tagLugarString: lugar,
                                    )));
                      },
                      child: Container(
                        height: 67,
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
                          child: Text(
                            'Otro lugar',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 14, color: kBlackColor)),
                          ),
                        ),
                      ),
                    )
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
