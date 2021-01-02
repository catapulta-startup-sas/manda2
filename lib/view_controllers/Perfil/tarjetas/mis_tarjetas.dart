import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/view_controllers/Perfil/tarjetas/nueva_tarjeta_page.dart';
import 'package:shimmer/shimmer.dart';
import 'package:manda2/components/m2_aunno.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/tarjeta_model.dart';
import 'package:manda2/internet_connection.dart';
import 'package:provider/provider.dart';

List<Tarjeta> misTarjetas = [];

class Tarjetas extends StatefulWidget {
  Tarjetas({
    this.vieneCheckout = false,
  });
  bool vieneCheckout;

  @override
  _TarjetasState createState() {
    return _TarjetasState(
      vieneCheckout: vieneCheckout,
    );
  }
}

class _TarjetasState extends State<Tarjetas> {
  _TarjetasState({this.vieneCheckout = false});
  final bool vieneCheckout;
  bool isEditing = false;
  bool hasConnection = true;
  String listoLbl = "Listo";
  bool seleccionado;

  bool isLoadingCards = true;

  Color buttonBackgroundColor = kGreenManda2Color;
  Color buttonShadowColor = kGreenManda2Color.withOpacity(0.4);

  @override
  void initState() {
    super.initState();
    misTarjetas.clear();
    _getTarjetas();
  }

  @override
  Widget build(BuildContext context) {
    hasConnection = Provider.of<InternetStatus>(context).connected;
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
            "Mis tarjetas",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        trailing: vieneCheckout
            ? GestureDetector(
                onTap: () {
                  Navigator.pop(context, user.numTarjetas);
                },
                child: Text(
                  "Listo",
                  style: TextStyle(color: kGreenManda2Color),
                ),
              )
            : Container(width: 0),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            M2AnimatedContainer(
              height: hasConnection ? 0 : 50,
            ),
            user.numTarjetas == 0
                ? Expanded(child: _aunNoLayout())
                : isLoadingCards
                    ? Expanded(child: _loadingLayout())
                    : Expanded(child: _loadedLayout()),
          ],
        ),
      ),
    );
  }

  ///SKELETON
  Widget _loadingLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return Container(
                margin: EdgeInsets.fromLTRB(8, 16, 8, 0),
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 67,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: kShadowGreyColor,
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Shimmer.fromColors(
                      baseColor: kBlackColor.withOpacity(0.5),
                      highlightColor: kBlackColor.withOpacity(0.2),
                      child: Container(
                        width: 48,
                        height: 38,
                        decoration: BoxDecoration(
                          color: kBlackColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: kBlackColor.withOpacity(0.5),
                          highlightColor: kBlackColor.withOpacity(0.2),
                          child: Container(
                            height: 15,
                            width: 48,
                            decoration: BoxDecoration(
                              color: kBlackColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Shimmer.fromColors(
                          baseColor: kBlackColor.withOpacity(0.5),
                          highlightColor: kBlackColor.withOpacity(0.2),
                          child: Container(
                            height: 15,
                            width: 38,
                            decoration: BoxDecoration(
                              color: kBlackColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                  ],
                ),
              );
            },
            itemCount: user.numTarjetas,
          ),
        ),
      ],
    );
  }

  Widget _loadedLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return Dismissible(
                child: _setupList(position),
                key: Key("${misTarjetas[position].cardNumber}"),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: EdgeInsets.only(top: 8),
                  color: kRedActive,
                ),
                confirmDismiss: (direction) async {
                  return await _alertDeleteCreditCard(position);
                },
                onDismissed: (direction) {},
              );
            },
            itemCount: misTarjetas.length,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 28),
          child: M2Button(
            title: 'Agregar tarjeta',
            backgroundColor: buttonBackgroundColor,
            shadowColor: buttonShadowColor,
            onPressed: () {
              if (hasConnection) {
                _handlesNavigation();
              } else {
                showBasicAlert(
                  context,
                  "Sin internet",
                  "Por favor, conéctate a internet para poder agregar tarjetas",
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _aunNoLayout() {
    return Stack(
      children: <Widget>[
        Center(
          child: Manda2AunNoView(
            imagePath: "images/noTarjetas.png",
            title: "No tienes tarjetas.",
            subtitle: "",
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
          ),
        ),
        Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 28),
              child: M2Button(
                title: 'Agregar tarjeta',
                backgroundColor: buttonBackgroundColor,
                shadowColor: buttonShadowColor,
                onPressed: () {
                  if (hasConnection) {
                    _handlesNavigation();
                  } else {
                    showBasicAlert(
                      context,
                      "Sin internet",
                      "Por favor, conéctate a internet para poder agregar tarjetas",
                    );
                  }
                },
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _setupList(int position) {
    Tarjeta tarjeta = misTarjetas[position];

    return GestureDetector(
      onTap: () {
        if (isEditing) {
          _alertDeletesTarjeta(
            misTarjetas[position].cardNumber,
            position,
          );
        } else {
          HapticFeedback.selectionClick();
          if (!misTarjetas[position].isFavorite) {
            Map<String, dynamic> userMap = {
              "favoriteCreditCard": misTarjetas[position].cardNumber,
            };

            user.favoriteCreditCard = misTarjetas[position].cardNumber;
            Firestore.instance.document("users/${user.id}").updateData(userMap);
            for (int i = 0; i < misTarjetas.length; i++) {
              setState(() {
                if (misTarjetas[position] == misTarjetas[i]) {
                  misTarjetas[i].isFavorite = true;
                } else {
                  misTarjetas[i].isFavorite = false;
                }
              });
            }
          }
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 16, 8, 0),
        padding: EdgeInsets.symmetric(horizontal: 30),
        height: 67,
        decoration: BoxDecoration(
          color: kWhiteColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              child: tarjeta.type == CardType.otherBrand
                  ? Container(
                      width: 48,
                      height: 38,
                      decoration: BoxDecoration(
                        color: kBlackColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    )
                  : getCardTypeIcon(tarjeta.type),
            ),
            SizedBox(width: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("${misTarjetas[position].cardNumber}",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: kBlackColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w500))),
                Text("${tarjeta.expiryDate}",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            color: kGreenManda2Color,
                            fontSize: 15,
                            fontWeight: FontWeight.w500))),
              ],
            ),
            Expanded(child: Container()),
            _setupFavoriteCard(tarjeta.isFavorite),
          ],
        ),
      ),
    );
  }

  Widget _setupFavoriteCard(bool isFavorite) {
    if (!isEditing) {
      if (isFavorite) {
        return Image(
          height: 25,
          image: AssetImage("images/checkVerde.png"),
        );
      } else {
        return Container();
      }
    } else {
      return null;
    }
  }

  void _getTarjetas() async {
    if (misTarjetas.isEmpty) {
      if (user.userTks["creditCardA"] != null) {
        _buildAndAddTarjeta("A");
      }
      if (user.userTks["creditCardB"] != null) {
        _buildAndAddTarjeta("B");
      }
      if (user.userTks["creditCardC"] != null) {
        _buildAndAddTarjeta("C");
      }
    }

    setState(() {
      isLoadingCards = false;
    });
  }

  void _buildAndAddTarjeta(String cardSerial) {
    Tarjeta tarjeta = Tarjeta();

    CardType tipo = CardType.otherBrand;

    switch (user.userTks["creditCard$cardSerial"]["paymentMethod"]) {
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

    tarjeta.type = tipo;
    tarjeta.cardNumber =
        user.userTks["creditCard$cardSerial"]["lastFourDigits"];
    tarjeta.expiryDate = user.userTks["creditCard$cardSerial"]["expiryDate"];

    tarjeta.isFavorite = user.favoriteCreditCard ==
            user.userTks["creditCard$cardSerial"]["lastFourDigits"]
        ? true
        : false;

    //AGREGO TARJETAS AL ARREGLO TARJETAS
    misTarjetas.add(tarjeta);
  }

  void _alertDeletesTarjeta(String cardNumber, int position) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text("¿Quieres eliminar la tarjeta que termina en $cardNumber?"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Eliminar tarjeta"),
            isDestructiveAction: true,
            onPressed: () {
              setState(() {
                misTarjetas.removeAt(position);
              });
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, "Volver");
          },
        ),
      ),
    );
  }

  Widget getCardTypeIcon(CardType cardType) {
    Widget icon;
    switch (cardType) {
      case CardType.visa:
        icon = Image.asset(
          'icons/visa.png',
          height: 48,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      case CardType.americanExpress:
        icon = Image.asset(
          'icons/amex.png',
          height: 48,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      case CardType.mastercard:
        icon = Image.asset(
          'icons/mastercard.png',
          height: 48,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      case CardType.discover:
        icon = Image.asset(
          'icons/discover.png',
          height: 48,
          width: 48,
          package: 'flutter_credit_card',
        );
        break;

      default:
        icon = Container(
          height: 48,
          width: 48,
        );
        break;
    }

    return icon;
  }

  Future<bool> _alertDeleteCreditCard(int position) async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
            "¿Quieres eliminar la tarjeta que\ntermina en ${misTarjetas[position].cardNumber}?"),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text("Eliminar tarjeta"),
            isDestructiveAction: true,
            onPressed: () {
              _deleteCreditCard(position);
              Navigator.pop(context, "Volver");
              return true;
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text("Volver"),
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context, "Volver");
            return false;
          },
        ),
      ),
    );
  }

  void _handlesNavigation() async {
    if (user.numTarjetas == 3) {
      showBasicAlert(
        context,
        "Límite de tarjetas por usuario alcanzado",
        "Sólo puedes agregar tres tarjetas :)",
      );
    } else {
      final result = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => NuevaTarjeta(),
        ),
      );

      if (result != null) {
        setState(() {
          misTarjetas = result as List<Tarjeta>;
          isLoadingCards = false;
          if (user.numTarjetas == 3) {
            buttonBackgroundColor = kDisabledButtonColor;
            buttonShadowColor = kTransparent;
          }
        });
      }
    }
  }

  Future<void> _deleteCreditCard(int position) async {
    String numPos = misTarjetas[position].cardNumber;
    Map creditCards = {};
    if (user.userTks["creditCardA"] != null) {
      if (user.userTks["creditCardA"]["lastFourDigits"] == numPos) {
        creditCards = {
          "creditCardA": user.userTks["creditCardB"],
          "creditCardB": user.userTks["creditCardC"],
          "creditCardC": null,
        };
        setState(() {
          user.userTks["creditCardA"] = user.userTks["creditCardB"];
          user.userTks["creditCardB"] = user.userTks["creditCardC"];
          user.userTks["creditCardC"] = null;
        });
      }
    }
    if (user.userTks["creditCardB"] != null) {
      if (user.userTks["creditCardB"]["lastFourDigits"] == numPos) {
        creditCards = {
          "creditCardA": user.userTks["creditCardA"],
          "creditCardB": user.userTks["creditCardC"],
          "creditCardC": null,
        };
        setState(() {
          user.userTks["creditCardA"] = user.userTks["creditCardA"];
          user.userTks["creditCardB"] = user.userTks["creditCardC"];
          user.userTks["creditCardC"] = null;
        });
      }
    }
    if (user.userTks["creditCardC"] != null) {
      if (user.userTks["creditCardC"]["lastFourDigits"] == numPos) {
        creditCards = {
          "creditCardA": user.userTks["creditCardA"],
          "creditCardB": user.userTks["creditCardB"],
          "creditCardC": null,
        };
        setState(() {
          user.userTks["creditCardA"] = user.userTks["creditCardA"];
          user.userTks["creditCardB"] = user.userTks["creditCardB"];
          user.userTks["creditCardC"] = null;
        });
      }
    }

    if (misTarjetas[position].isFavorite) {
      if (position + 2 <= misTarjetas.length) {
        user.favoriteCreditCard = misTarjetas[position + 1].cardNumber;
      } else if (position > 0) {
        user.favoriteCreditCard = misTarjetas[position - 1].cardNumber;
      } else {
        user.favoriteCreditCard = "";
      }
    }

    Map<String, dynamic> userMap = {
      "creditCards": creditCards,
      "favoriteCreditCard": user.favoriteCreditCard,
      "numTarjetas": (user.numTarjetas - 1),
    };

    print("⏳ ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${user.id}")
        .updateData(userMap)
        .then((r) {
      print("✔️ USER ACTUALIZADO");
      setState(() {
        if (misTarjetas[position].isFavorite) {
          if (position + 2 <= misTarjetas.length) {
            misTarjetas[position].isFavorite = false;
            misTarjetas[position + 1].isFavorite = true;
          } else if (position > 0) {
            misTarjetas[position].isFavorite = false;
            misTarjetas[position - 1].isFavorite = true;
          } else {
            misTarjetas.clear();
          }
        }
        misTarjetas.removeWhere((tarjeta) {
          return tarjeta.cardNumber == misTarjetas[position].cardNumber;
        });
        user.numTarjetas--;
      });
    }).catchError((e) {
      print("💩 ERROR AL ACTUALIZAR USER: $e");
    });
  }
}
