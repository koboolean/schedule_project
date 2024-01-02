import 'package:flutter/material.dart';

Future<bool?> showConfirmationDialog(
    BuildContext context, String title, String message) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text("취소"),
            onPressed: () {
              Navigator.pop(context, false); // 취소 버튼 클릭시 false 반환
            },
          ),
          TextButton(
            child: const Text("확인"),
            onPressed: () {
              Navigator.pop(context, true); // 확인 버튼 클릭시 true 반환
            },
          ),
        ],
      );
    },
  );
}
