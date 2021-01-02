import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class ContainerConfiguracion extends StatelessWidget {
  ContainerConfiguracion({
    @required this.text,
    this.padding,
    this.onTap,
    this.width,
    this.image,
    this.color,
    this.flecha,
    this.isLoading,
  });

  String text;
  double padding;
  double width;
  Function onTap;
  String image;
  Color color;
  bool flecha;
  bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading == null) isLoading = false;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          children: <Widget>[
            Container(
              width: 10,
              height: 50,
              color: kLightGreyColor,
            ),
            Container(
              width: 10,
              height: 50,
              color: kLightGreyColor,
            ),
            Container(
              height: 50,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '$text',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 13,
                        color: color ?? kBlackColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                color: kLightGreyColor,
              ),
            ),
            isLoading
                ? Container(
                    margin: EdgeInsets.only(right: 2),
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kBlackColorOpacity),
                      strokeWidth: 3,
                    ),
                  )
                : flecha == null
                    ? Image(
                        image: AssetImage('images/adelante.png'),
                        height: 12,
                        color: kBlackColor,
                      )
                    : Container(color: kLightGreyColor),
            Container(
              width: 10,
              height: 50,
              color: kLightGreyColor,
            ),
          ],
        ),
      ),
    );
  }
}
