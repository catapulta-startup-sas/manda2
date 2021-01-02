import 'package:dotted_border/dotted_border.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/categoria_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/model/mandado_model.dart';
import 'package:manda2/view_controllers/Home/solicitud/q3_formulario_page.dart';
import 'package:manda2/view_controllers/Home/solicitud/solicitud_resumen_page.dart';

class Q3SetPlaces extends StatefulWidget {
  Q3SetPlaces({
    this.numDestinos,
    this.categoria,
    this.tagOrigen,
    this.origen,
    this.vieneResumen,
    this.mandadosFromBuilder,
  });
  int numDestinos;
  Categoria categoria;
  String tagOrigen;
  Lugar origen;
  List<Mandado> mandadosFromBuilder;
  bool vieneResumen;

  @override
  _Q3SetPlacesState createState() => _Q3SetPlacesState(
        numDestinos: numDestinos,
        categoria: categoria,
        tagOrigen: tagOrigen,
        origen: origen,
        vieneResumen: vieneResumen,
        mandadosFromBuilder: mandadosFromBuilder,
      );
}

class _Q3SetPlacesState extends State<Q3SetPlaces> {
  _Q3SetPlacesState({
    this.numDestinos,
    this.categoria,
    this.tagOrigen,
    this.origen,
    this.vieneResumen,
    this.mandadosFromBuilder,
  });
  int numDestinos;
  Categoria categoria;
  String tagOrigen;
  Lugar origen;
  List<Mandado> mandadosFromBuilder;
  bool vieneResumen;

  bool isEditing = false;

  List<Mandado> mandados = List();

  @override
  void initState() {
    print("ORIGEN: $origen");

    super.initState();
    if (vieneResumen != null && vieneResumen) {
      numDestinos = mandadosFromBuilder.length;
      mandados = mandadosFromBuilder;
    } else {
      for (int i = 0; i < numDestinos; i++) {
        mandados.add(null);
      }
    }
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
            "Destinos",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        trailing: GestureDetector(
          child: Text(
            isEditing ? "Listo" : "Editar",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(fontSize: 15, color: kBlackColor),
            ),
          ),
          onTap: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 19),
              child: GestureDetector(
                child: DottedBorder(
                  color: isEditing || mandados.isEmpty
                      ? kCategoryBorderColor
                      : kTransparent,
                  strokeWidth: 1,
                  dashPattern: [4, 4],
                  padding: EdgeInsets.all(0),
                  borderType: BorderType.RRect,
                  radius: Radius.circular(14),
                  child: AnimatedContainer(
                    height: isEditing || mandados.isEmpty ? 67 : 0,
                    width: MediaQuery.of(context).size.width,
                    duration: Duration(milliseconds: 400),
                    color: kTransparent,
                    child: Center(
                      child: Text(
                        "Agregar destino",
                        style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 14, color: kBlackColorOpacity)),
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    mandados.insert(0, null);
                  });
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, position) {
                  if (mandados[position] == null) {
                    /// Vacío
                    return GestureDetector(
                      child: Container(
                        height: 67,
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
                        margin: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 6,
                        ),
                        child: Row(
                          children: <Widget>[
                            SizedBox(width: 15),
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius: kRadiusAll,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          kBlackColorOpacity.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  border:
                                      Border.all(color: kBlackColor, width: 2)),
                              child: Center(
                                child: Text(
                                  '${position + 1}',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 13, color: kBlackColor)),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('Vacío',
                                style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                        fontSize: 14,
                                        color: kBlackColorOpacity))),
                            Expanded(child: Container()),
                            isEditing
                                ? Image.asset("images/eliminarLugares.png",
                                    height: 14)
                                : Image.asset('images/adelante.png',
                                    height: 14),
                            SizedBox(width: 18)
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (isEditing) {
                          if (mandados.length == 1) {
                            showBasicAlert(
                              context,
                              "Debes tener al menos 1 destino para continuar.",
                              "",
                            );
                          } else {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoActionSheet(
                                title: Text(
                                    "¿Quieres eliminar el destino ${position + 1}?"),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text("Eliminar"),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        mandados.removeAt(position);
                                      });
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text("Volver"),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          }
                        } else {
                          final result = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Q3Formulario(
                                posicion: position,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              mandados[position] = result as Mandado;
                            });
                          }
                        }
                      },
                    );
                  } else {
                    /// Lleno
                    return GestureDetector(
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                        margin: EdgeInsets.fromLTRB(8, 5, 8, 5),
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                  color: kWhiteColor,
                                  borderRadius: kRadiusAll,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          kBlackColorOpacity.withOpacity(0.2),
                                      spreadRadius: 3,
                                      blurRadius: 7,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  border:
                                      Border.all(color: kBlackColor, width: 2)),
                              child: Center(
                                child: Text(
                                  '${position + 1}',
                                  style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                          fontSize: 13, color: kBlackColor)),
                                ),
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Text(
                                      "${mandados[position].destino.contactoName}",
                                      style: GoogleFonts.poppins(
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              color: kBlackColor)),
                                    ),
                                    padding: EdgeInsets.only(bottom: 5),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    padding: EdgeInsets.only(bottom: 5),
                                    child: Text(
                                      "${mandados[position].destino.direccion}, ${mandados[position].destino.ciudad}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          color: kBlackColorOpacity,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Text(
                                      "Identificador ${mandados[position].identificador}",
                                      style: GoogleFonts.poppins(
                                        textStyle: TextStyle(
                                          fontSize: 12,
                                          color: kBlackColorOpacity,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 8),
                            isEditing
                                ? Image.asset("images/eliminarLugares.png",
                                    height: 14)
                                : Image.asset('images/adelante.png', height: 14)
                          ],
                        ),
                      ),
                      onTap: () async {
                        if (isEditing) {
                          if (mandados.length == 1) {
                            showBasicAlert(
                              context,
                              "Debes tener al menos 1 destino para continuar.",
                              "",
                            );
                          } else {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) =>
                                  CupertinoActionSheet(
                                title: Text(
                                    "¿Quieres eliminar el mandado ${position + 1} con destino a ${mandados[position].destino.direccion}?"),
                                actions: <Widget>[
                                  CupertinoActionSheetAction(
                                    child: Text("Eliminar"),
                                    isDestructiveAction: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        mandados.removeAt(position);
                                      });
                                    },
                                  ),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text("Volver"),
                                  isDefaultAction: true,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            );
                          }
                        } else {
                          final result = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => Q3Formulario(
                                mandado: mandados[position],
                                posicion: position,
                              ),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              mandados[position] = result as Mandado;
                            });
                          }
                        }
                      },
                    );
                  }
                },
                itemCount: mandados.length,
              ),
            ),
            isEditing ? Container() : SizedBox(height: 20),
            isEditing
                ? Container()
                : M2Button(
                    title: (vieneResumen ?? false) ? "Actualizar" : 'Continuar',
                    backgroundColor: mandados.contains(null) || mandados.isEmpty
                        ? kBlackColorOpacity
                        : kGreenManda2Color,
                    shadowColor: mandados.contains(null) || mandados.isEmpty
                        ? kBlackColorOpacity.withOpacity(0.4)
                        : kGreenManda2Color.withOpacity(0.4),
                    onPressed: () {
                      if (vieneResumen ?? false) {
                        if (!mandados.contains(null) && mandados.isNotEmpty) {
                          Navigator.pop(context, mandados);
                        } else if (mandados.isEmpty) {
                          showBasicAlert(
                            context,
                            "Sin destinos",
                            "Por favor, crea al menos 1 destino para continuar.",
                          );
                        } else {
                          showBasicAlert(
                            context,
                            "Destinos vacíos",
                            "Por favor, completa la información de todos los destinos para continuar.",
                          );
                        }
                      } else {
                        if (!mandados.contains(null) && mandados.isNotEmpty) {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => SolicitudResumenPage(
                                categoria: categoria,
                                tagOrigen: tagOrigen,
                                numDestinos: mandados.length,
                                mandados: mandados,
                                origen: origen,
                              ),
                            ),
                          );
                        } else if (mandados.isEmpty) {
                          showBasicAlert(
                            context,
                            "Sin destinos",
                            "Por favor, crea al menos 1 destino para continuar.",
                          );
                        } else {
                          showBasicAlert(
                            context,
                            "Destinos vacíos",
                            "Por favor, completa la información de todos los destinos para continuar.",
                          );
                        }
                      }
                    },
                  ),
            isEditing ? Container() : SizedBox(height: 48)
          ],
        ),
      ),
    );
  }
}
