import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:manda2/constants.dart';
import 'package:numeral/numeral.dart';

class M2Bar extends StatelessWidget {
  const M2Bar({
    this.value = 0,
    this.label = "",
    this.maxValue = 1,
    this.isActive = false,
  });

  final int value;
  final String label;
  final int maxValue;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "\$${Numeral(value)}",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: kBlackColor.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ),
        Container(
          height: 100.0 * ((value / maxValue) > 0 ? (value / maxValue) : 0.025),
          width: MediaQuery.of(context).size.height * 0.04,
          margin: EdgeInsets.symmetric(horizontal: 2),
          color: isActive ? kGreenActive : kGreenInactive,
        ),
        const SizedBox(height: 4),
        Text(
          "$label",
          style: GoogleFonts.poppins(
            textStyle: TextStyle(
              color: kBlackColor.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
