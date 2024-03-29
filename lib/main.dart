import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:schedule_project/screens/homePage.dart';
import 'package:schedule_project/screens/loginPage.dart';
import 'package:schedule_project/services/authService.dart';
import 'package:schedule_project/services/localAuth.dart';
import 'constants/color.dart';
import 'constants/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // main 함수에서 async 사용하기 위함
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(); // firebase 앱 시작
  await Future.delayed(const Duration(seconds: 3)); // 3초 지연
  await initializeDateFormatting(); //달력의 언어 설정을 위해 추가

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(create: (context) => LocalAuthApi())
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthService>().currentUser();
    final ThemeData theme = ThemeData();

    return MaterialApp(
      theme: ThemeData(
          primaryColor: THEME_COLOR,
          appBarTheme: AppBarTheme(color: THEME_COLOR),
          buttonTheme: ButtonThemeData(buttonColor: THEME_COLOR),
          colorScheme: theme.colorScheme.copyWith(secondary: THEME_COLOR)),
      debugShowCheckedModeBanner: false,
      home: user == null ? LoginPage() : HomePage(),
    );
  }
}
