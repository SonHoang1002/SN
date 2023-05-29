import 'package:flutter/cupertino.dart';
import 'package:market_place/theme/colors.dart';

class AlertDialogApp extends StatelessWidget {
  final String title;
  final String content;
  final Function action;
  final dynamic textAction;
  const AlertDialogApp(
      {super.key,
      required this.title,
      required this.content,
      required this.action,
      this.textAction});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Huỷ', style: TextStyle(color: primaryColor)),
        ),
        CupertinoDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            action();
          },
          child: Text(
            textAction ?? 'Đồng ý',
            style: const TextStyle(color: primaryColor),
          ),
        ),
      ],
    );
  }
}
