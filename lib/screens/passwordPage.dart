import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../services/authService.dart';

// 키보드
class KeyboardKey extends StatefulWidget {
  final Object label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  KeyboardKey({super.key,
    required this.label,
    required this.onTap,
    required this.value,
  })  : assert(label != null),
        assert(onTap != null),
        assert(value != null);

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
          onTap: (){
            widget.onTap(widget.value.toString());
          },
          child: Column(
              children: [
                Container(
                  //decoration: BoxDecoration(border: Border.all(color: THEME_COLOR)),
                    child: AspectRatio(aspectRatio: 2,
                        child: Container(
                          child: Center(
                            child: widget.label == 'backspace' ?
                            const Icon(Icons.keyboard_backspace) :
                            Text(
                              widget.label.toString(),
                              style: const TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        )
                    )
                ),
              ]
          ),
        );
  }
}

/// 페이지
class PasswordPage extends StatefulWidget {
  const PasswordPage({Key? key, required this.degree2Yn}) : super(key: key);

  final String degree2Yn;


  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {

  var pw = "";
  var password = ["",""];

  var pwMark = ['-','-','-','-'];
  var maxLengthYn = false;
  var degree2Yn = "r";
  var message = "2차암호를 입력해주세요";

  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', 'backspace'],
  ];

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

  renderKeyboard(StateSetter setState) {
    return keys
        .map(
          (x) => Row(
        children: x.map((y) {
          return Expanded(
            child: KeyboardKey(
              label: y,
              onTap: (val) async {
                setState(() {
                  message = "2차암호를 입력해주세요";

                  pwMark = ['','','',''];

                  if(pw != "" &&  val == "backspace"){
                    pw = pw.substring(0, pw.length - 1);
                  }else if(val != "backspace"){
                    pw += val;
                  }

                  for(var i = 0; i < 4; i++){
                    pwMark[i] = pw.length <= i ? "-" : "*";
                  }
                });

                if(pw.length == 4) {
                  maxLengthYn = true;
                  if(password[0].length == 0){
                    setState(()=>{
                        pwMark = ['-','-','-','-'],
                        message = "확인을위해 다시한번 입력해주세요."
                    });
                    password[0] = pw;
                    pw = "";
                    if(degree2Yn == "r"){
                      // 2차암호가 read 형식일 경우

                    }
                  }else{
                    password[1] = pw;
                    if(password[0] == password[1]){
                      if(degree2Yn == "d"){
                        var isTrue = await deleteDegree2Password(pw);
                        if(isTrue == false){
                          setState(()=>setDefaultValue());
                        }else{
                          Navigator.pop(context, true);
                        }
                      }else{
                        if(await saveDegree2Password(pw)){
                          Navigator.pop(context, true);
                        }
                      }
                    }else{
                      setDefaultValue();
                    }
                  }
                }else{
                  print("3");
                  maxLengthYn = false;
                }
              },
              value: y,
            ),
          );
        }).toList(),
      ),
    ).toList();
  }

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  setDefaultValue(){
    message = "입력하신 2차암호가 일치하지 않습니다.";
    pw = "";
    pwMark = ['-','-','-','-'];
    password = ["",""];
  }

  var headerViewYn = true;

  @override
  Widget build(BuildContext context) {
    degree2Yn = widget.degree2Yn;

    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.white),
        body: Row(
            children: [
              Expanded(
                child:
                Column(children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Container(
                    height: 7,
                  ),
                  const SizedBox(height: 20),
                  Text(message,
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing : 3,
                          color: headerViewYn ? Colors.black : Colors.red
                      )),
                  const SizedBox(height: 20),
                  Container(
                    height: 7,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    child: Text(pwMark.join("") // ValueNotifier를 사용해서 변경여부 확인이 필요
                        , style: const TextStyle(
                            fontSize: 50,
                            letterSpacing: 30
                        )),
                  ),
                  Spacer(),
                  ...renderKeyboard(setState),
                  const SizedBox(height: 70),
                  ]),
              ),]
        ),
      );
  }
} //clase

