import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildCustomCupertinoAlertDialog(BuildContext context, String message) {
  return CupertinoAlertDialog(
    content: Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    ),
    actions: <CupertinoDialogAction>[
      CupertinoDialogAction(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('Xác nhận'),
      ),
    ],
  );
}
