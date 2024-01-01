import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_project/screens/calendarPage.dart';
import 'package:schedule_project/screens/myPage.dart';

import '../constants/color.dart';
import '../services/authService.dart';

/// 홈페이지
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _childrenWidget = [
    CalendarPage(), // 캘린더
    MyPage(), // 일기장
    MyPage(), // D-Day
    MyPage() // 마이페이지
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final authService = context.read<AuthService>();
    authService.setUserData();

    return Scaffold(
      extendBody: true,
      body: _childrenWidget[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          onTap: _onTap,
          currentIndex: _currentIndex,
          selectedItemColor: THEME_COLOR,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.date_range),
              activeIcon: Icon(Icons.date_range, color: THEME_COLOR),
              label: '캘린더',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              activeIcon: Icon(Icons.article, color: THEME_COLOR),
              label: '일기장',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.pending_actions),
                activeIcon: Icon(Icons.pending_actions, color: THEME_COLOR),
                label: '디데이'),
            BottomNavigationBarItem(
                icon: Icon(Icons.account_circle),
                activeIcon: Icon(Icons.account_circle, color: THEME_COLOR),
                label: '설정'),
          ],
        ),
      ),
    );
  }
}
