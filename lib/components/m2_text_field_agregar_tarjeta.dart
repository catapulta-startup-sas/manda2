import 'package:flutter/services.dart';
import 'package:manda2/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:manda2/constants.dart';

class M2TextFielIdAgregarTarjeta extends StatelessWidget {
  M2TextFielIdAgregarTarjeta({
    @required this.text,
    @required this.title,
    this.keyboardType,
    this.isPassword,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.imageRoute,
    this.validator,
    this.iconColor,
    this.errorText,
    this.inputFormatters,
    this.textCapitalization,
  });
  final String text;
  final String title;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final String imageRoute;
  final Function validator;
  final Color iconColor;
  final String errorText;
  final List<TextInputFormatter> inputFormatters;
  final TextCapitalization textCapitalization;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.058),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          '$title',
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: kBlackColor
                            )
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.058),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              keyboardAppearance: Brightness.light,
                              inputFormatters: inputFormatters,
                              validator: validator,
                              textCapitalization: textCapitalization ?? TextCapitalization.sentences,
                              style: GoogleFonts.poppins(
                                  textStyle: kTextFormFieldTextStyle),
                              textAlign: TextAlign.start,
                              decoration: InputDecoration(
                                hintText: text,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: kBlackColorOpacity),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: kBlackColorOpacity),
                                ),
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
                          Image(
                            image: AssetImage(
                              '$imageRoute',
                            ),
                            width: 24,
                            height: 24,
                            color: iconColor,
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
//        SizedBox(
//          height: 1,
//          width: MediaQuery.of(context).size.width * 0.9,
//          child: Container(
//            color: kBlackColor.withOpacity(0.1),
//          ),
//        )
      ],
    );
  }
}
