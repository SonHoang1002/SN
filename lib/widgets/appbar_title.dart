import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;
  final Color? textColor;
  final TextStyle? textStyle;
  const AppBarTitle(
      {Key? key, required this.title, this.textColor, this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: textStyle ??
          TextStyle(
            fontSize: 18,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w600,
            color: textColor ?? Theme.of(context).textTheme.displayLarge!.color,
          ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
