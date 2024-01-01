import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:schedule_project/widgets/passwordDialog.dart';


import '../provider/OAuth.dart';
import '../services/authService.dart';
import '../widgets/showConfirmationDialog.dart';
import 'loginPage.dart';

/// 마이페이지
class MyPage extends StatefulWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  TextEditingController jobController = TextEditingController();

  Future<bool> saveDegree2Password(String pw) async {
    var service = AuthService();

    if(await service.ceckDegree2Password()){
      service.saveDegree2Password(pw);
    }

    return true;
  }

  Future<bool> deleteDegree2Password(String pw) async{
    var service = AuthService();

    var returnValue = service.deleteDegree2Password(pw);

    return returnValue;

  }


  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    var oAuthList = authService.oAuthList[0];

    final ValueNotifier<String> version = ValueNotifier<String>("1.0"); // ValueNotifier 변수 선언
    version.value = oAuthList.version;

    return Consumer(
      builder: (context, bucketService, child) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 80,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Text(
                  "마이페이지",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              SizedBox(
                height: 31,
              ),
              Column(
                children: [
                  Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Icon(
                          Icons.account_circle,
                          size: 158,
                          color: Colors.grey,
                        )),
                  ),
                  SizedBox(height: 15),
                  Text(
                    '${user.email}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(128, 128, 128, 1),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 26,
              ),
              Container(
                height: 7,
                decoration: BoxDecoration(
                  color: Color(0xfff3f3f3),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0),
                child: Column(
                  children: [
                    Text(
                      "앱 설정",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 23,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 30.0, bottom: 10),
                child: Row(
                  children: [
                    Text(
                      "앱 버전",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    SizedBox(width: 200),
                    ValueListenableBuilder(
                      valueListenable: version,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(version.value,
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(children: [
                  Text("암호설정 여부", style : TextStyle(fontSize: 16)),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      oAuthList.degree2Yn ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                      color: Colors.black),
                    onPressed: () async {
                      oAuthList.degree2Yn ? await passwordDialog(context, "d", deleteDegree2Password, (returnVal){
                        if(returnVal){
                          setState(() {
                            oAuthList.degree2Yn = !authService.oAuthList[0].degree2Yn;
                          });
                        }
                      }) : await passwordDialog(context, "i", saveDegree2Password, (returnVal){
                        if(returnVal){
                          setState(() {
                            oAuthList.degree2Yn = !authService.oAuthList[0].degree2Yn;
                          });
                        }
                      });
                    },
                  )
                ],),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  children: [
                    Text(
                      "로그아웃",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // 로그아웃
                        context.read<AuthService>().signOut();

                        // 로그인 페이지로 이동
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  children: [
                    Text(
                      "탈퇴하기",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        bool? result = await showConfirmationDialog(
                          context,
                          'Confirmation',
                          '정말 탈퇴하시겠습니까?',
                        );

                        if (result == true) {
                          // 탈퇴하기
                          context.read<AuthService>().delete();

                          // // 로그인 페이지로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
