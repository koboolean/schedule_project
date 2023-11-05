import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:provider/provider.dart';

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
        widget.onTap(widget.value);
      },
      child: Container(
        child: AspectRatio(aspectRatio: 2,
            child: Container(
              child: Center(
                child: widget.label == 'backspace' ?
                Icon(Icons.keyboard_backspace) :
                Text(
                  widget.label.toString(),
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
        )
      ),
    );
  }
}

Future<void> passwordDialog(BuildContext context) {
  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', 'backspace'],
  ];

  renderKeyboard() {
    return keys
        .map(
          (x) => Row(
        children: x.map((y) {
          return Expanded(
            child: KeyboardKey(
              label: y,
              onTap: (val) {},
              value: y,
            ),
          );
        }).toList(),
      ),
    ).toList();
  }

  return showDialog<void>(
    context: context,
    barrierDismissible: false, // 바깥 여백 터치시 대화 상자를 닫을 수 있는지 여부
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Expanded(
               child:
                Column(children: [
                  ...renderKeyboard(),
                ],),
            ),
          ],
        ),
      );
    },
  );
}