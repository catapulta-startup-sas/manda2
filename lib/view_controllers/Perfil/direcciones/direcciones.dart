import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_container_direcciones.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/internet_connection.dart';
import 'package:manda2/model/lugar_model.dart';
import 'package:manda2/view_controllers/Perfil/direcciones/nueva_direccion_favoritos.dart';
import 'package:provider/provider.dart';
import 'package:manda2/components/m2_aunno.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'editar_direccion_favoritos.dart';

List<Lugar> misLugares = [];

class Direcciones extends StatefulWidget {
  Direcciones({
    this.vieneSetPlaces,
  });
  bool vieneSetPlaces;

  @override
  _DireccionesState createState() => _DireccionesState(
        vieneSetPlaces: vieneSetPlaces,
      );
}

class _DireccionesState extends State<Direcciones> {
  _DireccionesState({
    this.vieneSetPlaces,
  });

  bool isDir = false;
  Color buttonBackgroundColor = kGreenManda2Color;
  Color buttonShadowColor = kGreenManda2Color.withOpacity(0.4);
  bool hasConnection = true;
  int positionToDelete = 200;

  bool vieneSetPlaces;

  bool successContainerIsHidden = true;

  @override
  void initState() {
    super.initState();

    if (vieneSetPlaces == null) {
      vieneSetPlaces = false;
    }

    misLugares = user.lugares;

    if (user.numLugares == 10) {
      buttonBackgroundColor = kDisabledButtonColor;
      buttonShadowColor = kTransparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    hasConnection = Provider.of<InternetStatus>(context).connected;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: kLightGreyColor,
        actionsForegroundColor: kBlackColor,
        border: Border.all(color: kTransparent),
        middle: Container(
          child: Text(
            "Lugares",
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
      body: SafeArea(
        child: Column(
          children: <Widget>[
            M2AnimatedContainer(
              height: hasConnection ? 0 : 50,
            ),
            user.numLugares == 0
                ? Expanded(child: _aunNoLayout())
                : Expanded(child: _loadedLayout()),
          ],
        ),
      ),
    );
  }

  Widget _loadedLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        M2AnimatedContainer(
          height: successContainerIsHidden ? 0 : 50,
          backgroundColor: kGreenManda2Color.withOpacity(0.85),
          text: "Cambios guardados",
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, position) {
              return _setupList(position);
            },
            itemCount: misLugares.length,
          ),
        ),
        vieneSetPlaces
            ? Container()
            : Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: M2Button(
                  title: 'Agregar lugar',
                  backgroundColor: buttonBackgroundColor,
                  shadowColor: buttonShadowColor,
                  onPressed: () {
                    _handlesNavigation();
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
            height: 100,
            imagePath: "images/noHayDirecciones.png",
            title: "No tienes lugares.",
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
              padding: EdgeInsets.only(bottom: 48),
              child: M2Button(
                title: 'Agregar lugar',
                backgroundColor: buttonBackgroundColor,
                shadowColor: buttonShadowColor,
                onPressed: _handlesNavigation,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _setupList(int position) {
    return ContainerDireccion(
      yaSeleccionado: false,
      isDeleting: false,
      isInMisDirecciones: true,
      contactoName: misLugares[position].contactoName,
      direccionCompleta:
          '${misLugares[position].direccion}, ${misLugares[position].ciudad}',
      onTap: () async {
        _handleTapOnCell(position);
      },
    );
  }

  void _handleTapOnCell(int position) {
    if (vieneSetPlaces) {
      Navigator.pop(context, misLugares[position]);
    } else {
      showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text("Editar lugar"),
              isDestructiveAction: false,
              onPressed: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => EditarDireccionFavoritos(
                      posicionLista: position,
                    ),
                  ),
                );
                if (result != null) {
                  setState(() {
                    misLugares = result as List<Lugar>;
                    successContainerIsHidden = false;
                  });
                  setState(() {});
                  Future.delayed(Duration(seconds: 3)).then((r) {
                    setState(() {
                      successContainerIsHidden = true;
                    });
                  });
                }
              },
            ),
            CupertinoActionSheetAction(
              child: Text("Eliminar lugar"),
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context);
                showAlert(
                  context: context,
                  title: "¿Eliminar lugar?",
                  body: "No podrás recuperarlo.",
                  actions: [
                    AlertAction(text: "Volver", isDefaultAction: true),
                    AlertAction(
                      text: "Eliminar",
                      isDestructiveAction: true,
                      onPressed: () {
                        _deleteDireccion(position);
                      },
                    ),
                  ],
                );
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
  }

  void _handlesNavigation() async {
    if (user.numLugares == 10) {
      showBasicAlert(
        context,
        "Límite de lugares por usuario alcanzado",
        "Sólo puedes agregar diez lugares :)",
      );
    } else {
      final result = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => NuevaDireccionFavoritos(),
        ),
      );
      if (result != null) {
        setState(() {
          misLugares = result as List<Lugar>;
          if (user.numLugares == 10) {
            buttonBackgroundColor = kDisabledButtonColor;
            buttonShadowColor = kTransparent;
          }
        });
      }
    }
  }

  void _deleteDireccion(int position) {
    setState(() {
      positionToDelete = position;
    });

    List<Lugar> misDireccionesTemp = misLugares;
    misDireccionesTemp.removeAt(position);
    List<Map<String, dynamic>> misDireccionesMapList = [];
    misDireccionesTemp.forEach((direccion) {
      misDireccionesMapList.add(
        {
          "calle": direccion.direccion,
          "barrio": direccion.barrio,
          "edificio": direccion.edificio,
          "ciudad": direccion.ciudad,
          "notas": direccion.notas,
          "contacto": {
            "name": direccion.contactoName,
            "phoneNumber": direccion.contactoPhoneNumber,
          }
        },
      );
    });

    Map<String, dynamic> userMap = {
      "numDirecciones": user.numLugares - 1,
      "direcciones": misDireccionesMapList,
    };

    print("⏳ ACTUALIZARÉ USER");
    Firestore.instance
        .document("users/${user.id}")
        .updateData(userMap)
        .then((value) {
      setState(() {
        positionToDelete = 200;
        user.numLugares = user.numLugares - 1;
        misLugares = misDireccionesTemp;
      });
      print("✔️ USER ACTUALIZADO");
    }).catchError((e) {
      setState(() {
        positionToDelete = 200;
      });
      print("💩 ERROR AL ACTUALIZAR USER: $e");
    });
  }
}
