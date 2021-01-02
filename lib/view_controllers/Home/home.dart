import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:manda2/components/m2_bouncing_button.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/first_word_from_paragraph.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:manda2/view_controllers/Home/seguimiento/solicitudes_page.dart';
import 'package:manda2/view_controllers/Home/solicitud/solicitud_q1_page.dart';
import 'package:manda2/view_controllers/Perfil/perfil_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Home extends StatefulWidget {
  final bool isHaciendoTutorial;

  Home({
    this.isHaciendoTutorial,
  });
  @override
  _HomeState createState() =>
      _HomeState(isHaciendoTutorial: isHaciendoTutorial);
}

enum EstadoTutorial {
  inicio,
  editar,
  editado,
  sigueMandados,
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  PanelController _pc = new PanelController();
  _HomeState({
    this.isHaciendoTutorial,
  });

  String arrowSigueTusMandadosDirection = "Up";
  String emoji;
  String title;
  double height;
  double width;
  bool isHaciendoTutorial = false;
  EstadoTutorial estadoTutorial;

  AlertStyle alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      isCloseButton: true,
      descStyle: TextStyle(fontWeight: FontWeight.bold),
      animationDuration: Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: kRadiusAll,
      ),
      overlayColor: Color(0x66000000),
      alertElevation: 0);

  void initState() {
    if (isHaciendoTutorial == null) {
      setState(() {
        isHaciendoTutorial = false;
      });
    }
    estadoTutorial = EstadoTutorial.inicio;

    super.initState();
  }

  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SlidingUpPanel(
          body: Scaffold(
            backgroundColor:
                isHaciendoTutorial ? kTutorialColor : kLightGreyColor,
            appBar: CupertinoNavigationBar(
              backgroundColor:
                  isHaciendoTutorial ? kTutorialColor : kLightGreyColor,
              border: Border(
                bottom: BorderSide(
                  color: isHaciendoTutorial ? kTutorialColor : kLightGreyColor,
                  width: 0.0,
                ),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Perfil(),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 13, horizontal: 5),
                  color: isHaciendoTutorial ? kTutorialColor : kLightGreyColor,
                  child: Image(
                    image: AssetImage('images/perfil.png'),
                  ),
                ),
              ),
              middle: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Image.asset("images/manda2LogotipoHome.png"),
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: isHaciendoTutorial
                        ? MediaQuery.of(context).size.height - 300
                        : MediaQuery.of(context).size.height +
                            (((user.categorias.length + 1) / 3).ceil()) * 100,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            SizedBox(width: 20),
                            GestureDetector(
                              onTap: () {
                                if (!isHaciendoTutorial) {
                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => Perfil(),
                                    ),
                                  );
                                }
                              },
                              child: Stack(
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
                                      height: 54,
                                      width: 54,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: kTransparent),
                                      borderRadius: kRadiusAll,
                                      image: DecorationImage(
                                        image: NetworkImage(user
                                                .fotoPerfilURL ??
                                            "https://backendlessappcontent.com/79616ED6-B9BE-C7DF-FFAF-1A179BF72500/7AFF9E36-4902-458F-8B55-E5495A9D6732/files/fotoDePerfil.png"),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    height: 54,
                                    width: 54,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 14),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 27,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      child: Text(
                                        "¡Hola, ${firstWordFromParagraph(user.name)}!",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 18,
                                            color: kBlackColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 14),
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  height: 27,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: FittedBox(
                                      child: Text(
                                        "¿Qué mandado llevamos por ti?",
                                        style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                            fontSize: 15,
                                            color: kBlackColorHome,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 48),
                        Expanded(
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 22,
                              mainAxisSpacing: 22,
                              childAspectRatio: 0.65,
                            ),
                            itemBuilder: (context, position) {
                              return setupGridLayout(position);
                            },
                            itemCount: user.numCategorias + 1,
                          ),
                        ),
                        SizedBox(
                          height: 100,
                        )
                      ],
                    ),
                  ),
                  isHaciendoTutorial &&
                          estadoTutorial == EstadoTutorial.sigueMandados
                      ? Container(
                          height: MediaQuery.of(context).size.height -
                              kToolbarHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(17, 0, 17, 100),
                                child: Center(
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 400),
                                    width: isHaciendoTutorial &&
                                            estadoTutorial ==
                                                EstadoTutorial.sigueMandados
                                        ? MediaQuery.of(context).size.width
                                        : 0,
                                    decoration: BoxDecoration(
                                        color: kGreenTutorial,
                                        borderRadius: kRadiusAll),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 19, vertical: 16),
                                      child: Text(
                                        '¡Felicitaciones! Solicitaste tu primer mandado.\n\nToca la barra de abajo para seguirlo.',
                                        style: GoogleFonts.poppins(
                                            textStyle: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 15)),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : isHaciendoTutorial
                          ? Padding(
                              padding: EdgeInsets.fromLTRB(17, 300, 17, 0),
                              child: Center(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 400),
                                  height: isHaciendoTutorial &&
                                          estadoTutorial ==
                                              EstadoTutorial.inicio
                                      ? 150
                                      : isHaciendoTutorial &&
                                              estadoTutorial ==
                                                  EstadoTutorial.editado
                                          ? 130
                                          : 0,
                                  decoration: BoxDecoration(
                                      color: kGreenTutorial,
                                      borderRadius: kRadiusAll),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 19, vertical: 16),
                                    child: Text(
                                      estadoTutorial == EstadoTutorial.inicio
                                          ? '¡Bienvenido! Estas son tus categorías de mandados personalizados.\n\nMantén presionado para personalizar una categoría.'
                                          : '¡Excelente! Editaste una categoría.\n\nAhora tócala para solicitar tu primer mandado de prueba.',
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w300,
                                              fontSize: 15)),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox()
                ],
              ),
            ),
          ),
          controller: _pc,
          backdropEnabled: true,
          panel: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (_pc.isPanelOpen()) {
                      _pc.close();
                    } else {
                      if (!isHaciendoTutorial) {
                        _pc.open();
                      }
                    }
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isHaciendoTutorial ? kTutorialColor : kWhiteColor,
                    borderRadius: kRadiusOnlyTop,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 12),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 400),
                              decoration: BoxDecoration(
                                borderRadius: kRadiusAll,
                                color: kWhiteColor,
                              ),
                              height: isHaciendoTutorial &&
                                      estadoTutorial ==
                                          EstadoTutorial.sigueMandados
                                  ? 60
                                  : 0,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 37),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 20),
                            Text(
                              "Sigue tus mandados",
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Expanded(child: Container()),
                            Image.asset(
                              "images/arrow${arrowSigueTusMandadosDirection}SigueTusMandados.png",
                              color: kBlackColor,
                              height: 20,
                              width: 20,
                            ),
                            SizedBox(width: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, position) {
                    return user.categorias[position].isHidden &&
                            user.categorias[position].numMandados == 0
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                _pc.close();
                              });
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => Solicitudes(
                                    categoria: user.categorias[position],
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: kRadiusAll,
                                color: kWhiteColor,
                                border: Border.all(
                                  color: kBlackColorOpacity,
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              height: 106,
                              child: Row(
                                children: <Widget>[
                                  SizedBox(width: 20),
                                  Text(
                                    user.categorias[position].emoji,
                                    style: TextStyle(fontSize: 40),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        height: 20,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              user.categorias[position].isHidden
                                                  ? "${user.categorias[position].title} (eliminado)"
                                                  : "${user.categorias[position].title}",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        height: 20,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              "${user.categorias[position].numMandados} ${user.categorias[position].numMandados == 1 ? "mandado" : "mandados"}",
                                              style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                  color: kBlackColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(child: Container()),
                                  Image.asset(
                                    'images/arrowRightBotones.png',
                                    color: kBlackColorOpacity,
                                    height: 15,
                                  ),
                                  SizedBox(width: 28),
                                ],
                              ),
                            ),
                          );
                  },
                  itemCount: user.categorias.length ?? 1,
                ),
              ),
            ],
          ),
          onPanelClosed: () {
            setState(() {
              arrowSigueTusMandadosDirection = "Up";
            });
          },
          onPanelOpened: () {
            setState(() {
              arrowSigueTusMandadosDirection = "Down";
            });
          },
          color: isHaciendoTutorial ? kTutorialColor : kWhiteColor,
          isDraggable: true,
          borderRadius: kRadiusOnlyTop,
          defaultPanelState: PanelState.CLOSED,
          minHeight: 100,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
      ),
    );
  }

  Widget setupGridLayout(int position) {
    if (position == 0) {
      return Container(
        color: isHaciendoTutorial ? kTutorialColor : kLightGreyColor,
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            BouncingButton(
              child: Container(
                padding: EdgeInsets.all(29),
                height: 89,
                width: 89,
                decoration: BoxDecoration(
                    color: kBlackColor, borderRadius: kRadiusCircular),
                child: Image.asset(
                  'images/+.png',
                  height: 31,
                ),
              ),
              onTap: () {
                setState(() {
                  if (!isHaciendoTutorial) {
                    _handleNuevaCategoria();
                    HapticFeedback.lightImpact();
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  if (!isHaciendoTutorial) {
                    _handleNuevaCategoria();
                    HapticFeedback.lightImpact();
                  }
                });
              },
            ),
            SizedBox(height: 10),
            Text(
              "Nueva categoría",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            )
          ],
        ),
      );
    } else {
      return Stack(
        children: [
          Column(
            children: [
              position == 1
                  ? AnimatedContainer(
                      decoration: BoxDecoration(
                        borderRadius: kRadiusAll,
                        color: kWhiteColor,
                      ),
                      duration: Duration(milliseconds: 400),
                      height: isHaciendoTutorial &&
                              (estadoTutorial == EstadoTutorial.inicio ||
                                  estadoTutorial == EstadoTutorial.editado)
                          ? 160
                          : 0,
                    )
                  : Container(),
            ],
          ),
          Column(
            children: <Widget>[
              Center(child: SizedBox(height: 10)),
              BouncingButton(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 400),
                  height: 89,
                  width: 89,
                  decoration: BoxDecoration(
                    color: (estadoTutorial == EstadoTutorial.editar ||
                                estadoTutorial ==
                                    EstadoTutorial.sigueMandados) &&
                            isHaciendoTutorial &&
                            position == 1
                        ? kTransparent
                        : isHaciendoTutorial && position != 1
                            ? kTransparent
                            : kWhiteColor,
                    borderRadius: kRadiusCircular,
                    boxShadow: [
                      BoxShadow(
                        color: (estadoTutorial == EstadoTutorial.editar ||
                                    estadoTutorial ==
                                        EstadoTutorial.sigueMandados) &&
                                isHaciendoTutorial &&
                                position == 1
                            ? kTransparent
                            : isHaciendoTutorial && position != 1
                                ? kTransparent
                                : kBlackColorOpacity.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(8, 3),
                      )
                    ],
                  ),
                  child: Center(
                    child: Text(
                      user.categorias[position - 1].emoji,
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                onLongPress: () {
                  if (isHaciendoTutorial) {
                    if (position == 1) {
                      setState(() {
                        estadoTutorial = EstadoTutorial.editar;
                      });
                      delayedHandleEditar(position);
                      estadoTutorial = EstadoTutorial.editar;
                    }
                  } else {
                    _handleEditarCategoria(position, false);
                  }
                  HapticFeedback.lightImpact();
                },
                onTap: () {
                  if (isHaciendoTutorial &&
                      estadoTutorial == EstadoTutorial.editado) {
                    setState(() {
                      isHaciendoTutorial = false;
                    });
                    delayedState(position);
                  } else {
                    if (!isHaciendoTutorial) {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => SolicitudQ1(
                            categoria: user.categorias[position - 1],
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
              SizedBox(height: 10),
              Text(
                user.categorias[position - 1].title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
  }

  void _handleNuevaCategoria() {
    Alert(
      context: context,
      style: alertStyle,
      title: '',
      content: Column(
        children: <Widget>[
          /// EMOJI
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              DottedBorder(
                color: kCategoryBorderColor,
                strokeWidth: 1,
                dashPattern: [4, 4],
                padding: EdgeInsets.all(1),
                borderType: BorderType.RRect,
                radius: Radius.circular(45),
                child: Container(
                  height: 89,
                  width: 89,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: kRadiusCircular,
                    boxShadow: [
                      BoxShadow(
                        color: kBlackColorOpacity.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(8, 3),
                      )
                    ],
                  ),
                ),
              ),
              TextFormField(
                maxLength: 1,
                initialValue: "🍪",
                textCapitalization: TextCapitalization.none,
                keyboardAppearance: Brightness.light,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: kBlackColor,
                    fontSize: 50,
                  ),
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(
                    RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
                    ),
                  ),
                ],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "",
                  counterText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: kBlackColorOpacity,
                      fontSize: 50,
                    ),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    emoji = text;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 30),

          /// NOMBRE CATEGORIA
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              DottedBorder(
                color: kCategoryBorderColor,
                strokeWidth: 1,
                dashPattern: [3, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(6),
                child: Container(
                  height: 23,
                  width: 122,
                ),
              ),
              TextFormField(
                maxLength: 10,
                textCapitalization: TextCapitalization.words,
                keyboardAppearance: Brightness.light,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: kBlackColor,
                    fontSize: 13,
                  ),
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "Ej: Galletas",
                  counterText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: kBlackColorOpacity,
                      fontSize: 13,
                    ),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    title = text;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          CupertinoButton(
            color: kTransparent,
            child: Text("Agregar",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    color: kBotonWifiColor,
                    fontSize: 15,
                  ),
                )),
            onPressed: () {
              if ((emoji == "" || emoji == null) &&
                  (title == "" || title == null)) {
                showBasicAlert(
                  context,
                  'Por favor, rellena los campos para continuar.',
                  '',
                );
              } else if (emoji == "" || emoji == null) {
                showBasicAlert(
                  context,
                  'Por favor, determina el emoji de la categoría.',
                  '',
                );
              } else if (title == "" || title == null) {
                showBasicAlert(
                  context,
                  'Por favor, determina el título de la categoría.',
                  '',
                );
              } else {
                Map<String, dynamic> categoriaMap = {
                  "emoji": emoji,
                  "title": title,
                  "numMandados": 0,
                  "isHidden": false,
                };

                Map<String, dynamic> userDoc = {
                  "categorias": FieldValue.arrayUnion([categoriaMap]),
                };

                print("CREARÉ CATEGORÍA");
                Firestore.instance
                    .document("users/${user.id}")
                    .updateData(userDoc)
                    .then((r) {
                  print("CATEGORÍA CREADA");
                  setState(() {
                    user.categorias.insert(
                      0,
                      Categoria(
                        emoji: emoji,
                        title: title,
                        numMandados: 0,
                        isHidden: false,
                      ),
                    );
                    user.numCategorias++;
                    emoji = null;
                    title = null;
                  });
                }).catchError((e) {
                  print("ERROR AL CREAR CATEGORÍA: $e");
                  showBasicAlert(
                    context,
                    "Hubo un error.",
                    "Por favor, intenta más tarde",
                  );
                });
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      buttons: [
        DialogButton(
          height: 0,
          color: kTransparent,
          child: Container(height: 0),
        ),
      ],
      closeFunction: () {
        Navigator.pop(context);
        emoji = null;
        title = null;
      },
    ).show();
  }

  void _handleEditarCategoria(position, bool mostrar) {
    Alert(
      onWillPopActive: isHaciendoTutorial ? true : false,
      context: context,
      style: AlertStyle(
        animationType: AnimationType.grow,
        isCloseButton: isHaciendoTutorial ? false : true,
        descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: kRadiusAll,
        ),
        overlayColor: Color(0x66000000),
        alertElevation: 0,
      ),
      mostrar: mostrar,
      textStyle: GoogleFonts.poppins(
        textStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w300,
        ),
      ),
      title: '',
      content: Column(
        children: <Widget>[
          /// EMOJI

          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              DottedBorder(
                color: kCategoryBorderColor,
                strokeWidth: 1,
                dashPattern: [4, 4],
                padding: EdgeInsets.all(1),
                borderType: BorderType.RRect,
                radius: Radius.circular(45),
                child: Container(
                  height: 89,
                  width: 89,
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: kRadiusCircular,
                    boxShadow: [
                      BoxShadow(
                        color: kBlackColorOpacity.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(8, 3),
                      )
                    ],
                  ),
                ),
              ),
              TextFormField(
                maxLength: 1,
                initialValue: '${user.categorias[position - 1].emoji}',
                textCapitalization: TextCapitalization.none,
                keyboardAppearance: Brightness.light,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: kBlackColor,
                    fontSize: 50,
                  ),
                ),
                inputFormatters: [
                  WhitelistingTextInputFormatter(
                    RegExp(
                      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
                    ),
                  ),
                ],
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "",
                  counterText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: kBlackColorOpacity,
                      fontSize: 50,
                    ),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    emoji = text;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 30),

          /// NOMBRE CATEGORIA
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              DottedBorder(
                color: kCategoryBorderColor,
                strokeWidth: 1,
                dashPattern: [3, 3],
                borderType: BorderType.RRect,
                radius: Radius.circular(6),
                child: Container(
                  height: 23,
                  width: 122,
                ),
              ),
              TextFormField(
                maxLength: 10,
                textCapitalization: TextCapitalization.words,
                keyboardAppearance: Brightness.light,
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w300,
                    color: kBlackColor,
                    fontSize: 13,
                  ),
                ),
                textAlign: TextAlign.center,
                initialValue: "${user.categorias[position - 1].title}",
                decoration: InputDecoration(
                  hintText: "${user.categorias[position - 1].title}",
                  counterText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: kTransparent),
                  ),
                  hintStyle: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: kBlackColorOpacity,
                      fontSize: 13,
                    ),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    title = text;
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              user.numCategorias == 1 || isHaciendoTutorial
                  ? Container()
                  : Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.all(0),
                        color: kTransparent,
                        child: Text(
                          "Eliminar",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: kRedBotonAlert,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        onPressed: () {
                          showAlert(
                              context: context,
                              title: "¿Eliminar categoría?",
                              body: "No podrás recuperarla después.",
                              actions: [
                                AlertAction(
                                  text: "Volver",
                                ),
                                AlertAction(
                                  text: "Eliminar",
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    if (user.categorias[position - 1]
                                            .numMandados ==
                                        0) {
                                      setState(() {
                                        deleteCategoria(position);
                                      });
                                    } else {
                                      hideCategoria(position);
                                    }
                                  },
                                ),
                              ]);
                        },
                      ),
                    ),
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.all(0),
                  color: kTransparent,
                  child: Text(
                    "Actualizar",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: kBotonWifiColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if ((emoji != null || title != null) &&
                        (emoji != "" && title != "")) {
                      if (!((emoji == user.categorias[position - 1].emoji ||
                              emoji == null) &&
                          (title == user.categorias[position - 1].title ||
                              title == null))) {
                        if (isHaciendoTutorial) {
                          setState(() {
                            delayedEstado();
                          });
                        }

                        /// Var que contiene datos a subir
                        List<Map<String, dynamic>> categoriaMapList = [];

                        /// Convertir lista de Categorias en lista de Maps
                        user.categorias.forEach((categoria) {
                          categoriaMapList.add({
                            "emoji": categoria.emoji,
                            "title": categoria.title,
                            "numMandados": categoria.numMandados,
                            "isHidden": categoria.isHidden,
                          });
                        });

                        /// Actualizamos categoría en [categoriasTemp]
                        categoriaMapList[position - 1] = {
                          "emoji": emoji ?? user.categorias[position - 1].emoji,
                          "title": title ?? user.categorias[position - 1].title,
                          "numMandados": categoriaMapList[position - 1]
                              ["numMandados"],
                          "isHidden": categoriaMapList[position - 1]
                              ["isHidden"],
                        };

                        /// Creamos userDoc
                        Map<String, dynamic> userDoc = {
                          "categorias": categoriaMapList.reversed.toList(),
                        };

                        print("ACTUALIZARÉ USER");
                        Firestore.instance
                            .document("users/${user.id}")
                            .updateData(userDoc)
                            .then((r) {
                          print("USER ACTUALIZADO");
                          setState(() {
                            user.categorias[position - 1] = Categoria(
                              emoji:
                                  emoji ?? user.categorias[position - 1].emoji,
                              title:
                                  title ?? user.categorias[position - 1].title,
                              numMandados:
                                  user.categorias[position - 1].numMandados,
                              isHidden: user.categorias[position - 1].isHidden,
                            );
                            emoji = null;
                            title = null;
                          });
                        }).catchError((e) {
                          print("ERROR AL EDITAR CATEGORÍA: $e");
                          showBasicAlert(
                            context,
                            "Hubo un error.",
                            "Por favor intenta más tarde.",
                          );
                        });
                        Navigator.pop(context);
                      } else {
                        print("LA DE ARRIBA");
                        showBasicAlert(
                          context,
                          'Por favor, edita un campo para continuar.',
                          '',
                        );
                      }
                    } else {
                      if (emoji == "" && title == "") {
                        showBasicAlert(
                          context,
                          'Por favor, rellena los campos para continuar.',
                          '',
                        );
                      } else if (emoji == "") {
                        showBasicAlert(
                          context,
                          'Por favor, determina el emoji de la categoría.',
                          '',
                        );
                      } else if (title == "") {
                        showBasicAlert(
                          context,
                          'Por favor, determina el título de la categoría.',
                          '',
                        );
                      } else {
                        print("LA DE ABAJO");
                        showBasicAlert(
                          context,
                          'Por favor, edita un campo para continuar.',
                          '',
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ],
      ),
      buttons: [
        DialogButton(
          height: 0,
          color: kTransparent,
          child: Container(height: 0),
        ),
      ],
      closeFunction: () {
        if (isHaciendoTutorial) {
        } else {
          Navigator.pop(context);
        }
        emoji = null;
        title = null;
      },
    ).show();
  }

  void hideCategoria(position) {
    List<Map<String, dynamic>> categoriaMapList = [];

    /// Convertir lista de Categorias en lista de Maps
    user.categorias.forEach((categoria) {
      categoriaMapList.add({
        "emoji": categoria.emoji,
        "title": categoria.title,
        "numMandados": categoria.numMandados,
        "isHidden": categoria.isHidden,
      });
    });

    /// Actualizamos categoría en [categoriasTemp]
    categoriaMapList[position - 1] = {
      "emoji": emoji ?? user.categorias[position - 1].emoji,
      "title": title ?? user.categorias[position - 1].title,
      "numMandados": categoriaMapList[position - 1]["numMandados"],
      "isHidden": true,
    };

    /// Creamos userDoc
    Map<String, dynamic> userDoc = {
      "categorias": categoriaMapList.reversed.toList(),
    };

    print("ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${user.id}")
        .updateData(userDoc)
        .then((r) {
      print("USER ACTUALIZADO");
      setState(() {
        user.categorias[position - 1] = Categoria(
          emoji: emoji ?? user.categorias[position - 1].emoji,
          title: title ?? user.categorias[position - 1].title,
          numMandados: user.categorias[position - 1].numMandados,
          isHidden: true,
        );
        user.categorias.sort((a, b) {
          if (a.isHidden) {
            return 1;
          } else {
            return -1;
          }
        });
        user.numCategorias--;
      });
    }).catchError((e) {
      print("ERROR AL EDITAR CATEGORÍA: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor intenta más tarde.",
      );
    });
    Navigator.pop(context);
  }

  void deleteCategoria(position) {
    Map<String, dynamic> categoriaMap = {
      "emoji": user.categorias[position - 1].emoji,
      "title": user.categorias[position - 1].title,
      "numMandados": user.categorias[position - 1].numMandados,
      "isHidden": user.categorias[position - 1].isHidden,
    };

    Map<String, dynamic> userDoc = {
      "categorias": FieldValue.arrayRemove([categoriaMap])
    };

    print("ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${user.id}")
        .updateData(userDoc)
        .then((value) {
      print("USER ACTUALIZADO");
      setState(() {
        user.categorias.removeAt(position - 1);
        user.numCategorias--;
      });
    }).catchError((e) {
      print("ERROR AL ELIMINAR CATEGORÍA: $e");
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor intenta más tarde.",
      );
    });
    Navigator.pop(context);
  }

  Future<void> delayedState(int position) async {
    await Future.delayed(Duration(seconds: 1));

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SolicitudQ1(
          categoria: user.categorias[position - 1],
        ),
      ),
    );
  }

  Future<void> delayedHandleEditar(position) async {
    await Future.delayed(Duration(seconds: 1));
    _handleEditarCategoria(position, true);
  }

  Future<void> delayedEstado() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      estadoTutorial = EstadoTutorial.editado;
    });
  }
}
