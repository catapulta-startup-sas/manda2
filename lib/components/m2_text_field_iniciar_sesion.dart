import 'package:manda2/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:manda2/constants.dart';

class M2TextFieldIniciarSesion extends StatelessWidget {
  M2TextFieldIniciarSesion({
    @required this.placeholder,
    this.keyboardType,
    this.isPassword,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.imageRoute,
    this.validator,
    this.iconColor,
    this.errorText,
    this.height,
    this.initialValue,
    this.textCapitalization,
    this.lineColor
  });
  final String placeholder;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final String imageRoute;
  final Function validator;
  final Color iconColor;
  final String errorText;
  final double height;
  final String initialValue;
  final TextCapitalization  textCapitalization;
  final Color lineColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(17, 5, 17, 32),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 35,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: kBlackColor.withOpacity(0.2)
            )
          )
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                keyboardAppearance: Brightness.light,
                textCapitalization: textCapitalization ?? TextCapitalization.none,
                initialValue: initialValue,
                validator: validator,
                style: GoogleFonts.poppins(
                    textStyle: kTextFormFieldTextStyle),
                textAlign: TextAlign.start,
                decoration: InputDecoration.collapsed(
                  hintText: placeholder,

                  hintStyle: GoogleFonts.poppins(
                      textStyle: kTextFormFieldHintTextStyleInicioSesion),
                ),
                keyboardType: keyboardType ?? TextInputType.text,
                obscureText: isPassword ?? false,
                onChanged: onChanged,
                onTap: onTap,
                onEditingComplete: onEditingComplete,

              ),
            ),
            imageRoute == null || imageRoute == ""
                ? Container()
                : Image(
              image: AssetImage(
                '$imageRoute',
              ),
              height: height ?? 24,
              color: iconColor,
            )
          ],
        ),
      ),
    );
  }
}
