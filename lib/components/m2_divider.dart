import 'package:flutter/cupertino.dart';
import '../constants.dart';

class M2Divider extends StatefulWidget {
  @override
  _M2DividerState createState() => _M2DividerState();
}

class _M2DividerState extends State<M2Divider> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 1,
        width: MediaQuery.of(context).size.width - 34,
        color: kBlackColor.withOpacity(0.15),
      ),
    );
  }
}
