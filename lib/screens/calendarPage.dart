import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yaml/yaml.dart';

import '../services/authService.dart';
import '../widgets/showConfirmationDialog.dart';
import 'loginPage.dart';

/// 홈페이지
class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar : AppBar(), //어플 상단 바
      body: TableCalendar(
        locale: 'ko_KR',  //달력 언어 설정
        firstDay: DateTime.utc(1995, 01, 01), //최소날짜
        lastDay: DateTime.utc(2095, 12, 31),  //최대날짜
        focusedDay: DateTime.now(),  //달력을 보여줄 기준 날짜

        //HeaderStyle
        headerStyle: HeaderStyle(
          titleCentered: true, //title 중앙 정렬 여부
          titleTextFormatter: (date, locale) =>   //title 날짜 형태
              DateFormat.yMMMM(locale).format(date),
          titleTextStyle: const TextStyle(  //title Style 지정
            fontSize: 20.0,
            color: Colors.deepOrange
          ),
          formatButtonVisible: false,  //formatButton 노출 여부
          //header Padding 조절
          headerPadding: const EdgeInsets.symmetric(vertical : 4.0, horizontal: 1.0), //vertical : 수직, horizontal : 수평
          //leftChevron Icon 정의
          leftChevronIcon: const Icon(
            Icons.arrow_left,
            size: 40.0,
          ),
          //rightChevron Icon 정의
          rightChevronIcon: const Icon(
            Icons.arrow_right,
            size: 40.0,
          ),
        ),
      ),
    );
  }
}
