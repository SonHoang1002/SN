import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppBarTitle extends StatelessWidget {
  final String title;

  // ignore: use_key_in_widget_constructors
  const AppBarTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).textTheme.displayLarge?.color),
    );
  }
}
