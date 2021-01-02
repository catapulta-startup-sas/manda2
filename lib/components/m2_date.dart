import 'package:manda2/components/m2_appbar_leading.dart';
import 'package:manda2/components/m2_button.dart';
import 'package:manda2/components/m2_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manda2/components/catapulta_scroll_view.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:jiffy/jiffy.dart';
import 'package:manda2/constants.dart';

class M2Fecha extends StatefulWidget {
  @override
  _M2FechaState createState() => _M2FechaState();
}

class _M2FechaState extends State<M2Fecha> {
  DateTime diaDespues;
  DateTime now = DateTime.now();
  DateTime _dateTime = DateTime.now();
  String formattedDate;
  String formattedHour;

  @override
  void initState() {
    super.initState();

    var diaDespues = Jiffy(now).add(days: 1);
    initializeDateFormatting();
    formattedDate = DateFormat.yMMMMd('es').format(diaDespues);
    formattedHour = DateFormat('h:mm a').format(diaDespues);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhiteColor,
        leading: M2AppBarLeading(),
      ),
      body: CatapultaScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 30,
                ),
                Column(
                  children: <Widget>[
                    Text('$formattedDate'),
                    SizedBox(
                      height: 20,
                    ),
                    Text('$formattedHour')
                  ],
                ),
                FlatButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2020, 12, 31),
                        onChanged: (date) {
                          setState(() {
                            diaDespues = date;
                            formattedDate =
                                DateFormat.yMMMMd('es').format(diaDespues);
                            formattedHour =
                                DateFormat('h:mm a').format(diaDespues);
                          });
                        },
                        onConfirm: (date) {
                          setState(() {
                            diaDespues = date;
                            formattedDate =
                                DateFormat.yMMMMd('es').format(diaDespues);
                            formattedHour =
                                DateFormat('h:mm a').format(diaDespues);
                          });
                        },
                        currentTime: DateTime.now(),
                        locale: LocaleType.es,
                      );
                    },
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Cambiar',
                          style: TextStyle(color: kBlackColor),
                        ),
                      ],
                    )
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }


}
