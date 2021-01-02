import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/m2_cell_view.dart';
import 'package:manda2/components/m2_aunno.dart';
import 'package:manda2/components/m2_sin_conexion_container.dart';
import 'package:manda2/firebase/start_databases/get_constantes.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/model/paquete_model.dart';
import 'package:manda2/view_controllers/Perfil/Envios_redimibles/detalle_compra_envios.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/internet_connection.dart';

List<Paquete> paquetes = [];

class Redimibles extends StatefulWidget {
  Redimibles({
    this.vieneCheckout = false,
  });

  bool vieneCheckout;

  @override
  _RedimiblesState createState() {
    return _RedimiblesState(
      vieneCheckout: vieneCheckout,
    );
  }
}

class _RedimiblesState extends State<Redimibles> {
  _RedimiblesState({this.vieneCheckout = false});

  final bool vieneCheckout;
  String listoLbl = "Listo";
  String editarLbl = "";
  bool seleccionado;

  bool isLoadingPacks = false;

  @override
  void initState() {
    _getPaquetes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool hasConnection = Provider.of<InternetStatus>(context).connected;
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
        middle: Text(
          "Envíos redimibles",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            M2AnimatedContainer(
              height: hasConnection ? 0 : 50,
            ),
            isLoadingPacks
                ? Expanded(child: _loadingLayout())
                : paquetes.length > 0
                    ? Expanded(child: _loadedLayout())
                    : Expanded(child: _aunNoLayout()),
          ],
        ),
      ),
    );
  }

  Widget _loadingLayout() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(18, 24, 0, 24),
                child: Text(
                  "Tienes:",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor)),
                ),
              ),
              Expanded(
                child: Container(),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(18, 24, 18, 24),
                child: Text(
                  user.numEnvios == 1
                      ? "${user.numEnvios} envío"
                      : "${user.numEnvios} envíos",
                  style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: kBlackColor)),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.0, right: 18, top: 5, bottom: 23),
            child: Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: kBlackColorOpacity,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
            child: Text(
              "Comprar paquetes",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: kBlackColor)),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 18),
            child: Text(
              "Selecciona un paquete",
              style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: kBlackColor.withOpacity(0.5),
              )),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 22,
                  mainAxisSpacing: 22,
                  childAspectRatio: 0.72,
                ),
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
                itemCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loadedLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(18, 24, 0, 24),
              child: Text(
                "Tienes:",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(18, 24, 18, 24),
              child: Text(
                "${user.numEnvios} envíos",
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kBlackColor,
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(18, 0, 0, 0),
          child: Text(
            "Comprar paquetes",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kBlackColor)),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 18),
          child: Text(
            "Selecciona un paquete",
            style: GoogleFonts.poppins(
                textStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: kBlackColor.withOpacity(0.5),
            )),
          ),
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
                return GestureDetector(
                  child: M2CellView(
                    descuento: _descuento(
                        paquetes[position].precio, paquetes[position].cantidad),
                    cantidad: paquetes[position].cantidad,
                    precio: paquetes[position].precio,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DetalleCompra(
                          precio: paquetes[position].precio,
                          cantidad: paquetes[position].cantidad,
                          descuento: _descuento(paquetes[position].precio,
                              paquetes[position].cantidad),
                        ),
                      ),
                    );
                  },
                );
              },
              itemCount: paquetes.length,
            ),
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
            imagePath: "images/noEnvios.png",
            title: "No hay envíos redimibles",
            subtitle: "a la venta por ahora.",
            padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
            height: 90,
          ),
        ),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 40, 0, 40),
                  child: Text(
                    'Tienes:',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                      fontSize: 16,
                    )),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 40, 18, 40),
                  child: Text(
                    '${user.numEnvios} envios',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
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
      paquetes.clear();
      querySnapshots.documents.forEach((paqueteDoc) {
        paquetes.add(
          Paquete(
            id: paqueteDoc.documentID,
            cantidad: paqueteDoc.data["cantidad"],
            precio: paqueteDoc.data["precio"],
          ),
        );
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

  // Devuelve el descuento del paquete en decimales
  double _descuento(int precio, int cantidad) {
    return (precioIndividual * cantidad - precio) /
        (precioIndividual * cantidad);
  }
}
