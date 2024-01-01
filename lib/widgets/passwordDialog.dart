import 'package:flutter/material.dart';
import 'package:schedule_project/constants/color.dart';

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
                      Icon(Icons.keyboard_backspace) :
                      Text(
                        widget.label.toString(),
                        style: TextStyle(
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

Future<void> passwordDialog(BuildContext context, String type, Function callbackDegree2Password, Function returnValueCallback) {
  var pw = "";
  var pwMark = ['-','-','-','-'];
  var maxLengthYn = false;

  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', 'backspace'],
  ];

  renderKeyboard(StateSetter setState) {
    return keys
        .map(
          (x) => Row(
        children: x.map((y) {
          return Expanded(
            child: KeyboardKey(
              label: y,
              onTap: (val) {
                setState((){
                  pwMark = ['','','',''];

                  if(pw != "" &&  val == "backspace"){
                    pw = pw.substring(0, pw.length - 1);
                  }else if(val != "backspace"){
                    pw += val;
                  }

                  for(var i = 0; i < 4; i++){
                    pwMark[i] = pw.length <= i ? "-" : "*";
                  }

                  if(pw.length == 4) {
                    maxLengthYn = true;
                  }else{
                    maxLengthYn = false;
                  }
                });
              },
              value: y,
            ),
          );
        }).toList(),
      ),
    ).toList();
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: true, // 바깥 여백 터치시 대화 상자를 닫을 수 있는지 여부
    builder: (BuildContext context) {
      var headerViewYn = true;

      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: StatefulBuilder(
          builder: (__, StateSetter setState){
            return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Row(
                          children: [
                            Expanded(
                              child:
                              Column(children: [
                                SizedBox(height: 20),
                                Text(headerViewYn ? type == "d" ? "등록된 2차암호를 입력해주세요" : "등록할 2차암호를 입력해주세요" : "비밀번호가 일치하지 않습니다.",
                                    style: TextStyle(
                                      fontSize: 15,
                                      letterSpacing : 3,
                                      color: headerViewYn ? Colors.black : Colors.red
                                )),
                                SizedBox(height: 20),
                                Container(
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: Color(0xfff3f3f3),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  child: Text(pwMark.join("") // ValueNotifier를 사용해서 변경여부 확인이 필요
                                      , style: TextStyle(
                                          fontSize: 50,
                                          letterSpacing: 30
                                      )),
                                ),
                                SizedBox(height: 20),
                                ...renderKeyboard(setState),
                                maxLengthYn == true ? ElevatedButton(onPressed: () async {
                                  if(await callbackDegree2Password(pw.toString())){
                                    returnValueCallback(true);
                                    Navigator.pop(context);
                                  }else{
                                    setState((){
                                      headerViewYn = false;
                                    });

                                  }
                                }, child: Text("확인", style : TextStyle(color: Colors.white))
                                , style: ButtonStyle(backgroundColor: MaterialStateProperty.all(THEME_COLOR)),) : SizedBox(height: 50),
                                  SizedBox(height: 20),

                              ],),
                            ),]
                      ),
                    ],
                  ),
                ]
            );
          }
        )
      );
    },
  );
}