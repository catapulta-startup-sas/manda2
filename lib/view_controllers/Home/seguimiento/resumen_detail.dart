import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_divider.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/formato_fecha.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/functions/launch_whatsapp.dart';
import 'package:manda2/functions/llamar.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/functions/slide_right_route.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/view_controllers/Home/seguimiento/calificar.dart';
import 'package:shimmer/shimmer.dart';

class ResumenDetail extends StatefulWidget {
  final Mandado mandado;

  ResumenDetail({
    this.mandado,
  });
  @override
  _ResumenDetailState createState() => _ResumenDetailState(mandado: mandado);
}

class _ResumenDetailState extends State<ResumenDetail> {
  final Mandado mandado;

  bool successContainerIsHidden = true;

  _ResumenDetailState({
    this.mandado,
  });
  List<String> cuotasList = <String>[
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24"
  ];

  int cuotas = 12;
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

    Future.delayed(Duration(seconds: 1)).then((r) {
      _handleExpiryAlert();
    });
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
            mandado.identificador,
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
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          CatapultaScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                M2AnimatedContainer(
                  height: successContainerIsHidden ? 0 : 50,
                  backgroundColor: kGreenManda2Color.withOpacity(0.85),
                  text: "Calificación enviada",
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(17, 17, 17, 0),
                  child: Text(
                    "Categoría: ${mandado.categoria.title} ${mandado.categoria.emoji}",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 15,
                            color: kBlackColorOpacity,
                            fontWeight: FontWeight.w300)),
                  ),
                ),

                /// Punto A
                Padding(
                  padding: EdgeInsets.all(17),
                  child: Row(
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

                /// Linea
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: M2Divider(),
                ),

                /// Fecha maxima
                Padding(
                  padding: EdgeInsets.fromLTRB(17, 0, 17, 17),
                  child: Container(
                    height: 50,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        FittedBox(
                          child: Text(
                            'Fecha máx entrega',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: kBlackColor,
                                fontWeight: FontWeight.w300,
                              ),
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
                                    width: MediaQuery.of(context).size.width *
                                        0.42,
                                    child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        mandado.fechaMaxEntrega
                                                .isBefore(DateTime.now())
                                            ? "${dateFormattedFromDateTime(DateTime.fromMillisecondsSinceEpoch(mandado.fechaMaxEntrega.millisecondsSinceEpoch))}"
                                            : "${dateFormattedFromDateTime(mandado.fechaMaxEntrega)}",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 16,
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
                  ),
                ),

                /// Notas
                mandado.descripcion == null || mandado.descripcion == ""
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          /// Linea
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                            child: M2Divider(),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 17, bottom: 18),
                            child: Text(
                              'Notas al colaborador',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 15,
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(17, 0, 17, 30),
                            child: Text(
                              mandado.descripcion == null
                                  ? ''
                                  : '${mandado.descripcion}',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kBlackColor.withOpacity(0.5),
                                      fontWeight: FontWeight.w300)),
                            ),
                          ),
                        ],
                      ),

                /// Linea
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
                  child: M2Divider(),
                ),

                /// Total
                Padding(
                  padding: EdgeInsets.fromLTRB(17, 0, 17, 30),
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 25,
                        width: 110,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            child: Text(
                              mandado.isEntregado ||
                                      mandado.tipoPago == 'Envíos redimibles' ||
                                      mandado.tipoPago == 'Tarjeta de crédito'
                                  ? 'Total pagado'
                                  : 'Total a pagar',
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
                          child: mandado.tipoPago == 'Envíos redimibles'
                              ? Text(
                                  "x1 envío",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              : Text(
                                  formattedMoneyValue(mandado.total),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                /// Método de pago
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
                              'Método de pago',
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
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: FittedBox(
                            child: Text(
                              mandado.tipoPago == 'Envíos redimibles'
                                  ? 'Envío redimible'
                                  : mandado.tipoPago ==
                                          'Efectivo contra entrega'
                                      ? 'Efectivo'
                                      : 'Online',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(fontSize: 15),
                                  color: kBlackColorOpacity,
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                /// Muestra el método de pago
                mandado.tipoPago == "Tarjeta de crédito"
                    ? Container(
                        height: 60,
                        child: Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 17),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        'Tarjeta',
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      Container()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 18),
                                  child: Text(
                                    'Número de cuotas',
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: kBlackColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      child: getCardTypeIcon(_creditCardType()),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(right: 17),
                                      child: Text(
                                        "${mandado.lastFourDigits}",
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 17),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "${mandado.cuotas ?? 12}",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: kBlackColorOpacity,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ))
                    : Container(),

                /// Linea
                mandado.isTomado
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(0, 15, 0, 20),
                        child: M2Divider(),
                      )
                    : Container(),

                mandado.domiciliario.user.fotoPerfilURL != null &&
                        mandado.isTomado
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

                mandado.domiciliario.user.fotoPerfilURL != null &&
                        mandado.isTomado
                    ? Padding(
                        padding: EdgeInsets.fromLTRB(17, 0, 17, 24),
                        child: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Stack(
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
                                          border:
                                              Border.all(color: kTransparent),
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: Colors.lightBlue[100],
                                        ),
                                        height: 40,
                                        width: 40,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Image(
                                            image: NetworkImage(
                                              mandado.domiciliario.user
                                                  .fotoPerfilURL,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    height: 40,
                                    width: 40,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kTransparent),
                                      borderRadius: BorderRadius.circular(9),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          mandado
                                              .domiciliario.user.fotoPerfilURL,
                                        ),
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
                mandado.domiciliario.user.fotoPerfilURL != null &&
                        mandado.isTomado
                    ? Padding(
                        padding: EdgeInsets.only(left: 17, bottom: 24),
                        child: mandado.isCalificado
                            ? Text(
                                'Calificado',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: kBlackColorOpacity,
                                  ),
                                ),
                              )
                            : mandado.isEntregado
                                ? GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        CupertinoPageRoute(
                                          builder: (context) => Calificar(
                                            mandado: mandado,
                                          ),
                                        ),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          successContainerIsHidden = false;
                                          mandado.domiciliario.califPromedio =
                                              result as double;
                                          mandado.isCalificado = true;
                                        });
                                        Future.delayed(Duration(seconds: 3))
                                            .then((r) {
                                          setState(() {
                                            successContainerIsHidden = true;
                                          });
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Calificar',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: kGreenManda2Color,
                                        ),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      llamar(
                                        context,
                                        mandado.domiciliario.user.phoneNumber,
                                      );
                                    },
                                    child: Text(
                                      'Llamar al colaborador',
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 14,
                                          color: kGreenManda2Color,
                                        ),
                                      ),
                                    ),
                                  ),
                      )
                    : Container(),

                /// Linea
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 12, 0, 20),
                  child: M2Divider(),
                ),

                Align(
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                      child: Text(
                        'Escribir a soporte',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 14,
                            color: kGreenManda2Color,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                      onPressed: () {
                        launchWhatsApp(context, contactoSoporte);
                      }),
                ),

                mandado.isTomado ||
                        mandado.tipoPago == 'Envíos redimibles' ||
                        mandado.tipoPago == 'Tarjeta de crédito'
                    ? mandado.isEntregado
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: CupertinoButton(
                              child: Text(
                                'Eliminar mandado',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    color: kRedActive,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _handleDeleteAlert();
                              },
                            ),
                          )
                        : Container()
                    : Align(
                        alignment: Alignment.centerLeft,
                        child: CupertinoButton(
                          child: Text(
                            'Eliminar mandado',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 14,
                                color: kRedActive,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          onPressed: _handleDeleteAlert,
                        ),
                      ),

                SizedBox(height: 120),
              ],
            ),
          ),
          mandado.isEntregado ||
                  mandado.tipoPago == 'Envíos redimibles' ||
                  mandado.tipoPago == "Tarjeta de crédito"
              ? Container()
              : Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
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
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Text(
                        "Recuerda pagar el valor total al colaborador en efectivo.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: kBlackColorOpacity,
                            fontSize: 15,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  CardType _creditCardType() {
    switch (mandado.cardType) {
      case "AMEX":
        return CardType.americanExpress;
        break;
      case "DISCOVER":
        return CardType.discover;
        break;
      case "MASTERCARD":
        return CardType.mastercard;
        break;
      case "VISA":
        return CardType.visa;
        break;
      default:
        return CardType.otherBrand;
        break;
    }
  }

  Widget getCardTypeIcon(CardType cardType) {
    Widget icon;
    switch (cardType) {
      case CardType.visa:
        icon = Image.asset(
          'icons/visa.png',
          height: 34,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      case CardType.americanExpress:
        icon = Image.asset(
          'icons/amex.png',
          height: 34,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      case CardType.mastercard:
        icon = Image.asset(
          'icons/mastercard.png',
          height: 34,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      case CardType.discover:
        icon = Image.asset(
          'icons/discover.png',
          height: 34,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      default:
        icon = Container(
          height: 34,
          width: 48,
        );
        break;
    }
    return icon;
  }

  void _handleDeleteAlert() {
    showAlert(
      context: context,
      title: "Eliminar mandado",
      body: "No podrás recuperar este mandado.",
      actions: [
        AlertAction(
          text: "Volver",
        ),
        AlertAction(
          text: "Eliminar",
          isDestructiveAction: true,
          onPressed: () {
            if (mandado.isEntregado) {
              _ocultarMandado();
            } else {
              _deleteMandado();
            }
          },
        )
      ],
    );
  }

  void _handleExpiryAlert() {
    if (mandado.fechaMaxEntrega.isBefore(DateTime.now()) && !mandado.isTomado) {
      showAlert(
        context: context,
        title: "El mandado expiró",
        body:
            "Ningún colaborador tomó el mandado antes de la fecha máxima. Extiende el plazo por 1 día o elimínalo.",
        actions: [
          AlertAction(
            text: "Extender",
            onPressed: _extenderPlazo,
          ),
          AlertAction(
            text: "Eliminar",
            isDestructiveAction: true,
            onPressed: _deleteMandado,
          )
        ],
      );
    }
  }

  void _ocultarMandado() {
    Map<String, dynamic> mandadoMap = {
      "estados.isHidden": true,
    };

    print("OCULTARÉ MANDADO");
    Firestore.instance
        .document("mandadosDesarrollo/${mandado.id}")
        .updateData(mandadoMap)
        .then((value) {
      print("MANDADO OCULTO");

      List<Categoria> categoriasTemp = user.categorias;
      categoriasTemp.forEach((categoria) {
        if (categoria.emoji == mandado.categoria.emoji &&
            categoria.title == mandado.categoria.title) {
          categoria.numMandados--;
        }
      });

      List<Map<String, dynamic>> categoriasMapList = List();

      categoriasTemp.forEach((categoria) {
        categoriasMapList.add({
          "title": categoria.title,
          "emoji": categoria.emoji,
          "numMandados": categoria.numMandados,
          "isHidden": categoria.isHidden,
        });
      });

      Map<String, dynamic> userMap = {
        "categorias": categoriasMapList.reversed.toList(),
      };

      print("⏳ ACTUALIZARÉ USER");
      Firestore.instance
          .document("users/${user.id}")
          .updateData(userMap)
          .then((r) {
        print("✔️ USER ACTUALIZADO");
        setState(() {
          user.categorias = categoriasTemp;
        });
        Navigator.pop(context, "OCULTO");
      }).catchError((e) {
        print("💩 ERROR AL ACTUALIZAR USER: $e");
        Navigator.pop(context, "OCULTO");
      });
    }).catchError((e) {
      print("ERROR AL OCULTAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error",
        "Por favor, intenta más tarde.",
      );
    });
  }

  void _extenderPlazo() async {
    print("⏳ EXTENDERÉ PLAZO");
    Map<String, dynamic> mandadoMap = {
      "vencimiento":
          DateTime.now().add(Duration(days: 1)).millisecondsSinceEpoch,
    };
    Firestore.instance
        .document("mandadosDesarrollo/${mandado.id}")
        .updateData(mandadoMap)
        .then((r) {
      print("✔️ PLAZO EXTENDIDO");
      Navigator.pop(context);
    }).catchError((e) {
      print("💩 ERROR AL EXTENDER PLAZO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "No pudimos extender el plazo, por favor intenta más tarde.",
      );
    });
  }

  void _deleteMandado() async {
    print("⏳ CANCELARÉ MANDADO");
    Firestore.instance
        .document("mandadosDesarrollo/${mandado.id}")
        .delete()
        .then((r) {
      print("✔️ MANDADO ELIMINADO");

      List<Categoria> categoriasTemp = user.categorias;
      categoriasTemp.forEach((categoria) {
        if (categoria.emoji == mandado.categoria.emoji &&
            categoria.title == mandado.categoria.title) {
          categoria.numMandados--;
        }
      });

      List<Map<String, dynamic>> categoriasMapList = List();

      categoriasTemp.forEach((categoria) {
        categoriasMapList.add({
          "title": categoria.title,
          "emoji": categoria.emoji,
          "numMandados": categoria.numMandados,
          "isHidden": categoria.isHidden,
        });
      });

      Map<String, dynamic> userMap = {
        "categorias": categoriasMapList.reversed.toList(),
      };

      print("⏳ ACTUALIZARÉ USER");
      Firestore.instance
          .document("users/${user.id}")
          .updateData(userMap)
          .then((r) {
        print("✔️ USER ACTUALIZADO");
        setState(() {
          user.categorias = categoriasTemp;
        });
        Navigator.pop(context, "ELIMINADO");
      }).catchError((e) {
        print("💩 ERROR AL ACTUALIZAR USER: $e");
        Navigator.pop(context, "ELIMINADO");
      });
    }).catchError((e) {
      print("💩 ERROR AL ELIMINAR MANDADO: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "No pudimos eliminar tu mandado, por favor intenta más tarde.",
      );
    });
  }

  void pushWithPopAnimation(BuildContext context, Widget widget) {
    Navigator.push(context, SlideRightRoute(page: widget));
  }
}
