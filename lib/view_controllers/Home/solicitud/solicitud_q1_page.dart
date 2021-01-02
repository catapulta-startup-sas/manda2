import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/view_controllers/Home/solicitud/solicitud_q2_page.dart';

class SolicitudQ1 extends StatefulWidget {
  SolicitudQ1({
    this.categoria,
  });
  final Categoria categoria;
  @override
  _SolicitudQ1State createState() => _SolicitudQ1State(categoria: categoria);
}

class _SolicitudQ1State extends State<SolicitudQ1> {
  _SolicitudQ1State({
    this.categoria,
  });
  final Categoria categoria;
  int cantidad = 0;
  bool isHiddenContainer = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        border: Border(
          bottom: BorderSide(
            color: kLightGreyColor,
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
          children: <Widget>[
            isHiddenContainer
                ? Container(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(26, 10, 12, 24),
                    decoration: BoxDecoration(
                      color: kGreenColor,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              isHiddenContainer = false;
                            });
                          },
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              height: 10,
                              width: 20,
                              child: Image.asset(
                                'images/cerrar.png',
                                color: kBlackColor,
                                height: 10,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'En Manda2:',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(fontSize: 12)),
                        ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'images/flechaAviso.png',
                              height: 18,
                              width: 13,
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'Puedes pedir más de un mandado al tiempo.',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'images/flechaAviso.png',
                              height: 18,
                              width: 13,
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'Cada mandado es una solicitud diferente.',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'images/flechaAviso.png',
                              height: 18,
                              width: 13,
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                'Podremos asignar uno o más colaboradores.',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Expanded(flex: 2, child: Container()),
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
                      width: 50 / 3,
                      decoration: BoxDecoration(
                        color: kBlackColor,
                        borderRadius: kRadiusAll,
                      ),
                    ),
                  ],
                ),
                Text(' 1/3', style: TextStyle(fontSize: 12)),
                SizedBox(width: 16),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 32, horizontal: 26),
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
                  children: <Widget>[
                    Text(
                      '¿Cuántos mandados de esta categoría (${categoria.emoji}) llevamos por ti?',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 15, color: kBlackColor)),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (cantidad > 0) {
                                cantidad--;
                                HapticFeedback.selectionClick();
                              }
                            });
                          },
                          child: Container(
                              height: 37,
                              width: 37,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cantidad == 0
                                    ? kBlackColorOpacity
                                    : kBlackColor,
                                borderRadius: kRadiusButton,
                              ),
                              child: Image.asset('images/-.png')),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                          ),
                          child: Container(
                            width: 30,
                            child: Center(
                              child: Text(
                                '$cantidad',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              if (cantidad < 999) {
                                cantidad++;
                                HapticFeedback.selectionClick();
                              }
                            });
                          },
                          child: Container(
                              height: 37,
                              width: 37,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: cantidad == 999
                                    ? kBlackColorOpacity
                                    : kBlackColor,
                                borderRadius: kRadiusButton,
                              ),
                              child: Image.asset('images/+.png')),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Expanded(child: Container()),
            M2Button(
              title: 'Continuar',
              backgroundColor:
                  cantidad > 0 ? kGreenManda2Color : kBlackColorOpacity,
              shadowColor: cantidad > 0
                  ? kGreenManda2Color.withOpacity(0.4)
                  : kBlackColorOpacity.withOpacity(0.4),
              onPressed: () {
                if (cantidad > 0) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => SolicitudQ2(
                                cantidad: cantidad,
                                categoria: categoria,
                              )));
                } else {
                  showBasicAlert(
                      context,
                      'Por favor elige cuantos ${categoria.emoji} ${categoria.title} llevamos por ti.',
                      '');
                }
              },
            ),
            SizedBox(
              height: 48,
            )
          ],
        ),
      ),
    );
  }
}
