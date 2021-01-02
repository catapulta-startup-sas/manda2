import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_cupertino_data_picker/flutter_cupertino_data_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_divider.dart';
import 'package:manda2/components/m2_metodo_de_pago.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/notifications.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/functions/launch_whatsapp.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/view_controllers/Home/solicitud/q2_formulario_page.dart';
import 'package:manda2/view_controllers/Home/solicitud/q3_set_places_page.dart';
import 'package:manda2/view_controllers/Perfil/Envios_redimibles/redimibles.dart';
import 'package:manda2/view_controllers/Perfil/tarjetas/mis_tarjetas.dart';
import 'package:manda2/view_controllers/Home/solicitud/mandado_solicitado.dart';
import 'package:manda2/wompi/wompi_payments.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SolicitudResumenPage extends StatefulWidget {
  SolicitudResumenPage({
    this.categoria,
    this.tagOrigen,
    this.numDestinos,
    this.mandados,
    this.origen,
  });
  Categoria categoria;
  int numDestinos;
  String tagOrigen;
  Lugar origen;
  List<Mandado> mandados;

  @override
  _SolicitudResumenPageState createState() => _SolicitudResumenPageState(
        categoria: categoria,
        tagOrigen: tagOrigen,
        numDestinos: numDestinos,
        mandados: mandados,
        origen: origen,
      );
}

Mandado mandadoGlobal = Mandado();

class _SolicitudResumenPageState extends State<SolicitudResumenPage> {
  _SolicitudResumenPageState({
    this.categoria,
    this.numDestinos,
    this.tagOrigen,
    this.mandados,
    this.origen,
  });

  Categoria categoria;
  int numDestinos;
  String tagOrigen;

  Lugar origen;

  List<Mandado> mandados;
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

  MaskTextInputFormatter cvvFormatter = MaskTextInputFormatter(
    mask: '###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool isConfirmandoPago = false;
  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;

  PushNotification pushNotification = PushNotification();

  var alertStyle = AlertStyle(
    animationType: AnimationType.fromTop,
    isCloseButton: true,
    isOverlayTapDismiss: false,
    overlayColor: kBlackColor.withOpacity(0.5),
    animationDuration: Duration(milliseconds: 400),
    alertBorder: RoundedRectangleBorder(
      borderRadius: kRadiusAll,
    ),
  );

  @override
  void initState() {
    mandadoGlobal.total = precioIndividual;
    if (user.numEnvios > 0) {
      mandadoGlobal.tipoPago = 'Envíos redimibles';
    } else if (user.numTarjetas > 0) {
      mandadoGlobal.tipoPago = 'Tarjeta de crédito';
    } else {
      mandadoGlobal.tipoPago = 'Efectivo contra entrega';
    }
    super.initState();
  }

  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: CupertinoNavigationBar(
          border: Border.all(color: Color(0x00000000)),
          leading: Container(width: 0),
          middle: FittedBox(
            child: Text(
              "Detalles del mandado",
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
            children: [
              /// Primera columna
              Padding(
                padding: EdgeInsets.fromLTRB(17, 10, 17, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Categoría: ${categoria.emoji} ${categoria.title}',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              color: kBlackColorOpacity,
                              fontWeight: FontWeight.w300)),
                    ),
                    SizedBox(height: 30),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 24,
                          child: Text(
                            'De:',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 15, color: kBlackColor)),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            '${origen.direccion}, ${origen.ciudad}',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                fontSize: 15,
                                color: kBlackColor.withOpacity(0.5),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Q2Formulario(
                                  vieneResumen: true,
                                  origen: origen,
                                  vieneMiDomicilio: tagOrigen == 'Mi domicilio'
                                      ? true
                                      : false,
                                ),
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                origen = result as Lugar;
                              });
                            }
                          },
                          child: Container(
                            height: 25,
                            child: FittedBox(
                              child: Text(
                                'Editar',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kGreenManda2Color,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              /// Segunda columna
              Padding(
                padding: EdgeInsets.fromLTRB(17, 16, 17, 0),
                child: Column(
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 24,
                          child: Text(
                            'A:',
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                    fontSize: 15, color: kBlackColor)),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Text(
                            numDestinos > 1
                                ? '$numDestinos lugares'
                                : '${mandados[0].destino.direccion}, ${mandados[0].destino.ciudad}',
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                  fontSize: 15,
                                  color: kBlackColor.withOpacity(0.5),
                                  fontWeight: FontWeight.w300),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => Q3SetPlaces(
                                  vieneResumen: true,
                                  mandadosFromBuilder: mandados,
                                ),
                              ),
                            );
                            if (result != null) {
                              setState(() {
                                mandados = result as List<Mandado>;
                                numDestinos = mandados.length;
                              });
                            }
                          },
                          child: Container(
                            height: 25,
                            child: FittedBox(
                              child: Text(
                                'Editar',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15,
                                      color: kGreenManda2Color,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              /// Notas
              mandadoGlobal.descripcion == null ||
                      mandadoGlobal.descripcion == ""
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.only(left: 17, bottom: 18),
                      child: Text(
                        'Notas al colaborador',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),

              /// Descripcion de la nota
              mandadoGlobal.descripcion == null ||
                      mandadoGlobal.descripcion == ""
                  ? Container()
                  : Padding(
                      padding: EdgeInsets.fromLTRB(17, 0, 17, 35),
                      child: Text(
                        mandadoGlobal.descripcion == null
                            ? ''
                            : '${mandadoGlobal.descripcion}',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 16,
                            color: kBlackColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),

              /// Linea
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: M2Divider(),
              ),

              /// Tarifa, propina y total
              Column(
                children: <Widget>[
                  /// Tarifa
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 21),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 25,
                          width: 110,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                'Tarifa individual',
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
                            child: FittedBox(
                              child:
                                  mandadoGlobal.tipoPago == 'Envíos redimibles'
                                      ? Text(
                                          'x1 envío',
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: kBlackColorOpacity,
                                              fontWeight: FontWeight.w300),
                                        )
                                      : Text(
                                          formattedMoneyValue(precioIndividual),
                                          style: GoogleFonts.poppins(
                                              fontSize: 15,
                                              color: kBlackColorOpacity,
                                              fontWeight: FontWeight.w300),
                                        ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Total
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          height: 25,
                          width: 110,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                'Total a pagar',
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: kBlackColor,
                                    fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                        ),
                        Expanded(child: Container()),
                        Container(
                          height: 25,
                          width: 110,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              child:
                                  mandadoGlobal.tipoPago == 'Envíos redimibles'
                                      ? Text(
                                          numDestinos == 1
                                              ? "x$numDestinos envío"
                                              : "x$numDestinos envíos",
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: kBlackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )
                                      : Text(
                                          formattedMoneyValue(
                                            (precioIndividual * numDestinos),
                                          ),
                                          style: GoogleFonts.poppins(
                                            fontSize: 15,
                                            color: kBlackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              /// Linea
              Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: M2Divider(),
              ),

              /// Método de pago
              Padding(
                padding: EdgeInsets.fromLTRB(17, 0, 17, 17),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Métodos de pago',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w300)),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                      onTap: () {
                        _showDataPicker();
                      },
                      child: Text(
                        "Cambiar",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 15,
                            color: kGreenManda2Color,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// Lista métodos de pago
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: <Widget>[
                      mandadoGlobal.tipoPago == 'Envíos redimibles'
                          ? TipoPagoContainer(
                              text: 'Envíos redimibles',
                              imageRoute: 'images/checkActivoV.png',
                            )
                          : mandadoGlobal.tipoPago == 'Tarjeta de crédito'
                              ? TipoPagoContainer(
                                  text: 'Tarjeta de crédito',
                                  imageRoute: 'images/checkActivoV.png',
                                )
                              : TipoPagoContainer(
                                  text: 'Efectivo contra entrega',
                                  imageRoute: 'images/checkActivoV.png',
                                ),
                    ],
                  ),
                ),
              ),

              /// Muestra el método de pago
              Container(
                padding: EdgeInsets.only(top: 20),
                child: mandadoGlobal.tipoPago == "Tarjeta de crédito"
                    ? user.numTarjetas == 0
                        ? Container()
                        : Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 17, bottom: 5, top: 5),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Tarjeta',
                                              style: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
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
                                                  color: kBlackColor
                                                      .withOpacity(0.5))),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            child: GestureDetector(
                                              onTap: () async {
                                                final result =
                                                    await Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder: (context) =>
                                                        Tarjetas(
                                                      vieneCheckout: true,
                                                    ),
                                                  ),
                                                );
                                                if (result != null) {
                                                  setState(() {
                                                    user.numTarjetas =
                                                        result as int;
                                                    if (user.numTarjetas > 0) {
                                                      buttonBackgroundColor =
                                                          kGreenManda2Color;
                                                      buttonShadowColor =
                                                          kGreenManda2Color
                                                              .withOpacity(0.4);
                                                    } else {
                                                      buttonBackgroundColor =
                                                          kDisabledButtonColor;
                                                      buttonShadowColor =
                                                          kTransparent;
                                                    }
                                                  });
                                                }
                                              },
                                              child: getCardTypeIcon(
                                                  _creditCardType()),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () async {
                                              final result =
                                                  await Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                  builder: (context) =>
                                                      Tarjetas(
                                                    vieneCheckout: true,
                                                  ),
                                                ),
                                              );
                                              if (result != null) {
                                                setState(() {
                                                  user.numTarjetas =
                                                      result as int;
                                                  if (user.numTarjetas > 0) {
                                                    buttonBackgroundColor =
                                                        kGreenManda2Color;
                                                    buttonShadowColor =
                                                        kGreenManda2Color
                                                            .withOpacity(0.4);
                                                  } else {
                                                    buttonBackgroundColor =
                                                        kDisabledButtonColor;
                                                    buttonShadowColor =
                                                        kTransparent;
                                                  }
                                                });
                                              }
                                            },
                                            child: Padding(
                                              padding:
                                                  EdgeInsets.only(right: 17),
                                              child: Text(
                                                "${user.favoriteCreditCard}",
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 17),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            DropdownButton<String>(
                                              items: cuotasList
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              onChanged: (text) {
                                                setState(() {
                                                  cuotas = int.parse(text);
                                                });
                                              },
                                              value: "$cuotas",
                                              icon: Icon(
                                                  Icons.keyboard_arrow_down),
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: kBlackColor,
                                              ),
                                              iconSize: 18,
                                              underline: Container(),
                                              isDense: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          )
                    : mandadoGlobal.tipoPago == 'Envíos redimibles'
                        ? user.numEnvios == 0
                            ? Container()
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 5),
                                    width:
                                        MediaQuery.of(context).size.width - 34,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: FittedBox(
                                                child: Text(
                                                  'Envíos redimibles',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              child: FittedBox(
                                                child: Text(
                                                  'Tienes',
                                                  style: GoogleFonts.poppins(
                                                      textStyle: TextStyle(
                                                          fontSize: 13,
                                                          color: kBlackColor
                                                              .withOpacity(
                                                                  0.5))),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(),
                                            ),
                                            Text(
                                              '${user.numEnvios} envíos',
                                              style: GoogleFonts.poppins(
                                                  textStyle:
                                                      TextStyle(fontSize: 13)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              )
                        : Container(),
              ),

              SizedBox(height: 20),
              Expanded(child: Container()),

              ///Comentario de propina
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 17),
                child: Text(
                  'Puedes entregar una propina\nvoluntaria a cada colaborador.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontSize: 13,
                      color: kBlackColorOpacity,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),

              /// Boton
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 48),
                child: M2Button(
                  isLoading: isConfirmandoPago,
                  title: mandadoGlobal.tipoPago == "Efectivo contra entrega"
                      ? 'Solicitar'
                      : mandadoGlobal.tipoPago == "Envíos redimibles"
                          ? numDestinos > 1
                              ? "Redimir envíos"
                              : "Redimir envío"
                          : "Pagar ahora",
                  width: MediaQuery.of(context).size.width - 34,
                  backgroundColor:
                      (mandadoGlobal.tipoPago == 'Tarjeta de crédito' &&
                              user.numTarjetas == 0)
                          ? kBlackColorOpacity
                          : mandadoGlobal.tipoPago == 'Envíos redimibles' &&
                                  (user.numEnvios == 0 ||
                                      user.numEnvios < numDestinos)
                              ? kBlackColorOpacity
                              : kGreenManda2Color,
                  shadowColor:
                      (mandadoGlobal.tipoPago == 'Tarjeta de crédito' &&
                              user.numTarjetas == 0)
                          ? kTransparent
                          : mandadoGlobal.tipoPago == 'Envíos redimibles' &&
                                  (user.numEnvios == 0 ||
                                      user.numEnvios < numDestinos)
                              ? kTransparent
                              : kGreenManda2Color.withOpacity(0.4),
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    if (mandadoGlobal.tipoPago == 'Tarjeta de crédito' &&
                        user.numTarjetas == 0) {
                      _showAlertTarjeta();
                    } else {
                      if (mandadoGlobal.tipoPago == 'Envíos redimibles' &&
                          (user.numEnvios == 0 ||
                              user.numEnvios < numDestinos)) {
                        _showAlertEnvios();
                      } else {
                        print("PUBLICARÉ ${mandados.length} MANDADOS");
                        _handleMandadosCreation();
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDataPicker() {
    final bool showTitleActions = true;
    DataPicker.showDatePicker(
      context,
      locale: null,
      showTitleActions: showTitleActions,
      datas: [
        'Envíos redimibles',
        'Tarjeta de crédito',
        'Efectivo contra entrega'
      ],
      onChanged: (data) {},
      onConfirm: (data) {
        setState(() {
          mandadoGlobal.tipoPago = data;
        });
      },
    );
  }

  void _showAlertTarjeta() {
    showAlert(
      context: context,
      title: "Agrega una tarjeta",
      body: "Por favor, agrega una tarjeta antes de pagar el mandado.",
      actions: [
        AlertAction(
          text: "Volver",
        ),
        AlertAction(
          text: "Agregar",
          isDefaultAction: true,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Tarjetas(
                  vieneCheckout: true,
                ),
              ),
            );
            if (result != null) {
              setState(() {
                user.numTarjetas = result as int;
                if (user.numTarjetas > 0) {
                  buttonBackgroundColor = kGreenManda2Color;
                  buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                } else {
                  buttonBackgroundColor = kDisabledButtonColor;
                  buttonShadowColor = kTransparent;
                }
              });
            }
          },
        ),
      ],
    );
  }

  void _showAlertEnvios() {
    showAlert(
      context: context,
      title: numDestinos - user.numEnvios == 1
          ? "Te falta 1 envío redimible"
          : "Te faltan ${numDestinos - user.numEnvios} envíos redimibles",
      body:
          "Adquiere envíos redimibles antes de solicitar ${numDestinos == 1 ? "tu mandado." : "tus mandados."}",
      actions: [
        AlertAction(
          text: "Volver",
        ),
        AlertAction(
          text: "Adquirir",
          isDefaultAction: true,
          onPressed: () async {
            final result = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => Redimibles(),
              ),
            );
            if (result != null) {
              setState(() {
                user.numEnvios = result as int;
              });
            }
          },
        ),
      ],
    );
  }

  void _handleMandadosCreation() {
    setState(() {
      isConfirmandoPago = true;
    });
    if (mandadoGlobal.tipoPago == "Envíos redimibles") {
      if (user.numEnvios >= mandados.length) {
        _postMandado();
      } else {
        _showAlertEnvios();
      }
    } else if (mandadoGlobal.tipoPago == "Efectivo contra entrega") {
      _postMandado();
    } else if (mandadoGlobal.tipoPago == "Tarjeta de crédito") {
      _pagoTKMandado();
    }
  }

  void _pagoTKMandado() async {
    await generarPago(precioIndividual * mandados.length, cuotas)
        .then((r) async {
      if (paymentStatus == PaymentStatus.APPROVED) {
        await _postMandado().then((r) => _createTransaccion());
      } else if (paymentStatus == PaymentStatus.DECLINED) {
        setState(() {
          isConfirmandoPago = false;
        });
        showBasicAlert(
          context,
          "Saldo insuficiente",
          "Por favor, usa otra tarjeta.",
        );
      } else if (paymentStatus == PaymentStatus.ERROR) {
        setState(() {
          isConfirmandoPago = false;
        });
        showBasicAlert(
          context,
          "Error al generar el pago",
          "Por favor, intenta más tarde.",
        );
      }
    });
  }

  void _createTransaccion() async {
    Map<String, dynamic> transaccionMap = {
      "concepto": "tarjeta",
      "valor": precioIndividual * mandados.length,
      "userId": user.id,
      "created": DateTime.now().millisecondsSinceEpoch,
    };
    print("⏳ GUARDARÉ TRANSACCIÓN");
    Firestore.instance
        .collection("transacciones")
        .add(transaccionMap)
        .then((r) {
      print("✔️ TRANSACCIÓN GUARDADA");
    }).catchError((e) {
      print("💩 ERROR AL GUARDAR TRANSACCIÓN: $e");
    });
  }

  Future<bool> _postMandado() async {
    Firestore db = Firestore.instance;
    WriteBatch batch = db.batch();

    mandados.forEach((mandadoForEach) {
      String documentId =
          "${UniqueKey()}${UniqueKey()}${UniqueKey()}${UniqueKey()}${UniqueKey()}"
              .replaceAll("#", "")
              .replaceAll("[", "")
              .replaceAll("]", "");

      Map<String, dynamic> mandadoMap = {
        "identificador": mandadoForEach.identificador,
        "categoria": {
          "emoji": categoria.emoji,
          "title": categoria.title,
        },
        "puntoA": {
          "calle": origen.direccion == "" ? null : origen.direccion,
          "edificio": origen.edificio == "" ? null : origen.edificio,
          "apto": origen.apto == "" ? null : origen.apto,
          "barrio": origen.barrio == "" ? null : origen.barrio,
          "ciudad": origen.ciudad == "" ? null : origen.ciudad,
          "notas": origen.notas == "" ? null : origen.notas,
          "contacto": origen.contactoName ?? user.name,
          "phoneNumber": origen.contactoPhoneNumber ?? user.phoneNumber,
        },
        "puntoB": {
          "calle": mandadoForEach.destino.direccion == ""
              ? null
              : mandadoForEach.destino.direccion,
          "edificio": mandadoForEach.destino.edificio == ""
              ? null
              : mandadoForEach.destino.edificio,
          "apto": mandadoForEach.destino.apto == ""
              ? null
              : mandadoForEach.destino.apto,
          "barrio": mandadoForEach.destino.barrio == ""
              ? null
              : mandadoForEach.destino.barrio,
          "ciudad": mandadoForEach.destino.ciudad == ""
              ? null
              : mandadoForEach.destino.ciudad,
          "notas": mandadoForEach.destino.notas == ""
              ? null
              : mandadoForEach.destino.notas,
          "contacto": mandadoForEach.destino.contactoName ?? user.name,
          "phoneNumber":
              mandadoForEach.destino.contactoPhoneNumber ?? user.phoneNumber,
        },
        "pago": {
          "tipoPago": mandadoGlobal.tipoPago,
          "total": 10000,
          "cardType": mandadoGlobal.tipoPago == "Tarjeta de crédito"
              ? user.userTks["creditCard${_favoriteCreditCardSerial()}"]
                  ["paymentMethod"]
              : null,
          "cuotas":
              mandadoGlobal.tipoPago == "Tarjeta de crédito" ? cuotas : null,
          "lastFourDigits": mandadoGlobal.tipoPago == "Tarjeta de crédito"
              ? user.userTks["creditCard${_favoriteCreditCardSerial()}"]
                  ["lastFourDigits"]
              : null,
        },
        "estados": {
          "isTomado": false,
          "isRecogido": false,
          "isEntregado": false,
          "isCalificado": false,
          "dates": {
            "tomado": null,
            "recogido": null,
            "entregado": null,
          },
        },
        "created": DateTime.now().millisecondsSinceEpoch,
        "vencimiento": mandadoForEach.fechaMaxEntrega.millisecondsSinceEpoch,
        "clienteId": user.id,
        "domiciliarioId": null,
        "descripcion": mandadoForEach.descripcion,
      };

      batch.setData(db.document("mandadosDesarrollo/$documentId"), mandadoMap);
    });

    print("⏳ PUBLICARÉ BATCH MANDADO");
    batch.commit().then((r) async {
      print("✔️ BATCH PUBLICADO");

      // Notificación a Colaboradores
      pushNotification.sendMandadoDisponibleNotification(numDestinos);

      if (mandadoGlobal.tipoPago == "Envíos redimibles") {
        List<Categoria> categoriasTemp = user.categorias;
        for (int i = 0; i < categoriasTemp.length; i++) {
          if (categoriasTemp[i].emoji == categoria.emoji &&
              categoriasTemp[i].title == categoria.title) {
            categoriasTemp[i].numMandados =
                categoriasTemp[i].numMandados + mandados.length;
          }
        }
        List<Map<String, dynamic>> categoriasMap = List();
        categoriasTemp.forEach((categoria) {
          categoriasMap.add({
            "emoji": categoria.emoji,
            "title": categoria.title,
            "numMandados": categoria.numMandados,
            "isHidden": categoria.isHidden,
          });
        });
        Map<String, dynamic> userMap = {
          "categorias": categoriasMap.reversed.toList(),
          "numEnvios": user.numEnvios - mandados.length,
        };

        print("⏳ ACTUALIZARÉ USER");
        Firestore.instance
            .document("users/${user.id}")
            .updateData(userMap)
            .then((r) async {
          print("✔️ USER ACTUALIZADO");
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Publicado(numDestinos: mandados.length),
            ),
          );
          setState(() {
            user.numEnvios = user.numEnvios - mandados.length;
            user.categorias = categoriasTemp;
            isConfirmandoPago = false;
          });
        }).catchError((e) {
          print("💩 ERROR AL ACTUALIZAR USER: $e");
          setState(() {
            isConfirmandoPago = false;
          });
          showBasicAlert(
            context,
            "Hubo un error.",
            "Por favor, intenta más tarde.",
          );
        });
      } else {
        List<Categoria> categoriasTemp = user.categorias;
        for (int i = 0; i < categoriasTemp.length; i++) {
          if (categoriasTemp[i].emoji == categoria.emoji &&
              categoriasTemp[i].title == categoria.title) {
            categoriasTemp[i].numMandados =
                categoriasTemp[i].numMandados + mandados.length;
          }
        }
        List<Map<String, dynamic>> categoriasMap = List();
        categoriasTemp.forEach((categoria) {
          categoriasMap.add({
            "emoji": categoria.emoji,
            "title": categoria.title,
            "numMandados": categoria.numMandados,
            "isHidden": categoria.isHidden,
          });
        });
        Map<String, dynamic> userMap = {
          "categorias": categoriasMap.reversed.toList(),
        };

        print("⏳ ACTUALIZARÉ USER");
        Firestore.instance
            .document("users/${user.id}")
            .updateData(userMap)
            .then((r) async {
          print("✔️ USER ACTUALIZADO");
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => Publicado(numDestinos: mandados.length),
            ),
          );
          setState(() {
            user.categorias = categoriasTemp;
            isConfirmandoPago = false;
          });
        }).catchError((e) {
          print("💩 ERROR AL ACTUALIZAR USER: $e");
          setState(() {
            isConfirmandoPago = false;
          });
          showBasicAlert(
            context,
            "Hubo un error.",
            "Por favor, intenta más tarde.",
          );
        });
      }
    }).catchError((e) {
      print("💩 ERROR AL CREAR MANDADO: $e");
      if (mandadoGlobal.tipoPago == "Tarjeta de crédito") {
        setState(() {
          isConfirmandoPago = false;
        });
        showAlert(
          context: context,
          title: "Comunícate con soporte.",
          body:
              "El pago se descontó de tu tarjeta, pero el mandado no pudo publicarse. Por favor, comunícate con soporte para que solucionemos el problema.",
          actions: [
            AlertAction(
              text: "Volver",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            AlertAction(
              text: "Chat de soporte",
              isDefaultAction: true,
              onPressed: () {
                launchWhatsApp(context, contactoSoporte);
              },
            ),
          ],
        );
      } else {
        setState(() {
          isConfirmandoPago = false;
        });
        showBasicAlert(
          context,
          "Error al crear el mandado",
          "Por favor, intente más tarde.",
        );
      }
    });
  }

  String _favoriteCreditCardSerial() {
    if (user.favoriteCreditCard ==
        user.userTks["creditCardA"]["lastFourDigits"]) {
      return "A";
    } else if (user.favoriteCreditCard ==
        user.userTks["creditCardB"]["lastFourDigits"]) {
      return "B";
    } else if (user.favoriteCreditCard ==
        user.userTks["creditCardC"]["lastFourDigits"]) {
      return "C";
    } else {
      return "";
    }
  }

  CardType _creditCardType() {
    String ccx = _favoriteCreditCardSerial();

    switch (user.userTks["creditCard$ccx"]["paymentMethod"]) {
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
}
