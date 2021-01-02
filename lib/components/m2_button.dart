import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';

class M2Button extends StatelessWidget {
  M2Button(
      {@required this.onPressed,
      this.title,
      this.backgroundColor,
      this.shadowColor,
      this.isLoading,
      this.width});
  String title;
  Color backgroundColor;
  Color shadowColor;
  Function onPressed;
  bool isLoading;
  double width;

  @override
  Widget build(BuildContext context) {
    if (isLoading == null) isLoading = false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 60,
          width: width ?? MediaQuery.of(context).size.width - 34,
          decoration: BoxDecoration(
            color: backgroundColor ?? kBlackColorOpacity,
            borderRadius: kRadiusAll,
            boxShadow: [
              BoxShadow(
                color: shadowColor ?? kBlackColorOpacity,
                blurRadius: 12,
                spreadRadius: -12,
                offset: Offset(0, 20),
              ),
            ],
          ),
          child: CupertinoButton(
            child: FittedBox(
              child: isLoading
                  ? Container(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(kWhiteColor),
                        strokeWidth: 3,
                      ),
                    )
                  : FittedBox(
                      child: Text(
                        title ?? "Continuar",
                        style: GoogleFonts.poppins(textStyle: kButtonTextStyle),
                      ),
                    ),
            ),
            onPressed: onPressed,
          ),
        ),
      ],
    );
  }
}
