import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class CustomCupertinoAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final String cancelText;
  final VoidCallback onCancel;
  final VoidCallback onConfirm;

  const CustomCupertinoAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.cancelText,
    required this.onCancel,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Column(
        children: [
          SizedBox(height: 5),
          Text(content, style: TextStyle(fontSize: 13, color: greyColor)),
        ],
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          onPressed: onCancel,
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          onPressed: onConfirm,
          child: Text(confirmText),
        ),
      ],
    );
  }
}
