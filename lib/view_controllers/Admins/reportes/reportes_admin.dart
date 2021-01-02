import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:manda2/components/m2_container_configuracion.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/view_controllers/Admins/reportes/formulario_reportar_admins.dart';

class ReportesAdmin extends StatefulWidget {
  String titulo;
  ReportesAdmin({this.titulo});
  @override
  _ReportesAdminState createState() => _ReportesAdminState(titulo: titulo);
}

class _ReportesAdminState extends State<ReportesAdmin> {
  String tipoReporte = "";

  String titulo;
  _ReportesAdminState({this.titulo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          titulo == null
          ?"Reportes"
          :"Reportes $titulo",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
                fontSize: 17, color: kBlackColor, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      body: CatapultaScrollView(
        child: Container(
          color: kLightGreyColor,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              ContainerConfiguracion(
                text: 'Algo no funciona',
                onTap: () {
                  setState(() {
                    tipoReporte = "Algo no funciona";
                  });
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => FormularioReportarAdmin(
                        tipoReporte: tipoReporte,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              ContainerConfiguracion(
                text: 'Comentarios generales',
                onTap: () {
                  setState(() {
                    tipoReporte = "Comentarios generales";
                  });
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => FormularioReportarAdmin(
                        tipoReporte: tipoReporte,
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 10,
              ),
              ContainerConfiguracion(
                text: 'Problema con la calidad del servicio',
                onTap: () {
                  setState(() {
                    tipoReporte = "Problema con la calidad del servicio";
                  });
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => FormularioReportarAdmin(
                        tipoReporte: tipoReporte,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
