import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:schedule_project/provider/OAuth.dart';
import 'package:yaml/yaml.dart';

class AuthService extends ChangeNotifier {

  final degree2Pw = FirebaseFirestore.instance.collection('DEGREE_2PW');

  List<OAuth> oAuthList = [];

  /// 사용자 정보 가져오기
  User? currentUser() {
    // 현재 유저(로그인 되지 않은 경우 null 반환)
    var currentUser = FirebaseAuth.instance.currentUser;

    return currentUser;
  }

  /// 회원가입 기능
  void signUp({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 가입 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 회원가입
    // 이메일 및 비밀번호 입력 여부 확인
    if (email.isEmpty) {
      onError("이메일을 입력해 주세요.");
      return;
    } else if (password.isEmpty) {
      onError("비밀번호를 입력해 주세요.");
      return;
    }

    // firebase auth 회원 가입
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 성공 함수 호출
      onSuccess();
    } on FirebaseAuthException catch (e) {
      // Firebase auth 에러 발생
      onError(e.message!);
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }
  }

  /// 로그인 기능
  void signIn({
    required String email, // 이메일
    required String password, // 비밀번호
    required Function onSuccess, // 로그인 성공시 호출되는 함수
    required Function(String err) onError, // 에러 발생시 호출되는 함수
  }) async {
    // 로그인
    if (email.isEmpty) {
      onError('이메일을 입력해주세요.');
      return;
    } else if (password.isEmpty) {
      onError('비밀번호를 입력해주세요.');
      return;
    }

    // 로그인 시도
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      onSuccess(); // 성공 함수 호출
      notifyListeners(); // 로그인 상태 변경 알림
    } on FirebaseAuthException catch (e) {
      // firebase auth 에러 발생
      if (e.code == "invalid-email") {
        onError("이메일 형식이 올바르지 않습니다.");
      } else {
        onError(e.message!);
      }
    } catch (e) {
      // Firebase auth 이외의 에러 발생
      onError(e.toString());
    }
  }

  /// 로그아웃
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    notifyListeners(); // 로그인 상태 변경 알림
  }

  /// 탈퇴하기
  void delete(password, onSuccess, onError) async {
    var user = FirebaseAuth.instance.currentUser;
    var authCredential = EmailAuthProvider.credential(email: user!.email.toString(), password: password);
    try {
      await user.reauthenticateWithCredential(authCredential);
      await currentUser()?.delete();
      onSuccess();
    }catch(e){
      // 에러 발생
      onError(e.toString());
    }


    notifyListeners(); // 로그인 상태 변경 알림
  }

  /// 2차 비밀번호 설정하기
  void saveDegree2Password(String pw) async{
    var uuid = currentUser()?.uid; // 유저의 uid값 가져오기

    degree2Pw.doc(uuid).set(Map.of({"uuid" : uuid, "pw" : pw}));

    setUserData();
  }

  /// 2차 비밀번호 삭제
  Future<bool> deleteDegree2Password(String pw) async{
    var uuid = currentUser()?.uid;

    final map = await degree2Pw.where("uuid",isEqualTo: uuid).where("pw", isEqualTo: pw).get();
    List data = map.docs.map((doc) => doc.data()).toList();

    if(data.isNotEmpty){
      degree2Pw.doc(uuid).delete();
      setUserData();
      return true;
    }else{
      setUserData();
      return false;
    }
  }

  /// 2차비밀번호 저장여부 확인하기
  Future<bool> ceckDegree2Password() async{
    var uuid = currentUser()?.uid; // 유저의 uid값 가져오기

    final map = await degree2Pw.where("uuid", isEqualTo : uuid).get();
    var list = map.docs.map((doc) => doc.data()).toList();

    return list.isEmpty;
  }

 /// 사용자 기초데이터를 조회한다.
  void setUserData() async{
    var currentUser = FirebaseAuth.instance.currentUser;
    var uid = currentUser!.uid.toString();

    String version = "";

    rootBundle.loadString("pubspec.yaml").then((yamlValue) {
      var yaml = loadYaml(yamlValue);
      version = yaml['version'].toString().split("+")[0];
    });

    final map = await degree2Pw.where("uuid", isEqualTo : uid).get();
    var list = map.docs.map((doc) => doc.data()).toList();


    if(oAuthList.isEmpty){
      oAuthList.add(OAuth(version ?? "1.0", list.isNotEmpty));
    }else{
      oAuthList[0].version = version ?? "1.0";
      oAuthList[0].degree2Yn = list.isNotEmpty;
    }


    notifyListeners(); // provider 갱신
  }


}
