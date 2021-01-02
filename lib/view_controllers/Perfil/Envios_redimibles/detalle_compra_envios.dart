import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/functions/launch_whatsapp.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/view_controllers/Perfil/Envios_redimibles/compra_confirmada.dart';
import 'package:manda2/view_controllers/Perfil/tarjetas/mis_tarjetas.dart';
import 'package:manda2/internet_connection.dart';
import 'package:manda2/wompi/wompi_payments.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class DetalleCompra extends StatefulWidget {
  DetalleCompra({
    this.precio,
    this.cantidad,
    this.descuento,
  });

  final int precio;
  final int cantidad;
  final double descuento;

  @override
  _DetalleCompraState createState() {
    return _DetalleCompraState(
      cantidad: cantidad,
      precio: precio,
      descuento: descuento,
    );
  }
}

class _DetalleCompraState extends State<DetalleCompra> {
  _DetalleCompraState({
    this.precio,
    this.cantidad,
    this.descuento,
  });

  int precio;
  int cantidad;
  int numTarjetas;
  double descuento;
  bool isConfirmandoPago = false;
  String cvv = '';

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
  MaskTextInputFormatter cvvFormatter = MaskTextInputFormatter(
    mask: '###',
    filter: {"#": RegExp(r'[0-9]')},
  );
  int cuotas = 12;

  Color buttonBackgroundColor = kGreenManda2Color;
  Color buttonShadowColor = kGreenManda2Color.withOpacity(0.4);

  @override
  void initState() {
    super.initState();
    numTarjetas = user.numTarjetas;
    if (numTarjetas == 0) {
      setState(() {
        buttonBackgroundColor = kBlackColorOpacity;
        buttonShadowColor = kTransparent;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        actionsForegroundColor: kBlackColor,
        backgroundColor: kLightGreyColor,
        border: Border(
          bottom: BorderSide(
            color: kTransparent,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: FittedBox(
          child: Text(
            "Datos de pago",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 17,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            M2AnimatedContainer(
              height: hasConnection ? 0 : 50,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 20),
                  child: Text(
                    "Precio",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: kBlackColor)),
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(
                    cantidad == 1
                        ? "Paquete x$cantidad envío"
                        : "Paquete x$cantidad envíos",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 13,
                      color: kBlackColor.withOpacity(0.5),
                    )),
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 18, top: 17),
                  child: Text(
                    formattedMoneyValue(precio),
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: kGreenManda2Color,
                    )),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                descuento == 0
                    ? Container()
                    : Padding(
                        padding: EdgeInsets.only(top: 17, right: 18),
                        child: Container(
                          height: 23,
                          width: 69,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: kPinkColor),
                              color: kPinkColor),
                          child: Center(
                            child: Text(
                              '${(descuento * 100).round()}% off',
                              style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 12, color: kOrangeColor)),
                            ),
                          ),
                        ),
                      )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 18.0, right: 18, top: 12),
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: kBlackColorOpacity,
              ),
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 18),
                  child: Text(
                    'Métodos de pago',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                user.numTarjetas == 0
                    ? CupertinoButton(
                        onPressed: () async {
                          if (hasConnection) {
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
                                numTarjetas = result as int;
                                if (numTarjetas > 0) {
                                  buttonBackgroundColor = kGreenManda2Color;
                                  buttonShadowColor =
                                      kGreenManda2Color.withOpacity(0.4);
                                } else {
                                  buttonBackgroundColor = kDisabledButtonColor;
                                  buttonShadowColor = kTransparent;
                                }
                              });
                            }
                          } else {
                            showBasicAlert(
                              context,
                              "Sin internet",
                              "Por favor, conéctate a internet para poder efectuar cambios",
                            );
                          }
                        },
                        child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: kTransparent,
                            borderRadius: kRadiusAll,
                            border:
                                Border.all(color: kGreenManda2Color, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              'Agregar',
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: kGreenManda2Color,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(top: 18),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (hasConnection) {
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
                                          numTarjetas = result as int;
                                          if (numTarjetas > 0) {
                                            buttonBackgroundColor =
                                                kGreenManda2Color;
                                            buttonShadowColor =
                                                kGreenManda2Color
                                                    .withOpacity(0.4);
                                          } else {
                                            buttonBackgroundColor =
                                                kDisabledButtonColor;
                                            buttonShadowColor = kTransparent;
                                          }
                                        });
                                      }
                                    } else {
                                      showBasicAlert(
                                        context,
                                        "Sin internet",
                                        "Por favor, conéctate a internet para poder efectuar cambios",
                                      );
                                    }
                                  },
                                  child: getCardTypeIcon(_creditCardType()),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
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
                                      numTarjetas = result as int;
                                      if (numTarjetas > 0) {
                                        buttonBackgroundColor =
                                            kGreenManda2Color;
                                        buttonShadowColor =
                                            kGreenManda2Color.withOpacity(0.4);
                                      } else {
                                        buttonBackgroundColor =
                                            kDisabledButtonColor;
                                        buttonShadowColor = kTransparent;
                                      }
                                    });
                                  }
                                },
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 18.0, top: 18),
                                  child: Text(
                                    "${user.favoriteCreditCard}",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 18, left: 30),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                DropdownButton<String>(
                                  items: cuotasList.map((String value) {
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
                                  icon: Icon(Icons.keyboard_arrow_down),
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
                      )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 18.0, right: 18, top: 5),
              child: Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: kBlackColorOpacity,
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: M2Button(
                title: "Pagar",
                onPressed: () {
                  if (hasConnection) {
                    _handleNavigation();
                  } else {
                    showBasicAlert(
                      context,
                      "Sin internet",
                      "Por favor, conéctate a internet para poder continuar",
                    );
                  }
                },
                isLoading: isConfirmandoPago,
                backgroundColor: buttonBackgroundColor,
                shadowColor: buttonShadowColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNavigation() {
    if (buttonBackgroundColor == kGreenManda2Color) {
      precio = precio.round();
      _generatePago(precio);
    } else {
      if (user.numTarjetas == 0) {
        showAlert(
          context: context,
          title: "Agrega una tarjeta",
          body: "Por favor, agrega una tarjeta antes de comprar el paquete.",
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
                    numTarjetas = result as int;
                    if (numTarjetas > 0) {
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
      } else {
        showBasicAlert(
          context,
          "Sin conexión a internet",
          "Por favor revisa tu conexión a internet e intenta de nuevo",
        );
      }
    }
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

  void _generatePago(int pago) async {
    setState(() {
      isConfirmandoPago = true;
    });

    user.payCount = user.payCount + 1;

    print("⏳ GENERARÉ PAGO");
    paymentStatus = PaymentStatus.PENDING;
    await generarPago(pago, cuotas).then((r) async {
      if (paymentStatus == PaymentStatus.APPROVED) {
        print("✔️ PAGO APROBADO");
        Map<String, dynamic> userMap = {
          "numEnvios": user.numEnvios + cantidad,
        };
        print("⏳ ACTUALIZARÉ USER");
        Firestore.instance
            .document("users/${user.id}")
            .updateData(userMap)
            .then((r) async {
          print("✔️ USER ACTUALIZADO");

          _createTransaccion();

          setState(() {
            user.numEnvios = user.numEnvios + cantidad;
            isConfirmandoPago = false;
          });

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) {
                return Confirmada(
                  precio: pago,
                );
              },
            ),
          );
        }).catchError((e) {
          setState(() {
            isConfirmandoPago = false;
          });
          print("💩️ ERROR AL ACTUALIZAR USER: $e");
          showAlert(
            context: context,
            title: "Comunícate con soporte.",
            body:
                "El pago se descontó de tu tarjeta, pero no pudimos asignarte tus nuevos envíos redimibles. Por favor, comunícate con soporte para que solucionemos el problema.",
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
        });
      } else if (paymentStatus == PaymentStatus.DECLINED) {
        setState(() {
          isConfirmandoPago = false;
        });
        print("⚠️ PAGO RECHAZADO");
        showBasicAlert(
          context,
          "Saldo insuficiente",
          "Por favor, usa otra tarjeta.",
        );
      } else if (paymentStatus == PaymentStatus.ERROR) {
        setState(() {
          isConfirmandoPago = false;
        });
        print("⚠️ ERROR AL GENERAR PAGO");
        showBasicAlert(
          context,
          "Error al generar el pago",
          "Por favor, intenta de nuevo.",
        );
      }
    });
  }

  void _createTransaccion() async {
    Map<String, dynamic> transaccionMap = {
      "concepto": "paquetes",
      "valor": precio,
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
}
