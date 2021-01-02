import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/constants.dart';
import 'package:manda2/view_controllers/registro/iniciar_sesion/iniciar_sesion.dart';
import 'package:manda2/views/diapositiva.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Diapositivas extends StatefulWidget {
  @override
  _DiapositivasState createState() => _DiapositivasState();
}

class _DiapositivasState extends State<Diapositivas> {
  String title1 = "Usa tu tiempo en lo";
  String title2 = "verdaderamente";
  String title3 = "importante";
  int page = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: Diapositiva(
        number: "0$page",
        width: MediaQuery.of(context).size.width,
        title1: title1,
        title2: title2,
        title3: title3,
        imageRoute: "images/diapositiva$page.png",
        onPressed: handleNextBtn,
      ),
    );
  }

  void handleNextBtn() {
    if (page == 1) {
      setState(() {
        page = 2;
        title1 = "Cuida tu salud al";
        title2 = "quedarte en casa";
        title3 = "y pedir Manda2";
      });
    } else if (page == 2) {
      setState(() {
        page = 3;
        title1 = "Nuestra flota";
        title2 = "verde ayuda al";
        title3 = "medio ambiente";
      });
    } else if (page == 3) {
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => IniciarSesion(isHaciendoTutorial: true),
        ),
      );
      _updateIsFirstTime();
    }
  }

  void _updateIsFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isFirstTime", false);
  }
}
