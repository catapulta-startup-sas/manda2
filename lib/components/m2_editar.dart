import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class M2Editar extends StatelessWidget {
  M2Editar(
      {this.titulo,
      this.text,
      this.keyboardType,
      this.isPassword,
      this.enabled,
      this.onChanged,
      this.onTap,
      this.onEditingComplete,
      this.imageRoute,
      this.validator,
      this.iconColor,
      this.errorText,
      this.width,
      this.height,
      this.initialValue,
      this.colorLabel,
      this.capitalization});

  String titulo;
  String text;
  String imageRoute;
  final TextInputType keyboardType;
  final bool isPassword;
  final bool enabled;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final Function validator;
  final Color iconColor;
  final String errorText;
  final double width;
  final double height;
  final Color colorLabel;
  String initialValue;
  var capitalization;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(17, 0, 0, 10),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                '$titulo',
                style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontSize: 15, color: colorLabel ?? kBlackColorOpacity)),
              ),
            ),
          ),
          Center(
            child: Container(
              width: width ?? MediaQuery.of(context).size.width,
              height: height ?? 50,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(17, 0, 17, 0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            enabled: enabled ?? true,
                            keyboardAppearance: Brightness.light,
                            textCapitalization:
                                capitalization ?? TextCapitalization.none,
                            initialValue: initialValue,
                            validator: validator,
                            style: GoogleFonts.poppins(
                                textStyle: kTextFormFieldTextStyle),
                            textAlign: TextAlign.start,
                            decoration: InputDecoration(
                              hintText: text,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kBlackColorOpacity),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: kBlackColorOpacity),
                              ),
                              hintStyle: GoogleFonts.poppins(
                                  textStyle:
                                      kTextFormFieldHintTextStyleInicioSesion),
                            ),
                            keyboardType: keyboardType ?? TextInputType.text,
                            obscureText: isPassword ?? false,
                            onChanged: onChanged,
                            onTap: onTap,
                            onEditingComplete: onEditingComplete,
                          ),
                        ),
                        Image(
                          image: AssetImage(
                            '$imageRoute',
                          ),
                          height: 24,
                          color: iconColor ?? kGreenManda2Color,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
