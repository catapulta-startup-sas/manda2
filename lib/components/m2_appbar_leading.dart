import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/constants.dart';

class M2AppBarLeading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: kRadiusAll,
            color: kWhiteColor,
           ),
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            CupertinoIcons.back,
            color: kBlackColor,
          ),
        ),
      ),
    );
  }
}
