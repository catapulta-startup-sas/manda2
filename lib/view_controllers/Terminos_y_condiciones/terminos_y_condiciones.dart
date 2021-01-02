import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';

import '../../constants.dart';

class DocumentacionLegal extends StatefulWidget {
  @override
  _DocumentacionLegalState createState() => _DocumentacionLegalState();
}

class _DocumentacionLegalState extends State<DocumentacionLegal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightGreyColor,
        appBar: CupertinoNavigationBar(
          actionsForegroundColor: kBlackColor,
          backgroundColor: kLightGreyColor,
          middle: Container(
            child: Text(
              "Documentación legal",
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                  fontSize: 17,
                  color: kBlackColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          border: Border(
            bottom: BorderSide(
              color: kTransparent,
              width: 1.0, // One physical pixel.
              style: BorderStyle.solid,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: CatapultaScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.05,
                      right: MediaQuery.of(context).size.width * 0.05,
                      top: 30),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          tyc,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Text(
                          pp,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: kBlackColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
