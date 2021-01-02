import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_cell_view.dart';
import 'package:manda2/components/m2_boton_admins.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/model/paquete_model.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';
import 'package:manda2/constants.dart';

import 'editar_paquete.dart';
import 'nuevo_paquete.dart';

List<Paquete> paquetes = [];

class Paquetes extends StatefulWidget {
  Paquetes({
    this.vieneCheckout = false,
  });
  bool vieneCheckout;

  @override
  _PaquetesState createState() {
    return _PaquetesState(
      vieneCheckout: vieneCheckout,
    );
  }
}

class _PaquetesState extends State<Paquetes> {
  /// CONTROLADOR DE SWIPE TO REFRESH · TODO: USAR, PERO NO TOCAR
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  _PaquetesState({this.vieneCheckout = false});

  List<Paquete> paquetesShown = [];
  Paquete paqueteIndividual = Paquete();

  final bool vieneCheckout;
  bool isEditing = false;
  String listoLbl = "Listo";
  String editarLbl = "";
  bool seleccionado;

  bool hayPaquetes = true;
  bool isLoadingPacks = true;

  @override
  void initState() {
    _getPaquetes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
      appBar: CupertinoNavigationBar(
        backgroundColor: kWhiteColor,
        actionsForegroundColor: kGreenManda2Color,
        border: Border(
          bottom: BorderSide(
            color: kBlackColor.withOpacity(0.2),
            width: 1.0, // One physical pixel.
            style: BorderStyle.solid,
          ),
        ),
        middle: Text(
          "Paquetes disponibles",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
        trailing: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => NuevoPaquete(),
              ),
            );
          },
          child: Icon(
            Icons.add,
            color: kGreenManda2Color,
          ),
        ),
      ),
      body: isLoadingPacks
          ? _loadingLayout()
          : SmartRefresher(
              controller: refreshController,
              onRefresh: onRefresh,
              header: WaterDropMaterialHeader(
                backgroundColor: kBlackColorOpacity,
              ),
              child: _loadedLayout(),
            ),
    );
  }

  Widget _loadingLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 22,
                    mainAxisSpacing: 22,
                    childAspectRatio: 0.72),
                itemBuilder: (context, position) {
                  return Container(
                    height: 250,
                    width: 155,
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Shimmer.fromColors(
                          baseColor: kBlackColor.withOpacity(0.5),
                          highlightColor: kBlackColor.withOpacity(0.2),
                          child: Container(
                            width: 255,
                            height: 130,
                            decoration: BoxDecoration(
                                color: kGreenManda2Color.withOpacity(0.1),
                                borderRadius: kRadiusOnlyTop),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Shimmer.fromColors(
                                    baseColor: kBlackColor.withOpacity(0.5),
                                    highlightColor:
                                        kBlackColor.withOpacity(0.2),
                                    child: Container(
                                      height: 15,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: kBlackColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                children: <Widget>[
                                  Shimmer.fromColors(
                                    baseColor: kBlackColor.withOpacity(0.5),
                                    highlightColor:
                                        kBlackColor.withOpacity(0.2),
                                    child: Container(
                                      height: 15,
                                      width: 70,
                                      decoration: BoxDecoration(
                                        color: kBlackColor.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                  );
                },
                itemCount: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadedLayout() {
    return Stack(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 120),
          child: Column(
            children: <Widget>[
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 22,
                      mainAxisSpacing: 22,
                      childAspectRatio: 0.72),
                  itemBuilder: (context, position) {
                    return GestureDetector(
                      child: M2CellView(
                        descuento: 0,
                        cantidad: paquetesShown[position].cantidad,
                        precio: paquetesShown[position].precio,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => EditarPaquete(
                              paquete: paquetesShown[position],
                              position: position,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  itemCount: paquetesShown.length,
                ),
              ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              height: 120,
              width: MediaQuery.of(context).size.width,
              color: kWhiteColor,
              child: Row(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(17, 38, 0, 0),
                        child: Container(
                          height: 20,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                "Precio unitario",
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 13,
                                    color: kBlackColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(17, 0, 0, 0),
                        child: Container(
                          height: 25,
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: FittedBox(
                              child: Text(
                                formattedMoneyValue(precioIndividual),
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: kGreenManda2Color,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 17, 0),
                        child: M2ButtonAdmin(
                          title: 'Editar',
                          width: MediaQuery.of(context).size.width * 0.4,
                          shadowColor: kTransparent,
                          backgroundColor: kWhiteColor,
                          onPressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => EditarPaquete(
                                  paquete: paqueteIndividual,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  void onRefresh() async {
    _getPaquetes();
    refreshController.refreshCompleted();
  }

  void _getPaquetes() {
    setState(() {
      isLoadingPacks = true;
    });

    print("⏳ OBTENRÉ PAQUETES");
    Firestore.instance
        .collection("paquetes")
        .orderBy("cantidad")
        .snapshots()
        .listen((querySnapshots) {
      print(
        "✔️ ${querySnapshots.documents.length} ${querySnapshots.documents.length == 1 ? "PAQUETE OBTENIDO" : "PAQUETES OBTENIDOS"}",
      );
      paquetesShown.clear();
      querySnapshots.documents.forEach((paqueteDoc) {
        if (paqueteDoc.data["cantidad"] == 1) {
          setState(() {
            paqueteIndividual = Paquete(
              id: paqueteDoc.documentID,
              cantidad: 1,
              precio: paqueteDoc.data["precio"],
            );
            precioIndividual = paqueteDoc.data["precio"];
          });
        } else {
          paquetesShown.add(
            Paquete(
              id: paqueteDoc.documentID,
              cantidad: paqueteDoc.data["cantidad"],
              precio: paqueteDoc.data["precio"],
            ),
          );
        }
      });
      setState(() {
        isLoadingPacks = false;
      });
    }).onError((e) {
      setState(() {
        isLoadingPacks = true;
      });
      print("💩 ERROR AL OBTENER PAQUETES: $e");
    });

    setState(() {
      isLoadingPacks = false;
    });
  }


}
