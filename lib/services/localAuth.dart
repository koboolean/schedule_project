import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';// for AndroidAuthMessages
import 'package:local_auth_ios/local_auth_ios.dart';
import 'package:shared_preferences/shared_preferences.dart';// for IOSAuthMessages

enum _SupportState { unknown, supported, unsupported }

class LocalAuthApi extends ChangeNotifier {
  static final _auth = LocalAuthentication();

  static var isLcalAuthSetYn = false; // local_auth 체크박스 체크 이후 shared_prefarence 내부에 저장된다.
  static var isLocalAuthYn = _SupportState.unknown;

  static Future<bool> hasBiometrics() async {
    try {
      return await _auth.canCheckBiometrics ?? false;
    } on PlatformException catch (e) {
      print(e);
    }
    return false;
  }

  /**
   * SharedPreference 내부에 지문인증 여부를 저장한다.
   * */
  setLcalAuthSetYn(bool val) async{
    final SharedPreferences pref = await SharedPreferences.getInstance();
    isLcalAuthSetYn = val;
    pref.setBool("isLcalAuthSetYn", isLcalAuthSetYn);

    notifyListeners(); // provider 갱신
  }

  /**
   * SharedPreference 내부에 지문인증 여부를 가져온다.
   * */
  void getLcalAuthSetYn() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();

    if(pref.getBool("isLcalAuthSetYn") == null){
      pref.setBool("isLcalAuthSetYn", isLcalAuthSetYn);
    }

    isLcalAuthSetYn = pref.getBool("isLcalAuthSetYn")!;
    notifyListeners(); // provider 갱신
  }

  static Future<List<BiometricType>> getBiometrics() async {
    try {
      //등록된 생체인식 목록을 얻기
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    return <BiometricType>[];
  }

  void showLocalAuthYn() async {
    if(!await hasBiometrics()){
      // 생체인증 사용 불가능
      isLocalAuthYn = _SupportState.unsupported;
    }

    // 생체인증 사용가능
    List list = await getBiometrics();
    if(list.isEmpty){
      isLocalAuthYn = _SupportState.unknown;
    }

    isLocalAuthYn = _SupportState.supported;


    notifyListeners(); // provider 갱신
  }

  static bool localAuthYn(context){
    switch(isLocalAuthYn){
      case _SupportState.supported :
        return true;
        break;
      case _SupportState.unknown :
        return true;
        break;
      case _SupportState.unsupported:
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("생체인증서비스를 지원하지 않습니다."),
        ));
        return false;
        break;
    }
  }

  static Future<bool> authenticate() async {
    final isAvailable = await hasBiometrics();
    if (!isAvailable) return false;

    try {
      // 가능한 경우 생체 인식 인증을 사용하지만 핀, 패턴 또는 비밀번호로 대체할 수도 있음
      return await _auth.authenticate(
          localizedReason: '생체정보를 인식해주세요.',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true, //기본 대화 상자를 사용하기
            stickyAuth: true,//false : 앱 재실행 되었을때 플러그인 인증을 재시도
          ),
          authMessages: [
            const IOSAuthMessages(
              lockOut: '생체인식 활성화',
              goToSettingsButton: '설정',
              goToSettingsDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
              cancelButton: '취소',
              localizedFallbackTitle: '다른 방법으로 인증',
            ),
            const AndroidAuthMessages(
              biometricHint: '',
              biometricNotRecognized: '생체정보가 일치하지 않습니다.',
              biometricRequiredTitle: '생체',
              biometricSuccess: '로그인',
              cancelButton: '취소',
              deviceCredentialsRequiredTitle: '생체인식이 필요합니다.',
              deviceCredentialsSetupDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
              goToSettingsButton: '설정',
              goToSettingsDescription: '기기 설정으로 이동하여 생체 인식을 등록하세요.',
              signInTitle: '생체정보를 인식해주세요.',
            )
          ]
      );
    } on PlatformException catch (e) {
      print(e);
    }
    return false;
  }
}