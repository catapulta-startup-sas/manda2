import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class Diapositiva extends StatelessWidget {
  Diapositiva({
    @required this.number,
    @required this.title1,
    @required this.title2,
    @required this.title3,
    @required this.imageRoute,
    @required this.onPressed,
    @required this.width,

  });
  String number;
  String title1;
  String title2;
  String title3;
  String imageRoute;
  Function onPressed;
  double width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: CatapultaScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.053,
              child: Center(
                child: Text(
                  '$number',
                  style: GoogleFonts.poppins(
                      textStyle: kNumeroDiapositivaTextStyle
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.026,
            ),
            Container(
                height: MediaQuery.of(context).size.height * 0.131,
                width: width,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * (0.131/3),
                      width: width,
                      child: FittedBox(
                        child: Text(
                            '$title1',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: kTituloDiapositivaTextStyle
                            )
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * (0.131/3),
                      width: width,
                      child: FittedBox(
                        child: Text(
                            '$title2',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: kTituloDiapositivaTextStyle
                            )
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * (0.131/3),
                      width: width,
                      child: FittedBox(
                        child: Text(
                            '$title3',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                                textStyle: kTituloDiapositivaTextStyle
                            )
                        ),
                      ),
                    )
                  ],
                )
            ),
            Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: Image(
                            image: AssetImage(
                              '$imageRoute',
                            ),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
                Center(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                      CupertinoButton(
                        child: Container(
                            height:70,
                            width: 70,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: kWhiteColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: kBlackColorOpacity,
                                    blurRadius: 30,
                                    spreadRadius: -2,
                                    offset: Offset(0, 20),
                                  ),
                                ]),
                            child: IconTheme(
                              data: IconThemeData(
                                color: kBlackColor,
                              ),
                              child: Padding(
                                padding:  EdgeInsets.all(25),
                                child: ImageIcon(AssetImage(
                                  'images/seguir.png',
                                )),
                              ),
                            )
                        ),
                        onPressed: onPressed,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

