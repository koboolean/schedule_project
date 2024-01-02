import 'package:flutter/material.dart';
import 'package:schedule_project/widgets/mainCalendar.dart';

/// 홈페이지
class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar : AppBar(), //어플 상단 바
      body: SingleChildScrollView(
        child: Column(
          children: [
           // SizedBox(height: 30), // 빈박스를 만들어서 header 위쪽 공간을 확보
            MainCalendar(
              selectedDate: selectedDate
            ), //MainCalendar 위젯을 해당 위치로 불러온다.
            SizedBox(height: 70),
          ],
        ),
      ),
    );

  }
} //clase
