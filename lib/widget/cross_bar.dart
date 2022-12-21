import 'package:flutter/material.dart';

class CrossBar extends StatelessWidget {
  const CrossBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5,
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      color: Colors.grey.withOpacity(0.5),
    );
  }
}
