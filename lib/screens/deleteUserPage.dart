import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/authService.dart';
import '../widgets/showConfirmationDialog.dart';
import 'loginPage.dart';

/// 홈페이지
class DeleteUserPage extends StatefulWidget {
  const DeleteUserPage({Key? key}) : super(key: key);

  @override
  State<DeleteUserPage> createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {

  @override
  Widget build(BuildContext context) {

    final authService = context.read<AuthService>();
    final user = authService.currentUser()!;
    TextEditingController passwordController = TextEditingController();

    return Consumer(
      builder: (context, bucketService, child) {
        return Scaffold(
          appBar: AppBar(backgroundColor: Colors.white),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 25,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 18.0),
                  child: Text(
                    "탈퇴하기",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                  child: Column(
                    children: [
                      const Text(
                        "해당 계정을 탈퇴하기 위해 패스워드를 한번 더 입력해주세요.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
            
                    ],
                  ),
                ),
                const SizedBox(
                  height: 31,
                ),
                Container(
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xfff3f3f3),
                  ),
                ),
                const SizedBox(
                  height: 31,
                ),
                Column(
                  children: [
                    const SizedBox(height: 15),
                    Center(
                      child: Text(
                        '${user.email}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(128, 128, 128, 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
            
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
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: passwordController,
                        obscureText: true, // 비밀번호 안보이게
                        decoration: const InputDecoration(hintText: "비밀번호"),
                      ),
                      SizedBox(height: 60),
                      ElevatedButton(
                        child: const Text("계정탈퇴", style: TextStyle(fontSize: 21)),
                        onPressed: () async{
                          bool? result = await showConfirmationDialog(
                            context,
                            '계정탈퇴',
                            '정말 탈퇴하시겠습니까?',
                          );
                          // 탈퇴하기
                          context.read<AuthService>().delete(passwordController.text, (){
                            // // 회원탈퇴 성공시
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          }, (message){
                            // 에러 발생시 수행
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(message),
                            ));
                            return false;
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );

  }
} //clase
