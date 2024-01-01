import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:schedule_project/widgets/mainCalendar.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yaml/yaml.dart';

import '../services/authService.dart';
import '../widgets/showConfirmationDialog.dart';
import 'loginPage.dart';

/// 홈페이지
class DDayPage extends StatefulWidget {
  const DDayPage({Key? key}) : super(key: key);

  @override
  State<DDayPage> createState() => _DDayPageState();
}

class _DDayPageState extends State<DDayPage> {
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
            SizedBox(height: 70),
          ],
        ),
      ),
    );

  }
} //clase
