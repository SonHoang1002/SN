import 'package:flutter/material.dart';

class AppbarTitle extends StatelessWidget {
  final String title;
  const AppbarTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 18,
          overflow: TextOverflow.ellipsis,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).textTheme.displayLarge!.color),
    );
  }
}
