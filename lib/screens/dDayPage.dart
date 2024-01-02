import 'package:flutter/material.dart';

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
      body: const SingleChildScrollView(
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
