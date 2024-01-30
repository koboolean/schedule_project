import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:schedule_project/screens/passwordPage.dart';
import 'package:schedule_project/widgets/passwordDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/authService.dart';
import '../services/localAuth.dart';
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
              const SizedBox(
                height: 80,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
                child: Text(
                  "마이페이지",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
              ),
              const SizedBox(
                height: 31,
              ),
              Column(
                children: [
                  Center(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: const Icon(
                          Icons.account_circle,
                          size: 158,
                          color: Colors.grey,
                        )),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    '${user.email}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color.fromRGBO(128, 128, 128, 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 26,
              ),
              Container(
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xfff3f3f3),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 18.0),
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
              const SizedBox(
                height: 23,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 30.0, bottom: 10),
                child: Row(
                  children: [
                    const Text(
                      "앱 버전",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(width: 200),
                    ValueListenableBuilder(
                      valueListenable: version,
                      builder:
                          (BuildContext context, String value, Widget? child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(version.value,
                                style: const TextStyle(
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
                  const Text("암호설정", style : TextStyle(fontSize: 16)),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      oAuthList.degree2Yn ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                      color: Colors.black),
                    onPressed: () async {
                      /* 팝업형식에서 화면형식으로 변경
                      oAuthList.degree2Yn ? await passwordDialog(context, "d", deleteDegree2Password, (returnVal){
                        if(returnVal){
                          setState(() {
                            oAuthList.degree2Yn = !authService.oAuthList[0].degree2Yn;
                          });
                          LocalAuthApi().setLcalAuthSetYn(false);
                        }
                      }) : await passwordDialog(context, "i", saveDegree2Password, (returnVal){
                        if(returnVal){
                          setState(() {
                            oAuthList.degree2Yn = !authService.oAuthList[0].degree2Yn;
                          });
                        }
                      });
                       */
                      String degree2Yn = oAuthList.degree2Yn ? "d" : "i";

                      var isYn = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordPage(degree2Yn : degree2Yn)),
                      );

                      if(isYn == true){
                        setState(() {
                          oAuthList.degree2Yn = !authService.oAuthList[0].degree2Yn;
                        });
                      }
                    },
                  )
                ],),
              ),
              (oAuthList.degree2Yn && LocalAuthApi.localAuthYn(context) == true) ? Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  children: [
                    const Text("생체인증 사용하기",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: Icon(
                          LocalAuthApi.isLcalAuthSetYn ? Icons.check_box_outlined : Icons.check_box_outline_blank,
                          color: Colors.black),
                      onPressed: () async {
                        var isCeck = await LocalAuthApi.authenticate();

                        if(isCeck){
                          setState(() {
                            LocalAuthApi().setLcalAuthSetYn(!LocalAuthApi.isLcalAuthSetYn);
                          });

                        }
                      },
                    )
                  ],
                ),
              ) : Row(),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  children: [
                    const Text(
                      "로그아웃",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        // 로그아웃
                        bool? result = await showConfirmationDialog(
                          context,
                          '로그아웃',
                          '로그아웃하시겠습니까?',
                        );

                        if(result == true){
                          context.read<AuthService>().signOut();

                          // 로그인 페이지로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: Row(
                  children: [
                    const Text(
                      "탈퇴하기",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.black,
                      ),
                      onPressed: () async {
                        bool? result = await showConfirmationDialog(
                          context,
                          '계정탈퇴',
                          '정말 탈퇴하시겠습니까?',
                        );

                        if (result == true) {
                          // 탈퇴하기
                          context.read<AuthService>().delete();

                          // // 로그인 페이지로 이동
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
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
