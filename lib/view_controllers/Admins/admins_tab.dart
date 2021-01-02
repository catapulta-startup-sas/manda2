import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alert/flutter_alert.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_admins_principal.dart';
import 'package:manda2/components/m2_bar_view.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_container_admins_stats_.dart';
import 'package:manda2/components/m2_container_mandados_admins.dart';
import 'package:manda2/components/m2_container_paquete.dart';
import 'package:manda2/components/m2_container_usuarios_admin.dart';
import 'package:manda2/components/m2_text_field_iniciar_sesion.dart';
import 'package:manda2/components/m2_title_admin.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/firebase/start_databases/get_user.dart';
import 'package:manda2/functions/first_word_from_paragraph.dart';
import 'package:manda2/functions/formatted_money_value.dart';
import 'package:manda2/functions/m2_alert.dart';
import 'package:manda2/model/paquete_model.dart';
import 'package:manda2/model/stats_model.dart';
import 'package:manda2/model/transaccion_model.dart';
import 'package:manda2/model/user_model.dart';
import 'package:manda2/view_controllers/Admins/aspirantes/lista_aspirantes.dart';
import "info_colaborador_o_comprador/info_colaborador_o_comprador.dart";
import 'package:numeral/numeral.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:http/http.dart' as http;

class AdminsTab extends StatefulWidget {
  @override
  _AdminsTabState createState() => _AdminsTabState();
}

enum SaberPage {
  ingesosSemana,
  ingresosAnio,
  compradores,
  colaboradores,
  nuevoPaquete,
  editarPaquete
}

class _AdminsTabState extends State<AdminsTab> {
  PanelController _pc = new PanelController();

  bool isExportingData = false;
  bool successExportingData = false;

  int numCompradores;
  int numColaboradores;

  int numMandadosSolicitados = 0;
  int numMandadosEntregados = 0;

  void getNumMandados() {
    Firestore.instance
        .collection("mandadosDesarrollo")
        .getDocuments()
        .then((querySnapshots) {
      numMandadosSolicitados = querySnapshots.documents.length;
    });
    Firestore.instance
        .collection("mandadosDesarrollo")
        .where("estados.isEntregado", isEqualTo: true)
        .getDocuments()
        .then((querySnapshots) {
      numMandadosEntregados = querySnapshots.documents.length;
    });
  }

  int mandadoTotal = 0;
  int mandadoSemanal = 0;
  int ingTotales = 0;
  int ingresosSemanales = 0;
  int compradores = 0;
  int domiciliarios = 0;

  /// Variables nuevo paquete
  String cantidadStringLocal;
  String precioStringLocal;
  Color btnBackgroundColor = kBlackColorOpacity;
  Color btnShadowColor = kTransparent;
  bool isLoadingBtn = false;

  /// Variables nuevo paquete
  bool isLoading;
  Paquete paqueteEditar;
  int positionEditar;
  String cantidadEditar;
  String precioEditar;
  int initialCantidad;
  int initialPrecio;

  /// Variables ingresos semanales
  List<charts.Series<Stats, String>> _seriesData;

  DateTime hoy;
  String dia;
  int ingLun;
  int ingMar;
  int ingMie;
  int ingJue;
  int ingVie;
  int ingSab;
  int ingDom;

  int ingresosSemana;
  int ingresosMandadosSemana;
  int ingresosPaquetesSemana;

  double percentAnio;

  _ingresosSemana() {
    var statsData = [
      new Stats('Dom\n\n$ingDom', ingDom),
      new Stats('Lun\n\n$ingLun', ingLun),
      new Stats('Mar\n\n$ingMar', ingMar),
      new Stats('Mié\n\n$ingMie', ingMie),
      new Stats('Jue\n\n$ingJue', ingJue),
      new Stats('Vie\n\n$ingVie', ingVie),
      new Stats('Sáb\n\n$ingSab', ingSab),
    ];
    _seriesData.add(
      charts.Series(
        domainFn: (Stats pollution, _) => pollution.diaOMes,
        measureFn: (Stats pollution, _) => pollution.ingreso,
        data: statsData,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Stats pollution, _) => (pollution.diaOMes ==
                        'Dom\n\n$ingDom' &&
                    dia == 'domingo') ||
                (pollution.diaOMes == 'Lun\n\n$ingLun' && dia == 'lunes') ||
                (pollution.diaOMes == 'Mar\n\n$ingMar' && dia == 'martes') ||
                (pollution.diaOMes == 'Mié\n\n$ingMie' && dia == 'miércoles') ||
                (pollution.diaOMes == 'Jue\n\n$ingJue' && dia == 'jueves') ||
                (pollution.diaOMes == 'Vie\n\n$ingVie' && dia == 'viernes') ||
                (pollution.diaOMes == 'Sáb\n\n$ingSab' && dia == 'sábado')
            ? charts.ColorUtil.fromDartColor(kGreenActive)
            : charts.ColorUtil.fromDartColor(kGreenInactive),
      ),
    );
  }

  /// Variables ingresos semanales
  List<charts.Series<Stats, String>> _anioData;

  String mes;
  int ingEne;
  int ingFeb;
  int ingMarz;
  int ingAbr;
  int ingMay;
  int ingJun;
  int ingJul;
  int ingAgo;
  int ingSep;
  int ingOct;
  int ingNov;
  int ingDic;

  int ingresosAnio;
  int ingresosMandadosAnio;
  int ingresosPaquetesAnio;
  double percentSemana;

  _ingresosAnio() {
    var statsData = [
      new Stats('ene\n\n\$${Numeral(ingEne)}', ingEne),
      new Stats('feb\n\n\$${Numeral(ingFeb)}', ingFeb),
      new Stats('mar\n\n\$${Numeral(ingMarz)}', ingMarz),
      new Stats('abr\n\n\$${Numeral(ingAbr)}', ingAbr),
      new Stats('may\n\n\$${Numeral(ingMay)}', ingMay),
      new Stats('jun\n\n\$${Numeral(ingJun)}', ingJun),
      new Stats('jul\n\n\$${Numeral(ingJul)}', ingJul),
      new Stats('ago\n\n\$${Numeral(ingAgo)}', ingAgo),
      new Stats('sep\n\n\$${Numeral(ingSep)}', ingSep),
      new Stats('oct\n\n\$${Numeral(ingOct)}', ingOct),
      new Stats('nov\n\n\$${Numeral(ingNov)}', ingNov),
      new Stats('dic\n\n\$${Numeral(ingDic)}', ingDic),
    ];
    _anioData.add(
      charts.Series(
        domainFn: (Stats pollution, _) => pollution.diaOMes,
        measureFn: (Stats pollution, _) => pollution.ingreso,
        data: statsData,
        fillPatternFn: (_, __) => charts.FillPatternType.solid,
        fillColorFn: (Stats pollution, _) =>
            (pollution.diaOMes == 'ene\n\n\$${Numeral(ingEne)}' &&
                        mes == '1') ||
                    (pollution.diaOMes == 'feb\n\n\$${Numeral(ingFeb)}' &&
                        mes == '2') ||
                    (pollution.diaOMes == 'mar\n\n\$${Numeral(ingMarz)}' &&
                        mes == '3') ||
                    (pollution.diaOMes == 'abr\n\n\$${Numeral(ingAbr)}' &&
                        mes == '4') ||
                    (pollution.diaOMes == 'may\n\n\$${Numeral(ingMay)}' &&
                        mes == '5') ||
                    (pollution.diaOMes == 'jun\n\n\$${Numeral(ingJun)}' &&
                        mes == '6') ||
                    (pollution.diaOMes == 'jul\n\n\$${Numeral(ingJul)}' &&
                        mes == '7') ||
                    (pollution.diaOMes == 'ago\n\n\$${Numeral(ingAgo)}' &&
                        mes == '8') ||
                    (pollution.diaOMes == 'sep\n\n\$${Numeral(ingSep)}' &&
                        mes == '9') ||
                    (pollution.diaOMes == 'oct\n\n\$${Numeral(ingOct)}' &&
                        mes == '10') ||
                    (pollution.diaOMes == 'nov\n\n\$${Numeral(ingNov)}' &&
                        mes == '11') ||
                    (pollution.diaOMes == 'dic\n\n\$${Numeral(ingDic)}' &&
                        mes == '12')
                ? charts.ColorUtil.fromDartColor(kGreenActive)
                : charts.ColorUtil.fromDartColor(kGreenInactive),
      ),
    );
  }

  ///-----------------------------------------------------------

  List<Paquete> paquetes = [Paquete(id: "AGREGAR")];

  List<User> compradoresListVisible = List();
  List<User> compradoresList = List();
  List<User> colaboradoresListVisible = List();
  List<User> colaboradoresList = List();

  void setUpVisibleUsers() {
    compradoresListVisible = compradoresList;
    colaboradoresListVisible = colaboradoresList;
  }

  void getUsers() {
    Firestore.instance.collection("users").snapshots().listen((querySnapshots) {
      setState(() {
        numCompradores = querySnapshots.documents.length;
      });
      if (querySnapshots.documents.length > 0) {
        querySnapshots.documents.forEach((userDoc) {
          compradoresList.add(
            User(
              id: userDoc.documentID,
              name: userDoc.data["name"],
              phoneNumber: userDoc.data["phoneNumber"],
              email: userDoc.data["email"],
              isBloqueado: userDoc.data["roles"]["isBloqueado"] ?? false,
              isDomi: false,
            ),
          );
        });
      }
    });
    Firestore.instance
        .collection("users")
        .where("roles.isDomi", isEqualTo: true)
        .snapshots()
        .listen((querySnapshots) {
      setState(() {
        numColaboradores = querySnapshots.documents.length;
      });
      if (querySnapshots.documents.length > 0) {
        querySnapshots.documents.forEach((userDoc) {
          colaboradoresList.add(
            User(
              id: userDoc.documentID,
              name: userDoc.data["name"],
              phoneNumber: userDoc.data["phoneNumber"],
              email: userDoc.data["email"],
              isBloqueado: userDoc.data["roles"]["isBloqueado"] ?? false,
              isDomi: true,
            ),
          );
        });
      }
    });
  }

  SaberPage saberPage;

  void _getTransacciones() {
    print("OBTENDRÉ TRANSACCIONES");
    Firestore.instance
        .collection("transacciones")
        .getDocuments()
        .then((querySnapshot) => querySnapshot.documents.isNotEmpty
            ? querySnapshot.documents.forEach((tDoc) {
                setState(() {
                  transacciones.add(
                    Transaccion(
                      id: tDoc.documentID,
                      userId: tDoc.data["userId"],
                      transaccionType: tDoc.data["concepto"] == "paquetes"
                          ? TransaccionType.paquetes
                          : tDoc.data["concepto"] == "tarjeta"
                              ? TransaccionType.tarjeta
                              : TransaccionType.efectivo,
                      valor: tDoc.data["valor"],
                      created: DateTime.fromMillisecondsSinceEpoch(
                          tDoc.data["created"]),
                    ),
                  );
                });
              })
            : print("0 TRANSACCIONES"))
        .catchError((e) {
      print("ERROR AL OBTENER TRANSACCIONES: $e");
    });
  }

  List<Transaccion> transacciones = [];

  /// SEMANAL

  int _ingresosEfPresentWeek() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.efectivo &&
        t.created.isAfter((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 6))) &&
        t.created.isBefore((DateTime(now.year, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosEfPastWeek() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.efectivo &&
        t.created.isAfter((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 12))) &&
        t.created.isBefore((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 7))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosTkPresentWeek() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.tarjeta &&
        t.created.isAfter((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 6))) &&
        t.created.isBefore((DateTime(now.year, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosTkPastWeek() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.tarjeta &&
        t.created.isAfter((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 12))) &&
        t.created.isBefore((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 7))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosErPresentWeek() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.paquetes &&
        t.created.isAfter((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 6))) &&
        t.created.isBefore((DateTime(now.year, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosErPastWeek() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.paquetes &&
        t.created.isAfter((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 12))) &&
        t.created.isBefore((DateTime(now.year, now.month, now.day))
            .subtract(Duration(days: 7))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosPresentWeek() {
    return _ingresosEfPresentWeek() +
        _ingresosTkPresentWeek() +
        _ingresosErPresentWeek();
  }

  int _ingresosPastWeek() {
    return _ingresosEfPastWeek() +
        _ingresosTkPastWeek() +
        _ingresosErPastWeek();
  }

  double _cambioIngresosWeek() {
    if (_ingresosPastWeek() == 0) {
      return null;
    } else if (_ingresosPresentWeek() == 0) {
      return -100.0;
    } else {
      return ((_ingresosPresentWeek() - _ingresosPastWeek()) /
                  _ingresosPastWeek() *
                  1000)
              .round() /
          10;
    }
  }

  /// ANUAL

  int _ingresosEfPresentYear() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.efectivo &&
        t.created.isAfter((DateTime(now.year - 1, now.month - 1, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosEfPastYear() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.efectivo &&
        t.created.isAfter((DateTime(now.year - 1, now.month, now.day))) &&
        t.created.isBefore((DateTime(now.year - 2, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosTkPresentYear() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.tarjeta &&
        t.created.isAfter((DateTime(now.year - 1, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosTkPastYear() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.tarjeta &&
        t.created.isAfter((DateTime(now.year - 1, now.month, now.day))) &&
        t.created.isBefore((DateTime(now.year - 2, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosErPresentYear() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.paquetes &&
        t.created.isAfter((DateTime(now.year - 1, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosErPastYear() {
    final now = DateTime.now();
    Iterable<Transaccion> filtered = transacciones.where((t) =>
        t.transaccionType == TransaccionType.paquetes &&
        t.created.isAfter((DateTime(now.year - 1, now.month, now.day))) &&
        t.created.isBefore((DateTime(now.year - 2, now.month, now.day))));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _ingresosPresentYear() {
    return _ingresosEfPresentYear() +
        _ingresosTkPresentYear() +
        _ingresosErPresentYear();
  }

  int _ingresosPastYear() {
    return _ingresosEfPastYear() +
        _ingresosTkPastYear() +
        _ingresosErPastYear();
  }

  double _cambioIngresosYear() {
    if (_ingresosPastYear() == 0) {
      return null;
    } else if (_ingresosPresentYear() == 0) {
      return -100.0;
    } else {
      return ((_ingresosPresentYear() - _ingresosPastYear()) /
                  _ingresosPastYear() *
                  1000)
              .round() /
          10;
    }
  }

  @override
  void initState() {
    super.initState();

    _getTransacciones();

    getNumMandados();
    getUsers();
    setUpVisibleUsers();

    _getPaquetes();

    ///--------------------
    _seriesData = List<charts.Series<Stats, String>>();
    _anioData = List<charts.Series<Stats, String>>();

    initializeDateFormatting();
    hoy = DateTime.now();
    dia = DateFormat.EEEE('es').format(hoy);
    mes = DateFormat.M('es').format(hoy);

    ingLun = 100;
    ingMar = 150;
    ingMie = 80;
    ingJue = 100;
    ingVie = 150;
    ingSab = 80;
    ingDom = 80;

    ///--------------------
    ingresosSemana = 1800000;
    ingresosAnio = 10100000;
    ingresosMandadosSemana = 1160000;
    ingresosMandadosAnio = 5350000;
    ingresosPaquetesSemana = 640000;
    ingresosPaquetesAnio = 2650000;

    ///--------------------
    ingEne = 0;
    ingFeb = 20000;
    ingMarz = 300000;
    ingAbr = 20000;
    ingMay = 100000;
    ingJun = 2100000;
    ingJul = 8000000;
    ingAgo = 900000;
    ingSep = 10000000;
    ingOct = 15000000;
    ingNov = 2000000;
    ingDic = 10000000;
    percentAnio = 1;
    percentSemana = -0.5;
    _ingresosSemana();
    _ingresosAnio();
  }

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      body: Scaffold(
        appBar: CupertinoNavigationBar(
          actionsForegroundColor: kBlackColor,
          border: Border(
            bottom: BorderSide(
              color: kTransparent,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
          middle: Text(
            "Dashboard ${firstWordFromParagraph(user.name)}",
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                fontSize: 17,
                color: kBlackColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          trailing: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => Aspirantes(),
                ),
              );
            },
            child: Container(
              height: 25,
              width: 25,
              child: Image.asset(
                'images/notificaciones.png',
                height: 25,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: _loadedLayout(),
        ),
      ),
      controller: _pc,
      backdropEnabled: true,
      minHeight: 0,
      isDraggable: true,
      borderRadius: kRadiusOnlyTop,
      defaultPanelState: PanelState.CLOSED,
      maxHeight: MediaQuery.of(context).size.height * 0.9,
      panel: Material(
        borderRadius: kRadiusOnlyTop,
        color: kWhiteColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Container(
                height: 5,
                width: 70,
                color: kBlackColorOpacity,
              ),
            ),
            Container(
              height: (MediaQuery.of(context).size.height * 0.9) - 18,
              child: CatapultaScrollView(
                child: saberPage == SaberPage.nuevoPaquete
                    ? _setupCrearPaquete()
                    : saberPage == SaberPage.editarPaquete
                        ? _setupEditarPaquete(paqueteEditar)
                        : saberPage == SaberPage.ingesosSemana
                            ? _estadisticasSemana()
                            : saberPage == SaberPage.ingresosAnio
                                ? _estadisticasAnio()
                                : saberPage == SaberPage.compradores ||
                                        saberPage == SaberPage.colaboradores
                                    ? _usuarios()
                                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadedLayout() {
    return CatapultaScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 9,
          ),
          TitleAdmin(
            title: 'Estadísticas',
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 280,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                /// CÍRCULO SEMANA
                ContainerEstadisticas(
                  reverse: _cambioIngresosWeek() == null
                      ? false
                      : _cambioIngresosWeek() > 0
                          ? false
                          : true,
                  percent: _cambioIngresosWeek() == null
                      ? 1.0
                      : _cambioIngresosWeek() < -100 ||
                              _cambioIngresosWeek() > 100
                          ? 1.0
                          : _cambioIngresosWeek() < 0
                              ? -_cambioIngresosWeek() / 100
                              : _cambioIngresosWeek() / 100,
                  percentText: Text(
                    _cambioIngresosWeek() == null
                        ? "NaN"
                        : _cambioIngresosWeek() < 0
                            ? "${_cambioIngresosWeek()}%"
                            : "+${_cambioIngresosWeek()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  progressColor: _cambioIngresosWeek() == null
                      ? kGreenActive
                      : _cambioIngresosWeek() < 0
                          ? kRedActive
                          : kGreenActive,
                  backgroundColor: _cambioIngresosWeek() == null
                      ? kGreenInactive
                      : _cambioIngresosWeek() < 0
                          ? kRedInActive
                          : kGreenInactive,
                  comparacion: 'vs. ${_periodPastWeek()}',
                  text: 'Ingresos\nsemana',
                  color: kRedActive,
                  onTap: () {
                    _pc.open();
                    setState(() {
                      saberPage = SaberPage.ingesosSemana;
                    });
                  },
                ),

                /// CÍRCULO AÑO
                ContainerEstadisticas(
                  reverse: _cambioIngresosYear() == null
                      ? false
                      : _cambioIngresosYear() > 0
                          ? false
                          : true,
                  percent: _cambioIngresosYear() == null
                      ? 1.0
                      : _cambioIngresosYear() < -100 ||
                              _cambioIngresosYear() > 100
                          ? 1.0
                          : _cambioIngresosYear() < 0
                              ? -_cambioIngresosYear() / 100
                              : _cambioIngresosYear() / 100,
                  percentText: Text(
                    _cambioIngresosYear() == null
                        ? "NaN"
                        : _cambioIngresosYear() < 0
                            ? "${_cambioIngresosYear()}%"
                            : "+${_cambioIngresosYear()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  progressColor: _cambioIngresosYear() == null
                      ? kGreenActive
                      : _cambioIngresosYear() < 0
                          ? kRedActive
                          : kGreenActive,
                  backgroundColor: _cambioIngresosYear() == null
                      ? kGreenInactive
                      : _cambioIngresosYear() < 0
                          ? kRedInActive
                          : kGreenInactive,
                  comparacion: 'vs. ${_periodLastYear()}',
                  text: 'Ingresos \naño',
                  color: kRedActive,
                  onTap: () {
                    _pc.open();
                    setState(() {
                      saberPage = SaberPage.ingresosAnio;
                    });
                  },
                ),
              ],
            ),
          ),
          TitleAdmin(
            title: 'Usuarios',
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ContainerUser(
                  onTap: () {
                    _pc.open();
                    setState(() {
                      saberPage = SaberPage.compradores;
                    });
                  },
                  title: numCompradores == null ? "0" : "$numCompradores",
                  subtitle: 'Compradores',
                ),
                ContainerUser(
                  onTap: () {
                    _pc.open();
                    setState(() {
                      saberPage = SaberPage.colaboradores;
                    });
                  },
                  title: numColaboradores == null ? "0" : "$numColaboradores",
                  subtitle: 'Colaboradores',
                )
              ],
            ),
          ),
          TitleAdmin(
            title: 'Mandados',
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ContainerMandados(
                  onTap: () {},
                  title: 'Solicitados',
                  numMandados: numMandadosSolicitados,
                ),
                ContainerMandados(
                  onTap: () {},
                  title: 'Entregados',
                  numMandados: numMandadosEntregados,
                )
              ],
            ),
          ),
          TitleAdmin(
            title: 'Paquetes activos',
          ),
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, position) {
                return _setupPaquetesList(paquetes[position], position);
              },
              itemCount: paquetes.length,
            ),
          ),
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                children: [
                  TitleAdmin(
                    title: 'Exportar a Sheets',
                    color: kGreenManda2Color,
                  ),
                  isExportingData
                      ? Container(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              kGreenManda2Color,
                            ),
                            strokeWidth: 3,
                          ),
                        )
                      : successExportingData
                          ? Icon(
                              Icons.check,
                              color: kGreenManda2Color,
                              size: 28,
                            )
                          : const SizedBox.shrink(),
                ],
              ),
            ),
            onTap: () {
              if (!isExportingData) {
                print("EXPORTAR");
                setState(() {
                  isExportingData = true;
                });
                String baseURL =
                    "https://script.google.com/macros/s/AKfycbyT_b4OxvxB-NWN5Lpgq4pVe1mKhva8vl5DHr1BOxfqu1VhT0eY/exec";
                String parameters =
                    "?semana=${_periodPresentWeek()}&ingresos=${_ingresosPresentWeek()}&compradores=$numCompradores&colaboradores=$numColaboradores&solicitados=$numMandadosSolicitados&entregados=$numMandadosEntregados";
                String url = "$baseURL$parameters";
                http.get(url).then((response) {
                  setState(() {
                    isExportingData = false;
                  });
                  print("RESPONSE: ${response.body}");
                  if (jsonDecode(response.body)["status"] == "SUCCESS") {
                    setState(() {
                      successExportingData = true;
                    });
                    Future.delayed(Duration(seconds: 5)).then((value) {
                      setState(() {
                        successExportingData = false;
                      });
                    });
                  } else {
                    showBasicAlert(
                      context,
                      "Hubo un error.",
                      "Por favor, intenta más tarde",
                    );
                  }
                }).catchError((e) {
                  print("ERROR AL EXPORTAR A SHEETS: $e");
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _setupPaquetesList(Paquete paquete, int position) {
    if (paquete.id == "AGREGAR") {
      return GestureDetector(
        onTap: () {
          _pc.open();
          setState(() {
            btnBackgroundColor = kBlackColorOpacity;
            btnShadowColor = kBlackColorOpacity.withOpacity(0.4);
            saberPage = SaberPage.nuevoPaquete;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Container(
            height: 90,
            width: 55,
            decoration:
                BoxDecoration(borderRadius: kRadiusAll, color: kWhiteColor),
            child: Center(
              child: Image.asset(
                'images/+.png',
                color: kBlackColor,
                height: 15,
              ),
            ),
          ),
        ),
      );
    } else {
      return ContainerPaquete(
        onTap: () {
          _pc.open();
          setState(() {
            btnBackgroundColor = kBlackColorOpacity;
            btnShadowColor = kBlackColorOpacity.withOpacity(0.4);
            saberPage = SaberPage.editarPaquete;
            positionEditar = position;
            paqueteEditar = paquetes[position];
            initialCantidad = paquetes[position].cantidad;
            initialPrecio = paquetes[position].precio;
          });
        },
        precio: paquete.precio,
        cantidad: paquete.cantidad,
      );
    }
  }

  Widget _setupListUsers(User user) {
    return GestureDetector(
        onTap: () {
          _pc.open();
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => InfoColaboradorOComprador(
                user: user,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 56,
            decoration: BoxDecoration(
                borderRadius: kRadiusAdmins, color: kLightGreyColor),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "${user.name}",
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 14, color: kBlackColor)),
                  ),
                  Expanded(child: Container()),
                  Image.asset(
                    'images/adelante.png',
                    height: 12,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  ///::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  String _getWeekday(int daysToAdd) {
    int weekday = DateTime.now().weekday + daysToAdd;
    if (weekday < 1) weekday += 7;
    switch (weekday) {
      case 1:
        return "Lun";
      case 2:
        return "Mar";
      case 3:
        return "Mié";
      case 4:
        return "Jue";
      case 5:
        return "Vie";
      case 6:
        return "Sáb";
      case 7:
        return "Dom";
    }
  }

  String _getMonth(int monthsToAdd) {
    int month = DateTime.now().month + monthsToAdd;
    if (month < 1) month += 12;
    switch (month) {
      case 1:
        return "Ene";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Abr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Ago";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dic";
    }
  }

  String _periodPresentWeek() {
    String fDayString =
        DateTime.now().subtract(Duration(days: 1)).day.toString();
    String fMonthString = DateTime.now().month == 1
        ? "ene."
        : DateTime.now().month == 2
            ? "feb."
            : DateTime.now().month == 3
                ? "mar."
                : DateTime.now().month == 4
                    ? "abr."
                    : DateTime.now().month == 5
                        ? "may."
                        : DateTime.now().month == 6
                            ? "jun."
                            : DateTime.now().month == 7
                                ? "jul."
                                : DateTime.now().month == 8
                                    ? "ago."
                                    : DateTime.now().month == 9
                                        ? "sep."
                                        : DateTime.now().month == 10
                                            ? "oct."
                                            : DateTime.now().month == 11
                                                ? "nov."
                                                : "dic.";
    String iDayString =
        DateTime.now().subtract(Duration(days: 6)).day.toString();
    String iMonthString = DateTime.now().subtract(Duration(days: 6)).month == 1
        ? "ene."
        : DateTime.now().month == 2
            ? "feb."
            : DateTime.now().month == 3
                ? "mar."
                : DateTime.now().month == 4
                    ? "abr."
                    : DateTime.now().month == 5
                        ? "may."
                        : DateTime.now().month == 6
                            ? "jun."
                            : DateTime.now().month == 7
                                ? "jul."
                                : DateTime.now().month == 8
                                    ? "ago."
                                    : DateTime.now().month == 9
                                        ? "sep."
                                        : DateTime.now().month == 10
                                            ? "oct."
                                            : DateTime.now().month == 11
                                                ? "nov."
                                                : "dic.";
    return "del $iDayString de $iMonthString al $fDayString de $fMonthString";
  }

  String _periodPastWeek() {
    String fDayString =
        DateTime.now().subtract(Duration(days: 7)).day.toString();
    String fMonthString = DateTime.now().subtract(Duration(days: 7)).month == 1
        ? "ene."
        : DateTime.now().month == 2
            ? "feb."
            : DateTime.now().month == 3
                ? "mar."
                : DateTime.now().month == 4
                    ? "abr."
                    : DateTime.now().month == 5
                        ? "may."
                        : DateTime.now().month == 6
                            ? "jun."
                            : DateTime.now().month == 7
                                ? "jul."
                                : DateTime.now().month == 8
                                    ? "ago."
                                    : DateTime.now().month == 9
                                        ? "sep."
                                        : DateTime.now().month == 10
                                            ? "oct."
                                            : DateTime.now().month == 11
                                                ? "nov."
                                                : "dic.";
    String iDayString =
        DateTime.now().subtract(Duration(days: 12)).day.toString();
    String iMonthString = DateTime.now().subtract(Duration(days: 12)).month == 1
        ? "ene."
        : DateTime.now().month == 2
            ? "feb."
            : DateTime.now().month == 3
                ? "mar."
                : DateTime.now().month == 4
                    ? "abr."
                    : DateTime.now().month == 5
                        ? "may."
                        : DateTime.now().month == 6
                            ? "jun."
                            : DateTime.now().month == 7
                                ? "jul."
                                : DateTime.now().month == 8
                                    ? "ago."
                                    : DateTime.now().month == 9
                                        ? "sep."
                                        : DateTime.now().month == 10
                                            ? "oct."
                                            : DateTime.now().month == 11
                                                ? "nov."
                                                : "dic.";
    return "$iDayString $iMonthString ~ $fDayString $fMonthString";
  }

  String _periodLastYear() {
    return "último año";
  }

  /// SEMANA

  int _getTotalTransactionValueInPresentWeek(int daysToAdd) {
    DateTime initialDate = DateTime(
      DateTime.now().subtract(Duration(days: daysToAdd.abs())).year,
      DateTime.now().subtract(Duration(days: daysToAdd.abs())).month,
      DateTime.now().subtract(Duration(days: daysToAdd.abs())).day,
    );

    DateTime finalDate = DateTime(
      DateTime.now().subtract(Duration(days: daysToAdd.abs() - 1)).year,
      DateTime.now().subtract(Duration(days: daysToAdd.abs() - 1)).month,
      DateTime.now().subtract(Duration(days: daysToAdd.abs() - 1)).day,
    );

    Iterable<Transaccion> filtered = transacciones.where(
        (t) => t.created.isAfter(initialDate) && t.created.isBefore(finalDate));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _getMaxTransactionValueInPresentWeek() {
    List<int> values = [
      _getTotalTransactionValueInPresentWeek(-6),
      _getTotalTransactionValueInPresentWeek(-5),
      _getTotalTransactionValueInPresentWeek(-4),
      _getTotalTransactionValueInPresentWeek(-3),
      _getTotalTransactionValueInPresentWeek(-2),
      _getTotalTransactionValueInPresentWeek(-1),
    ];
    return values.reduce((a, b) => a > b ? a : b);
  }

  int _getDailyAverageTransactionValueInPresentWeek() {
    List<int> values = [
      _getTotalTransactionValueInPresentWeek(-6),
      _getTotalTransactionValueInPresentWeek(-5),
      _getTotalTransactionValueInPresentWeek(-4),
      _getTotalTransactionValueInPresentWeek(-3),
      _getTotalTransactionValueInPresentWeek(-2),
      _getTotalTransactionValueInPresentWeek(-1),
    ];
    return values.reduce((a, b) => a + b) ~/ 6;
  }

  /// AÑO

  int _getTotalTransactionValueInPresentYear(int monthsToAdd) {
    DateTime initialDate = DateTime(
      DateTime.now().year,
      DateTime.now().month - monthsToAdd.abs(),
      1,
    );

    DateTime finalDate = DateTime(
      DateTime.now().year,
      DateTime.now().month - monthsToAdd.abs() + 1,
      0,
    );

    Iterable<Transaccion> filtered = transacciones.where(
        (t) => t.created.isAfter(initialDate) && t.created.isBefore(finalDate));
    if (filtered.isNotEmpty) {
      return filtered.map((t) => t.valor).reduce((a, b) => a + b);
    }
    return 0;
  }

  int _getMaxTransactionValueInPresentYear() {
    List<int> values = [
      _getTotalTransactionValueInPresentYear(-6),
      _getTotalTransactionValueInPresentYear(-5),
      _getTotalTransactionValueInPresentYear(-4),
      _getTotalTransactionValueInPresentYear(-3),
      _getTotalTransactionValueInPresentYear(-2),
      _getTotalTransactionValueInPresentYear(-1),
    ];
    return values.reduce((a, b) => a > b ? a : b);
  }

  ///::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

  /// PANEL ESTADÍSTICAS SEMANALES
  Widget _estadisticasSemana() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 80,
                  lineWidth: 5.0,
                  animation: true,
                  reverse: _cambioIngresosWeek() == null
                      ? false
                      : _cambioIngresosWeek() > 0
                          ? false
                          : true,
                  percent: _cambioIngresosWeek() == null
                      ? 1.0
                      : _cambioIngresosWeek() < -100 ||
                              _cambioIngresosWeek() > 100
                          ? 1.0
                          : _cambioIngresosWeek() < 0
                              ? -_cambioIngresosWeek() / 100
                              : _cambioIngresosWeek() / 100,
                  progressColor: _cambioIngresosWeek() == null
                      ? kGreenActive
                      : _cambioIngresosWeek() < 0
                          ? kRedActive
                          : kGreenActive,
                  backgroundColor: _cambioIngresosWeek() == null
                      ? kGreenInactive
                      : _cambioIngresosWeek() < 0
                          ? kRedInActive
                          : kGreenInactive,
                  center: Text(
                    _cambioIngresosWeek() == null
                        ? "NaN"
                        : _cambioIngresosWeek() < 0
                            ? "${_cambioIngresosWeek()}%"
                            : "+${_cambioIngresosWeek()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos semana',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: kBlackColor.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '\$${Numeral(_ingresosPresentWeek())} COP',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: kBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'vs. ${_periodPastWeek()}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: kBlackColor.withOpacity(0.5),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 110,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ContainerStats(
                  title: 'Efectivo',
                  ingreso: _ingresosEfPresentWeek(),
                ),
                ContainerStats(
                  title: 'Tarjeta',
                  ingreso: _ingresosTkPresentWeek(),
                ),
                ContainerStats(
                  title: 'Paquetes',
                  ingreso: _ingresosErPresentWeek(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Alcance semana',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 22,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: kRadiusAll,
              boxShadow: [
                BoxShadow(
                  color: kBlackColorOpacity.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  formattedMoneyValue(_ingresosPresentWeek()),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: kBlackColor,
                      fontSize: 22,
                    ),
                  ),
                ),
                Text(
                  'Ingresos obtenidos ${_periodPresentWeek()}',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: kBlackColor.withOpacity(0.5),
                      fontSize: 11,
                    ),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    M2Bar(
                      value: _getTotalTransactionValueInPresentWeek(-6),
                      maxValue: _getMaxTransactionValueInPresentWeek(),
                      label: _getWeekday(-6),
                    ),
                    M2Bar(
                      value: _getTotalTransactionValueInPresentWeek(-5),
                      maxValue: _getMaxTransactionValueInPresentWeek(),
                      label: _getWeekday(-5),
                    ),
                    M2Bar(
                      value: _getTotalTransactionValueInPresentWeek(-4),
                      maxValue: _getMaxTransactionValueInPresentWeek(),
                      label: _getWeekday(-4),
                    ),
                    M2Bar(
                      value: _getTotalTransactionValueInPresentWeek(-3),
                      maxValue: _getMaxTransactionValueInPresentWeek(),
                      label: _getWeekday(-3),
                    ),
                    M2Bar(
                      value: _getTotalTransactionValueInPresentWeek(-2),
                      maxValue: _getMaxTransactionValueInPresentWeek(),
                      label: _getWeekday(-2),
                    ),
                    M2Bar(
                      value: _getTotalTransactionValueInPresentWeek(-1),
                      maxValue: _getMaxTransactionValueInPresentWeek(),
                      label: _getWeekday(-1),
                      isActive: true,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 8),
            child: Text(
              'Promedio de ingresos diarios obtenidos ${_periodPresentWeek()}',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: kBlackColor.withOpacity(0.5),
                  fontSize: 15,
                ),
              ),
            ),
          ),
          Text(
            '${formattedMoneyValue(_getDailyAverageTransactionValueInPresentWeek())}/día',
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: kBlackColor,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// PANEL ESTADÍSTICAS MENSUALES
  Widget _estadisticasAnio() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Row(
              children: [
                CircularPercentIndicator(
                  radius: 80,
                  lineWidth: 5.0,
                  animation: true,
                  reverse: _cambioIngresosYear() == null
                      ? false
                      : _cambioIngresosYear() > 0
                          ? false
                          : true,
                  percent: _cambioIngresosYear() == null
                      ? 1.0
                      : _cambioIngresosYear() < -100 ||
                              _cambioIngresosYear() > 100
                          ? 1.0
                          : _cambioIngresosYear() < 0
                              ? -_cambioIngresosYear() / 100
                              : _cambioIngresosYear() / 100,
                  center: Text(
                    _cambioIngresosYear() == null
                        ? "NaN"
                        : _cambioIngresosYear() < 0
                            ? "${_cambioIngresosYear()}%"
                            : "+${_cambioIngresosYear()}%",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  progressColor: _cambioIngresosYear() == null
                      ? kGreenActive
                      : _cambioIngresosYear() < 0
                          ? kRedActive
                          : kGreenActive,
                  backgroundColor: _cambioIngresosYear() == null
                      ? kGreenInactive
                      : _cambioIngresosYear() < 0
                          ? kRedInActive
                          : kGreenInactive,
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresos año',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 15,
                          color: kBlackColor.withOpacity(0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      '\$${Numeral(_ingresosPresentYear())} COP',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: kBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'vs. ${_periodLastYear()}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          fontSize: 13,
                          color: kBlackColor.withOpacity(0.5),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            height: 110,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ContainerStats(
                  title: 'Efectivo',
                  ingreso: _ingresosEfPresentYear(),
                ),
                ContainerStats(
                  title: 'Tarjeta',
                  ingreso: _ingresosTkPresentYear(),
                ),
                ContainerStats(
                  title: 'Paquetes',
                  ingreso: _ingresosErPresentYear(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              'Alcance año',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 22,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: kRadiusAll,
                  boxShadow: [
                    BoxShadow(
                      color: kBlackColorOpacity.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      formattedMoneyValue(_ingresosPresentYear()),
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: kBlackColor,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Text(
                      'Ingresos obtenidos el ${_periodLastYear()}',
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: kBlackColor.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        M2Bar(
                          value: _getTotalTransactionValueInPresentYear(-6),
                          maxValue: _getMaxTransactionValueInPresentYear(),
                          label: _getMonth(-6),
                        ),
                        M2Bar(
                          value: _getTotalTransactionValueInPresentYear(-5),
                          maxValue: _getMaxTransactionValueInPresentYear(),
                          label: _getMonth(-5),
                        ),
                        M2Bar(
                          value: _getTotalTransactionValueInPresentYear(-4),
                          maxValue: _getMaxTransactionValueInPresentYear(),
                          label: _getMonth(-4),
                        ),
                        M2Bar(
                          value: _getTotalTransactionValueInPresentYear(-3),
                          maxValue: _getMaxTransactionValueInPresentYear(),
                          label: _getMonth(-3),
                        ),
                        M2Bar(
                          value: _getTotalTransactionValueInPresentYear(-2),
                          maxValue: _getMaxTransactionValueInPresentYear(),
                          label: _getMonth(-2),
                        ),
                        M2Bar(
                          value: _getTotalTransactionValueInPresentYear(-1),
                          maxValue: _getMaxTransactionValueInPresentYear(),
                          label: _getMonth(-1),
                          isActive: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _usuarios() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              saberPage == SaberPage.compradores
                  ? 'Compradores '
                  : 'Colaboradores',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: kBlackColor.withOpacity(0.5)),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              saberPage == SaberPage.compradores
                  ? '$numCompradores'
                  : '$numColaboradores',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: kBlackColor),
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 56,
              decoration: BoxDecoration(
                  borderRadius: kRadiusAll,
                  boxShadow: [
                    BoxShadow(
                      color: kBlackColor.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 6,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: kWhiteColor),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                    child: Icon(
                      Icons.search,
                      color: kBlackColorOpacity.withOpacity(0.3),
                      size: 30.0,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: TextFormField(
                        textCapitalization: TextCapitalization.words,
                        keyboardAppearance: Brightness.light,
                        style: GoogleFonts.poppins(
                            textStyle: kTextFormFieldTextStyle),
                        textAlign: TextAlign.start,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Buscar por nombre',
                          hintStyle: GoogleFonts.poppins(
                              textStyle: kTextFormFieldHintTextStyle),
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (text) {
                          setState(() {
                            compradoresListVisible = compradoresList
                                .where((user) => user.name
                                    .toLowerCase()
                                    .replaceAll(" ", "")
                                    .replaceAll("á", "a")
                                    .replaceAll("é", "e")
                                    .replaceAll("í", "i")
                                    .replaceAll("ó", "o")
                                    .replaceAll("ú", "u")
                                    .contains(text
                                        .toLowerCase()
                                        .replaceAll(" ", "")
                                        .replaceAll("á", "a")
                                        .replaceAll("é", "e")
                                        .replaceAll("í", "i")
                                        .replaceAll("ó", "o")
                                        .replaceAll("ú", "u")))
                                .toList();
                            colaboradoresListVisible = colaboradoresList
                                .where((user) => user.name
                                    .toLowerCase()
                                    .replaceAll(" ", "")
                                    .replaceAll("á", "a")
                                    .replaceAll("é", "e")
                                    .replaceAll("í", "i")
                                    .replaceAll("ó", "o")
                                    .replaceAll("ú", "u")
                                    .contains(text
                                        .toLowerCase()
                                        .replaceAll(" ", "")
                                        .replaceAll("á", "a")
                                        .replaceAll("é", "e")
                                        .replaceAll("í", "i")
                                        .replaceAll("ó", "o")
                                        .replaceAll("ú", "u")))
                                .toList();
                          });
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              saberPage == SaberPage.compradores
                  ? "${compradoresListVisible.length} ${compradoresListVisible.length == 1 ? "resultado" : "resultados"}"
                  : "${colaboradoresListVisible.length} ${colaboradoresListVisible.length == 1 ? "resultado" : "resultados"}",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(color: kBlackColor),
                fontSize: 13,
                fontWeight: FontWeight.w300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.55,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemBuilder: (context, position) {
                    return _setupListUsers(saberPage == SaberPage.compradores
                        ? compradoresListVisible[position]
                        : colaboradoresListVisible[position]);
                  },
                  itemCount: saberPage == SaberPage.compradores
                      ? compradoresListVisible.length
                      : colaboradoresListVisible.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _setupCrearPaquete() {
    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Crear paquete',
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  color: kBlackColor.withOpacity(0.5),
                ),
                fontSize: 15,
              ),
            ),
            SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: kRadiusAll,
                boxShadow: [
                  BoxShadow(
                    color: kBlackColorOpacity.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 150,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: kRadiusOnlyTop,
                          image: DecorationImage(
                              image: AssetImage(
                                'images/paquetesAdmins.png',
                              ),
                              fit: BoxFit.fitHeight),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Center(
                            child:
                                Image.asset("images/ticket.png", height: 90)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      'Cantidad de envíos',
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 15, color: kBlackColor)),
                    ),
                  ),
                  M2TextFieldIniciarSesion(
                    imageRoute: 'images/id.png',
                    keyboardType: TextInputType.number,
                    iconColor: kBlackColor,
                    height: 18,
                    onChanged: (text) {
                      cantidadStringLocal = text;
                      if (cantidadStringLocal != "" &&
                          cantidadStringLocal != null &&
                          precioStringLocal != null &&
                          precioStringLocal != "") {
                        setState(() {
                          btnBackgroundColor = kGreenManda2Color;
                          btnShadowColor = kGreenManda2Color.withOpacity(0.4);
                        });
                      } else {
                        setState(() {
                          btnBackgroundColor = kBlackColorOpacity;
                          btnShadowColor = kTransparent;
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: Text(
                      'Precio total',
                      style: GoogleFonts.poppins(
                          textStyle:
                              TextStyle(fontSize: 15, color: kBlackColor)),
                    ),
                  ),
                  M2TextFieldIniciarSesion(
                    imageRoute: 'images/precio.png',
                    keyboardType: TextInputType.number,
                    iconColor: kBlackColor,
                    onChanged: (text) {
                      precioStringLocal = text;
                      if (cantidadStringLocal != "" &&
                          cantidadStringLocal != null &&
                          precioStringLocal != null &&
                          precioStringLocal != "") {
                        setState(() {
                          btnBackgroundColor = kGreenManda2Color;
                          btnShadowColor = kGreenManda2Color.withOpacity(0.4);
                        });
                      } else {
                        setState(() {
                          btnBackgroundColor = kBlackColorOpacity;
                          btnShadowColor = kTransparent;
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 30, 20, 17),
                    child: M2Button(
                      width: MediaQuery.of(context).size.width - 34,
                      isLoading: isLoadingBtn,
                      title: 'Crear',
                      backgroundColor: btnBackgroundColor,
                      shadowColor: btnShadowColor,
                      onPressed: _createPaquete,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _setupEditarPaquete(Paquete paquete) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Editar paquete',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        color: kBlackColor.withOpacity(0.5),
                      ),
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    paquete.cantidad == 1
                        ? 'x${paquete.cantidad} envío'
                        : 'x${paquete.cantidad} envíos',
                    style: GoogleFonts.poppins(
                        textStyle: TextStyle(color: kBlackColor), fontSize: 20),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              paquete.cantidad == 1
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        showAlert(
                          context: context,
                          title: "¿Eliminar paquete?",
                          body:
                              "Dejará de estar dipsonible en la tienda de paquetes.",
                          actions: [
                            AlertAction(
                              text: "Volver",
                              onPressed: () {},
                            ),
                            AlertAction(
                              text: "Eliminar",
                              isDestructiveAction: true,
                              onPressed: () {
                                _deletePaqueteDB(paquete);
                              },
                            ),
                          ],
                        );
                      },
                      child: Text(
                        'Eliminar',
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: kRedActive, fontSize: 15),
                        ),
                      ),
                    )
            ],
          ),
          SizedBox(height: 30),
          Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              color: kWhiteColor,
              borderRadius: kRadiusAll,
              boxShadow: [
                BoxShadow(
                  color: kBlackColorOpacity.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: kRadiusOnlyTop,
                        image: DecorationImage(
                          image: AssetImage(
                            'images/paquetesAdmins.png',
                          ),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Center(
                          child: Image.asset("images/ticket.png", height: 90)),
                    )
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                paquete.cantidad == 1
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 17),
                        child: Text(
                          'Cantidad de envíos',
                          style: GoogleFonts.poppins(
                              textStyle:
                                  TextStyle(fontSize: 15, color: kBlackColor)),
                        ),
                      ),
                paquete.cantidad == 1
                    ? const SizedBox.shrink()
                    : M2TextFieldIniciarSesion(
                        imageRoute: 'images/id.png',
                        placeholder: '${paquete.cantidad}',
                        keyboardType: TextInputType.number,
                        iconColor: kBlackColor,
                        height: 18,
                        onChanged: (text) {
                          cantidadEditar = text;

                          if ((cantidadEditar == null ||
                                  cantidadEditar == "" ||
                                  cantidadEditar == "1") &&
                              (precioEditar == null || precioEditar == "")) {
                            setState(() {
                              btnBackgroundColor = kBlackColorOpacity;
                              btnShadowColor =
                                  kBlackColorOpacity.withOpacity(0.4);
                            });
                          } else {
                            setState(() {
                              btnBackgroundColor = kGreenManda2Color;
                              btnShadowColor =
                                  kGreenManda2Color.withOpacity(0.4);
                            });
                          }
                        },
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Text(
                    'Precio total',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 15,
                        color: kBlackColor,
                      ),
                    ),
                  ),
                ),
                M2TextFieldIniciarSesion(
                  placeholder: formattedMoneyValue(initialPrecio),
                  imageRoute: 'images/precio.png',
                  keyboardType: TextInputType.number,
                  iconColor: kBlackColor,
                  onChanged: (text) {
                    precioEditar = text;

                    if ((cantidadEditar == null ||
                            cantidadEditar == "" ||
                            cantidadEditar == "1") &&
                        (precioEditar == null || precioEditar == "")) {
                      setState(() {
                        btnBackgroundColor = kBlackColorOpacity;
                        btnShadowColor = kBlackColorOpacity.withOpacity(0.4);
                      });
                    } else {
                      setState(() {
                        btnBackgroundColor = kGreenManda2Color;
                        btnShadowColor = kGreenManda2Color.withOpacity(0.4);
                      });
                    }
                  },
                ),
                Expanded(child: Container()),
                Padding(
                  padding: EdgeInsets.fromLTRB(17, 30, 20, 17),
                  child: M2Button(
                    width: MediaQuery.of(context).size.width - 34,
                    isLoading: isLoadingBtn,
                    title: 'Actualizar',
                    backgroundColor: btnBackgroundColor,
                    shadowColor: btnShadowColor,
                    onPressed: () {
                      print("AAAA");
                      if (btnBackgroundColor == kGreenManda2Color) {
                        print("BBBB");
                        _updatePaquetesDB(paquete);
                      } else {
                        if (cantidadEditar == "1") {
                          showBasicAlert(
                            context,
                            "Ya hay un paquete de 1 unidad",
                            "Por favor, determina otra cantidad de envíos para este paquete o edita el precio del paquete de 1 unidad.",
                          );
                        } else {
                          showBasicAlert(
                            context,
                            "No se puede actualizar",
                            "Por favor, edita el paquete para continuar.",
                          );
                        }
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void _getPaquetes() {
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
      paquetes.add(Paquete(id: "AGREGAR"));
      querySnapshots.documents.forEach((paqueteDoc) {
        paquetes.add(
          Paquete(
            id: paqueteDoc.documentID,
            cantidad: paqueteDoc.data["cantidad"],
            precio: paqueteDoc.data["precio"],
          ),
        );
      });
    }).onError((e) {
      print("💩 ERROR AL OBTENER PAQUETES: $e");
    });
  }

  void _createPaquete() {
    setState(() {
      isLoadingBtn = true;
    });
    Map<String, dynamic> paqueteMap = {
      "cantidad": int.parse(cantidadStringLocal),
      "precio": int.parse(precioStringLocal),
    };
    print("CREARÉ PAQUETE");
    Firestore.instance.collection("paquetes").add(paqueteMap).then((r) {
      print("PAQUETE CREADO");
      setState(() {
        isLoadingBtn = false;
        _pc.close();
      });
    }).catchError((e) {
      showBasicAlert(
        context,
        "Hubo un error.",
        "Por favor, intenta más tarde.",
      );
      setState(() {
        isLoadingBtn = false;
      });
      print("ERROR AL CREAR PAQUETE: $e");
    });
  }

  void _deletePaqueteDB(Paquete paquete) async {
    print("ELIMINARÉ PAQUETE");
    Firestore.instance.document("paquetes/${paquete.id}").delete().then((r) {
      print("PAQUETE ELIMINADO");
      setState(() {
        isLoadingBtn = false;
        _pc.close();
      });
    }).catchError((e) {
      showBasicAlert(
          context, "Hubo un error.", "Por favor, intenta más tarde.");
      print("ERROR AL ELIMINAR PAQUETE: $e");
    });
  }

  void _updatePaquetesDB(Paquete paquete) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> paqueteMap = {
      "cantidad": int.tryParse(cantidadEditar ?? "${paquete.cantidad}") ??
          paquete.cantidad,
      "precio":
          int.tryParse(precioEditar ?? "${paquete.precio}") ?? paquete.precio,
    };

    print("ACTUALIZARÉ PAQUETE");
    Firestore.instance
        .document("paquetes/${paquete.id}")
        .updateData(paqueteMap)
        .then((r) {
      print("PAQUETE ACTUALIZADO");
      setState(() {
        isLoading = false;
        cantidadEditar = null;
        precioEditar = null;
        _pc.close();
      });
    }).catchError((e) {
      showBasicAlert(
          context, "Hubo un error.", "Por favor, intenta más tarde.");
      print("ERROR AL ACTUALIZAR PAQUETE: $e");
    });
  }
}

enum Temporalidad {
  dia,
  mes,
}
