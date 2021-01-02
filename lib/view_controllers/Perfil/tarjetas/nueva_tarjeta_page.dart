import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'dart:core';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_text_field_agregar_tarjeta.dart';
import 'package:manda2/components/parki_scroll_view.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/functions/slide_right_route.dart';
import 'package:manda2/model/tarjeta_model.dart';
import 'package:manda2/wompi/wompi_register_card.dart';
import 'package:manda2/view_controllers/Perfil/tarjetas/mis_tarjetas.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import '../../../constants.dart';

class NuevaTarjeta extends StatefulWidget {
  @override
  _NuevaTarjetaState createState() => _NuevaTarjetaState();
}

class _NuevaTarjetaState extends State<NuevaTarjeta> {
  String cardNumber;
  String expiryDate = "";
  String expiryDate2;
  String cvvCode;
  String cardHolderName;
  String cardHolderDoc;
  bool showBackView = false;
  String year;

  bool isRegisteringCard = false;
  final now = DateTime.now();
  int mesActual;

  int yearIngresado;
  int mesIngresado;
  int yearActual;

  bool hasCardNumber = false;
  bool hasExpiryDate = false;
  bool hasCvvCode = false;
  bool hasCardHolderName = false;
  bool hasCardHolderDoc = false;

  Color buttonBackgroundColor = kBlackColorOpacity;
  Color buttonShadowColor = kTransparent;
  Color creditCardColor = kDisabledButtonColor;

  Color cardColor = kBlackColor;
  Color dateIconColor = kBlackColor;
  Color codeIconColor = kBlackColor;
  Color nameIconColor = kBlackColor;
  Color idIconColor = kBlackColor;

  CardType paymentMethod = CardType.mastercard;

  MaskTextInputFormatter tkFormatter = MaskTextInputFormatter(
    mask: '#### #### #### ####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  MaskTextInputFormatter expiryDateFormatter = MaskTextInputFormatter(
    mask: '##/##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  MaskTextInputFormatter cvvFormatter = MaskTextInputFormatter(
    mask: '###',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: kLightGreyColor,
        actionsForegroundColor: kBlackColor,
        border: Border(
          bottom: BorderSide(
            color: kTransparent,
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: Container(
          child: Text(
            "Agregar tarjeta",
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
      body: ParkiScrollView(
        child: Column(
          children: <Widget>[
            ///Titulo
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.058, top: 25),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.032,
                    width: 160,
                    child: Text(
                      'Datos de la tarjeta',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor)),
                    ),
                  ),
                ),
              ],
            ),

            ///Subtitulo
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.058,
                      bottom: 40),
                  child: Container(
                    height: 20,
                    width: 230,
                    child: Text(
                      'Completa cada uno de los campos',
                      textAlign: TextAlign.start,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                        color: kBlackColor.withOpacity(0.5),
                      )),
                    ),
                  ),
                ),
              ],
            ),

            ///Num tarjeta
            M2TextFielIdAgregarTarjeta(
              title: "Número de tarjeta",
              text: "0000 0000 0000 0000",
              inputFormatters: [tkFormatter],
              imageRoute: "images/misTarjetas.png",
              keyboardType: TextInputType.number,
              iconColor: cardColor,
              onChanged: (text) {
                setState(() {
                  cardNumber = text;
                  if (cardNumber.length == 19) {
                    cardColor = kGreenManda2Color;
                  } else if (cardNumber == '') {
                    cardColor = kBlackColor;
                  } else {
                    cardColor = kRedActive;
                  }
                  if (cardNumber != "" &&
                      cardNumber != null &&
                      expiryDate != "" &&
                      expiryDate != null &&
                      cvvCode != "" &&
                      cvvCode != null &&
                      cardHolderName != "" &&
                      cardHolderName != null &&
                      cardHolderDoc != "" &&
                      cardHolderDoc != null) {
                    buttonBackgroundColor = kGreenManda2Color;
                    buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
                  } else {
                    buttonBackgroundColor = kBlackColorOpacity;
                    buttonShadowColor = kTransparent;
                  }
                });
              },
              onTap: () {
                showBackView = false;
              },
            ),

            ///Fecha
            M2TextFielIdAgregarTarjeta(
              title: "Fecha de expiración",
              text: "MM/YY",
              inputFormatters: [expiryDateFormatter],
              imageRoute: "images/fechaExp.png",
              keyboardType: TextInputType.number,
              iconColor: dateIconColor,
              onChanged: (text) {
                setState(() {
                  expiryDate = text;
                  year = DateFormat('yy').format(now);
                  yearActual = int.parse(year);
                  mesActual = DateTime.now().month;

                  if (expiryDate.length == 5) {
                    dateIconColor = kGreenManda2Color;
                    yearIngresado = int.parse(expiryDate.substring(3, 5));
                    mesIngresado = int.parse(expiryDate.substring(0, 2));
                  } else {
                    dateIconColor = kRedActive;
                  }
                  if ((yearIngresado <= yearActual) &&
                      (mesIngresado <= mesActual)) {
                    dateIconColor = kRedActive;
                  } else if (mesIngresado > 12 || yearIngresado < yearActual) {
                    dateIconColor = kRedActive;
                  }
                  if (expiryDate.length == 0) {
                    dateIconColor = kBlackColor;
                  }
                });
              },
              onTap: () {
                showBackView = false;
              },
            ),

            ///CVV
            M2TextFielIdAgregarTarjeta(
              title: "Código de seguridad",
              text: "123",
              inputFormatters: [cvvFormatter],
              imageRoute: "images/password.png",
              keyboardType: TextInputType.number,
              iconColor: codeIconColor,
              onChanged: (text) {
                setState(() {
                  cvvCode = text;
                  if (cvvCode.length == 3) {
                    codeIconColor = kGreenManda2Color;
                  } else if (cvvCode == '') {
                    codeIconColor = kBlackColor;
                  } else {
                    codeIconColor = kRedActive;
                  }
                });
              },
              onTap: () {
                showBackView = true;
              },
            ),

            ///Titular
            M2TextFielIdAgregarTarjeta(
              title: "Titular de la tarjeta",
              text: user.name ?? "Bruce Wayne",
              imageRoute: "images/user.png",
              textCapitalization: TextCapitalization.words,
              iconColor: nameIconColor,
              onChanged: (text) {
                setState(() {
                  cardHolderName = text;
                  if (cardHolderName == '') {
                    nameIconColor = kBlackColor;
                  } else {
                    nameIconColor = kGreenManda2Color;
                  }
                });
              },
              onTap: () {
                showBackView = false;
              },
            ),

            ///Id
            M2TextFielIdAgregarTarjeta(
              title: "Identificación del titular",
              text: "1234567890",
              imageRoute: "images/noId.png",
              textCapitalization: TextCapitalization.words,
              iconColor: idIconColor,
              onChanged: (text) {
                setState(() {
                  cardHolderDoc = text;
                  if (cardHolderDoc == '') {
                    idIconColor = kBlackColor;
                  } else {
                    idIconColor = kGreenManda2Color;
                  }
                });
              },
              onTap: () {
                showBackView = false;
              },
            ),
            Expanded(child: Container()),
            // TODO [Santiago Gallo]: NO ELIMINAR ESTO
            /*
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 17,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      'Por seguridad, se realizará un cobro de',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                              fontSize: 12,
                              color: kBlackColor.withOpacity(0.56))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 17,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Text(
                        '${formattedMoneyValue(1000)} para validar tu tarjeta de crédito.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 12,
                                color: kBlackColor.withOpacity(0.56))),
                      ),
                    ),
                  )
                ],
              ),
            ),
            */
            Padding(
              padding: EdgeInsets.only(
                bottom: 28,
              ),
              child: M2Button(
                title: "Agregar",
                isLoading: isRegisteringCard,
                onPressed: () {
                  if (cardNumber == null || cardNumber == "") {
                    //Alerta tarjeta
                    showBasicAlert(context,
                        "Por favor, ingresa el número de tu tarjeta.", "");
                  } else {
                    if (expiryDate == null || expiryDate == "") {
                      //Alerta password
                      showBasicAlert(context,
                          "Por favor, ingresa la fecha de expiración.", "");
                    } else if (cvvCode == null || cvvCode == "") {
                      //Alerta email
                      showBasicAlert(context, "Por favor, ingresa el CVV.", "");
                    } else if (cardHolderName == null || cardHolderName == "") {
                      //Alerta email
                      showBasicAlert(context,
                          "Por favor, ingresa el nombre del titular.", "");
                    } else if (cardHolderDoc == null || cardHolderDoc == "") {
                      //Alerta email
                      showBasicAlert(
                          context,
                          "Por favor, ingresa la identificación del titular.",
                          "");
                    } else {
                      _handlesNavigation();
                    }
                  }
                },
                backgroundColor: cardColor == kGreenManda2Color &&
                        dateIconColor == kGreenManda2Color &&
                        codeIconColor == kGreenManda2Color &&
                        nameIconColor == kGreenManda2Color &&
                        idIconColor == kGreenManda2Color
                    ? buttonBackgroundColor = kGreenManda2Color
                    : buttonShadowColor = kBlackColorOpacity,
                shadowColor: cardColor == kGreenManda2Color &&
                        dateIconColor == kGreenManda2Color &&
                        codeIconColor == kGreenManda2Color &&
                        nameIconColor == kGreenManda2Color &&
                        idIconColor == kGreenManda2Color
                    ? buttonShadowColor = kGreenManda2Color.withOpacity(0.4)
                    : buttonShadowColor = kTransparent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// IDENTIFICADOR DE TARJETAS

  /// Credit Card prefix patterns as of March 2019
  /// A [List<String>] represents a range.
  /// i.e. ['51', '55'] represents the range of cards starting with '51' to those starting with '55'
  Map<CardType, Set<List<String>>> cardNumPatterns =
      <CardType, Set<List<String>>>{
    CardType.visa: <List<String>>{
      <String>['4'],
    },
    CardType.americanExpress: <List<String>>{
      <String>['34'],
      <String>['37'],
    },
    CardType.discover: <List<String>>{
      <String>['6011'],
      <String>['622126', '622925'],
      <String>['644', '649'],
      <String>['65']
    },
    CardType.mastercard: <List<String>>{
      <String>['51', '55'],
      <String>['2221', '2229'],
      <String>['223', '229'],
      <String>['23', '26'],
      <String>['270', '271'],
      <String>['2720'],
    },
  };

  /// This function determines the Credit Card type based on the cardPatterns
  /// and returns it.
  CardType detectCCType(String cardNumber) {
    //Default card type is other
    CardType cardType = CardType.otherBrand;
    if (cardNumber.isEmpty) {
      return cardType;
    }
    cardNumPatterns.forEach(
      (CardType type, Set<List<String>> patterns) {
        for (List<String> patternRange in patterns) {
          // Remove any spaces
          String ccPatternStr =
              cardNumber.replaceAll(RegExp(r'\s+\b|\b\s'), '');
          final int rangeLen = patternRange[0].length;
          // Trim the Credit Card number string to match the pattern prefix length
          if (rangeLen < cardNumber.length) {
            ccPatternStr = ccPatternStr.substring(0, rangeLen);
          }
          if (patternRange.length > 1) {
            // Convert the prefix range into numbers then make sure the
            // Credit Card num is in the pattern range.
            // Because Strings don't have '>=' type operators
            final int ccPrefixAsInt = int.parse(ccPatternStr);
            final int startPatternPrefixAsInt = int.parse(patternRange[0]);
            final int endPatternPrefixAsInt = int.parse(patternRange[1]);
            if (ccPrefixAsInt >= startPatternPrefixAsInt &&
                ccPrefixAsInt <= endPatternPrefixAsInt) {
              // Found a match
              cardType = type;
              break;
            }
          } else {
            // Just compare the single pattern prefix with the Credit Card prefix
            if (ccPatternStr == patternRange[0]) {
              // Found a match
              cardType = type;
              break;
            }
          }
        }
      },
    );

    return cardType;
  }

  String getCardTypeString(String cardNumber) {
    switch (detectCCType(cardNumber)) {
      case CardType.visa:
        setState(() {
          creditCardColor = Color(0xFF2d5dc8);
        });
        return "VISA";
        break;

      case CardType.americanExpress:
        setState(() {
          creditCardColor = Color(0xFF385698);
        });
        return "AMEX";
        break;

      case CardType.mastercard:
        setState(() {
          creditCardColor = Color(0xFF273147);
        });
        return "MASTERCARD";
        break;

      case CardType.discover:
        setState(() {
          creditCardColor = Color(0xFF5f5f5f);
        });
        return "DISCOVER";
        break;

      default:
        setState(() {
          creditCardColor = kDisabledButtonColor;
        });
        return "X";
        break;
    }
  }

  void _handlesNavigation() async {
    if (buttonBackgroundColor == kGreenManda2Color) {
      setState(() {
        isRegisteringCard = true;
      });

      String paymentMethod = getCardTypeString(cardNumber.replaceAll(" ", ""));

      if (paymentMethod != "X") {
        String number = cardNumber.replaceAll(" ", "");
        String expMonth = expiryDate.substring(0, 2);
        String expYear = expiryDate.substring(3);

        print("⏳ REGISTRARÉ TARJETA");

        registrarTarjeta(
          number,
          cvvCode,
          expMonth,
          expYear,
          cardHolderName,
        ).then((cardToken) async {
          if (cardToken != null) {
            print("✔️ TARJETA REGISTRADA");

            String lastFourDigits = paymentMethod == "AMEX"
                ? cardNumber.replaceAll(" ", "").substring(11)
                : cardNumber.replaceAll(" ", "").substring(12);
            int newNumTarjetas = user.numTarjetas + 1;

            CardType tipo = CardType.otherBrand;
            switch (paymentMethod) {
              case "AMEX":
                tipo = CardType.americanExpress;
                break;
              case "DISCOVER":
                tipo = CardType.discover;
                break;
              case "MASTERCARD":
                tipo = CardType.mastercard;
                break;
              case "VISA":
                tipo = CardType.visa;
                break;
              default:
                tipo = CardType.otherBrand;
                break;
            }

            //Actualiza datos del usuario

            Map cardMap = {
              "lastFourDigits": lastFourDigits,
              "token": cardToken,
              "expiryDate": expiryDate,
              "paymentMethod": paymentMethod,
              "dniNumber": cardHolderDoc,
            };

            Map creditCards = {};
            if (user.userTks['creditCardA'] == null) {
              creditCards = {
                "creditCardA": cardMap,
                "creditCardB": user.userTks['creditCardB'],
                "creditCardC": user.userTks['creditCardC'],
              };
              setState(() {
                user.userTks['creditCardA'] = {
                  "lastFourDigits": lastFourDigits,
                  "token": cardToken,
                  "expiryDate": expiryDate,
                  "paymentMethod": paymentMethod,
                };
              });
            } else if (user.userTks['creditCardB'] == null) {
              creditCards = {
                "creditCardA": user.userTks['creditCardA'],
                "creditCardB": cardMap,
                "creditCardC": user.userTks['creditCardC'],
              };
              setState(() {
                user.userTks['creditCardB'] = {
                  "lastFourDigits": lastFourDigits,
                  "token": cardToken,
                  "expiryDate": expiryDate,
                  "paymentMethod": paymentMethod,
                };
              });
            } else if (user.userTks['creditCardC'] == null) {
              creditCards = {
                "creditCardA": user.userTks['creditCardA'],
                "creditCardB": user.userTks['creditCardB'],
                "creditCardC": cardMap,
              };
              setState(() {
                user.userTks['creditCardC'] = {
                  "lastFourDigits": lastFourDigits,
                  "token": cardToken,
                  "expiryDate": expiryDate,
                  "paymentMethod": paymentMethod,
                };
              });
            }

            Map<String, dynamic> userMap = {
              "numTarjetas": newNumTarjetas,
              "favoriteCreditCard": lastFourDigits,
              "creditCards": creditCards,
            };

            print("⏳ ACTUALIZARÉ USER");
            //Sube datos actualizados del usuario
            Firestore.instance
                .document("users/${user.id}")
                .updateData(userMap)
                .then((r) {
              print("✔️ USER ACTUALIZADO");
              //NAVEGA
              setState(() {
                isRegisteringCard = false;
                user.numTarjetas = newNumTarjetas;
                user.favoriteCreditCard = lastFourDigits;

                misTarjetas.forEach((tarjeta) {
                  tarjeta.isFavorite = false;
                });

                misTarjetas.add(
                  Tarjeta(
                    cardNumber: lastFourDigits,
                    type: tipo,
                    expiryDate: expiryDate,
                    isFavorite: true,
                  ),
                );
              });

              Navigator.pop(context, misTarjetas);
            }).catchError((e) {
              print("💩 ERROR AL ACTUALIZAR USER: $e");
            });
          } else {
            showBasicAlert(
              context,
              "Error al registrar tarjeta.",
              "Por favor, verifica los datos de tu tarjeta e intenta de nuevo.",
            );
            setState(() {
              isRegisteringCard = false;
            });
          }
        });
      } else {
        showBasicAlert(
          context,
          "Tarjeta no identificada.",
          "Sólo podemos procesar tarjetas Visa, Mastercard, Discover y AmericanExpress. Por favor, registra otra tarjeta.",
        );
        setState(() {
          isRegisteringCard = false;
        });
      }
    } else {
      showBasicAlert(
        context,
        "Faltan campos.",
        "Por favor, completa todos los campos para añadir tu tarjeta.",
      );
    }
  }
}
