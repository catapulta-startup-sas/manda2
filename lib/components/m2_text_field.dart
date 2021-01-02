import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';

class M2TextField extends StatelessWidget {
  M2TextField({
    @required this.placeholder,
    this.title,
    this.keyboardType,
    this.isPassword,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.width,
    this.height,
    this.textCapitalization,
    this.initialValue,
    this.inputFormatters,
    this.maxLength,
    this.textAlign,
    this.borderRadius,
    this.textStyle,
    this.hintStyle,
    this.padding,
    this.hasBorder,
    this.focusNode,
  });
  String initialValue;
  final String placeholder;
  final String title;
  final TextInputType keyboardType;
  final bool isPassword;
  final Function onChanged;
  final Function onTap;
  final Function onEditingComplete;
  final double width;
  final double height;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final int maxLength;
  final TextAlign textAlign;
  final BorderRadius borderRadius;
  final TextStyle textStyle;
  final TextStyle hintStyle;
  final EdgeInsets padding;
  bool hasBorder;
  FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    if (hasBorder == null) {
      hasBorder = true;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            title == ""
                ? Container()
                : Container(
                    width: MediaQuery.of(context).size.width * 0.86,
                    height: MediaQuery.of(context).size.height * 0.05,
                    alignment: Alignment(-1, 0),
                    child: FittedBox(
                      child: Text(
                        title,
                        style: GoogleFonts.poppins(
                          textStyle: kTextFormFieldTittleTextStyle,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
          ],
        ),
        Container(
          width: width ?? MediaQuery.of(context).size.width * 0.86,
          height: height ?? MediaQuery.of(context).size.height * 0.065,
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? kRadiusAll,
            border: Border.all(
              color: hasBorder ? kBlackColorOpacity : kTransparent,
            ),
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.all(20),
            child: Center(
              child: TextFormField(
                maxLength: maxLength,
                focusNode: focusNode,
                inputFormatters: inputFormatters,
                initialValue: initialValue,
                textCapitalization:
                    textCapitalization ?? TextCapitalization.none,
                keyboardAppearance: Brightness.light,
                maxLines: 20,
                style: GoogleFonts.poppins(
                    textStyle: textStyle ?? kTextFormFieldTextStyle),
                textAlign: textAlign ?? TextAlign.start,
                decoration: InputDecoration(
                  hintText: placeholder,
                  counterText: '',
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kTransparent)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kTransparent)),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(color: kTransparent)),
                  hintStyle: GoogleFonts.poppins(
                      textStyle: hintStyle ?? kTextFormFieldHintTextStyle),
                ),
                keyboardType: keyboardType ?? TextInputType.text,
                obscureText: isPassword ?? false,
                onChanged: onChanged,
                onTap: onTap,
                onEditingComplete: onEditingComplete,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
