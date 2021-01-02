import 'package:flutter/cupertino.dart';
import 'package:manda2/internet_connection.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Manda2SinInternet extends StatefulWidget {
  @override
  _Manda2SinInternetState createState() => _Manda2SinInternetState();
}

class _Manda2SinInternetState extends State<Manda2SinInternet> {
  bool isRetrying = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.095,
                    ),
                    Text(
                      'Sin Internet',
                      style: GoogleFonts.poppins(
                          textStyle: kSinWifiTituloTextStyle),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.12,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.425,
                      width: MediaQuery.of(context).size.width * 0.77,
                      child: Image.asset('images/SinWiFi.png'),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.06,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.42,
                      height: MediaQuery.of(context).size.height * 0.06,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            height: MediaQuery.of(context).size.height * 0.03,
                            child: FittedBox(
                              child: Text(
                                'Parece que no hay ',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle: kSinWifiTextStyle),
                              ),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.42,
                            height: MediaQuery.of(context).size.height * 0.03,
                            child: FittedBox(
                              child: Text(
                                'conexión a internet',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                    textStyle: kSinWifiTextStyle),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    //@Samuel boton reintentar
                    Padding(
                      padding: EdgeInsets.only(bottom: 48),
                      child: M2Button(
                        title: "Reintentar",
                        isLoading: isRetrying,
                        onPressed: () {
                          _retryLogin(context);
                        },
                        backgroundColor: kBotonWifiColor,
                        shadowColor: kBotonWifiColor.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _retryLogin(BuildContext context) async {
    setState(() {
      isRetrying = true;
    });
    bool connected;
    while (true) {
      await Future.delayed(const Duration(seconds: 2), () async {
        connected = await checkInternet();
      });
      if (connected) {
        Navigator.pop(context);
        setState(() {
          isRetrying = false;
        });
        break;
      }
    }
  }
}
