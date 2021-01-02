import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_divider.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/formato_fecha.dart';
import 'package:manda2/functions/launch_whatsapp.dart';
import 'package:manda2/functions/slide_right_route.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:shimmer/shimmer.dart';

class ResumenAdmin extends StatefulWidget {
  final Mandado mandado;
  bool isDomi;

  ResumenAdmin({
    this.mandado,
    this.isDomi,
  });
  @override
  _ResumenAdminState createState() => _ResumenAdminState(
        mandado: mandado,
        isDomi: isDomi,
      );
}

class _ResumenAdminState extends State<ResumenAdmin> {
  final Mandado mandado;
  bool isDomi;

  bool successContainerIsHidden = true;

  _ResumenAdminState({
    this.mandado,
    this.isDomi,
  });

  bool tarjeta = false;
  bool efectivo = false;
  bool redimibles = false;
  bool pagoExitoso = false;

  bool isConfirmandoPago = false;
  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;

  @override
  void initState() {
    super.initState();
  }

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
            'Detalles de mandado',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(17, 17, 17, 20),
              child: Text(
                "Categoría: ${mandado.categoria.title} ${mandado.categoria.emoji}",
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 15,
                        color: kBlackColorOpacity,
                        fontWeight: FontWeight.w300)),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width - 110,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Punto A
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'De',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: kBlackColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "${mandado.origen.direccion}, ${mandado.origen.ciudad}",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: kBlackColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Punto B
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 17),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Text(
                            'A',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: kBlackColor,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "   ${mandado.destino.direccion}, ${mandado.destino.ciudad}",
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: kBlackColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Linea
            Padding(
              padding: EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: M2Divider(),
            ),

            /// Fecha maxima
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 30),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Fecha límite',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: kBlackColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      mandado.fechaMaxEntrega.isBefore(DateTime.now()) &&
                              !mandado.isTomado
                          ? Text(
                              "Vencido",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontSize: 15,
                                  color: kRedActive,
                                ),
                              ),
                            )
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                /// Fecha
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.42,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      mandado.fechaMaxEntrega
                                              .isBefore(DateTime.now())
                                          ? "${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.fechaMaxEntrega.millisecondsSinceEpoch))}"
                                          : "${dateFormattedFromDateTime(mandado.fechaMaxEntrega)}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          color: kBlackColor.withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Tipo de pago',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: kBlackColor,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Text(
                        "${mandado.tipoPago}",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: kBlackColorOpacity,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            /// Linea
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
              child: M2Divider(),
            ),

            /// Identificador
            Padding(
              padding: EdgeInsets.fromLTRB(17, 0, 17, 20),
              child: Row(
                children: <Widget>[
                  Container(
                    height: 25,
                    width: 110,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          'Identificador',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: kBlackColor,
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Container(
                    height: 25,
                    width: 110,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${mandado.identificador}',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: kBlackColor.withOpacity(0.5),
                            ),
                          ),
                        )),
                  ),
                ],
              ),
            ),

            /// Estado
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 17, bottom: 20),
                  child: Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Text(
                          'Estado',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: kBlackColor,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 17, bottom: 15),
                  child: Container(
                    height: 25,
                    width: 110,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          mandado.isEntregado &&
                                  mandado.isTomado &&
                                  mandado.isRecogido
                              ? 'Entregado'
                              : mandado.isTomado && mandado.isRecogido
                                  ? 'Recogido'
                                  : mandado.isTomado
                                      ? 'Tomado'
                                      : 'Publicado',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 15,
                              color: kBlackColor.withOpacity(0.5),
                            ),
                          ),
                        )),
                  ),
                ),
              ],
            ),

            /// Linea
            Padding(
              padding: EdgeInsets.fromLTRB(0, 12, 0, 20),
              child: M2Divider(),
            ),

            mandado.isTomado && !isDomi
                ? Container(
                    height: 25,
                    width: 110,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        child: Padding(
                          padding: EdgeInsets.only(left: 17),
                          child: Text(
                            'Colaborador encargado',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                color: kBlackColor,
                                fontWeight: FontWeight.w300),
                          ),
                        ),
                      ),
                    ),
                  )
                : Container(),

            mandado.isTomado && !isDomi
                ? Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 24),
                    child: Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Stack(
                            children: <Widget>[
                              Shimmer.fromColors(
                                baseColor: Color(0x50D1D1D1),
                                highlightColor: Color(0x01D1D1D1),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: kTransparent),
                                    borderRadius: kRadiusAll,
                                    color: Colors.lightBlue[100],
                                  ),
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: kTransparent),
                                  borderRadius: kRadiusAll,
                                  image: DecorationImage(
                                    image: NetworkImage(mandado
                                            .domiciliario.user.fotoPerfilURL ??
                                        "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                height: 40,
                                width: 40,
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FittedBox(
                                child: Text(
                                  '${mandado.domiciliario.user.name}',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              Row(
                                children: <Widget>[
                                  Image(
                                    image: AssetImage(
                                      'images/estrella.png',
                                    ),
                                    fit: BoxFit.fitHeight,
                                    color: kGreenManda2Color,
                                    height: 11,
                                  ),
                                  FittedBox(
                                    child: Text(
                                      ' ${mandado.domiciliario.califPromedio != null ? (mandado.domiciliario.califPromedio * 10).roundToDouble() / 10 : 0.0}',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),

            mandado.isTomado && !isDomi
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: CupertinoButton(
                        child: Text(
                          'Contactar colaborador',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              color: kGreenManda2Color,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        onPressed: () {
                          launchWhatsApp(
                              context, mandado.domiciliario.user.phoneNumber);
                        }),
                  )
                : const SizedBox.shrink(),

            SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  void pushWithPopAnimation(BuildContext context, Widget widget) {
    Navigator.push(context, SlideRightRoute(page: widget));
  }
}
