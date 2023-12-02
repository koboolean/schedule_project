import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:provider/provider.dart';
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

Future<void> passwordDialog(BuildContext context) {
  var pw = "";
  var pwMark = ['-','-','-','-'];

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
                    // 저장을 수행한다.
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
                                Text("암호를 입력해주세요", style: TextStyle(
                                    fontSize: 15,
                                    letterSpacing: 5
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
                                SizedBox(height: 15),
                                ...renderKeyboard(setState),
                                SizedBox(height: 30)
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