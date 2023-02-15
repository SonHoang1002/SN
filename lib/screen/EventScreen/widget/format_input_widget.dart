import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class FormatInputEventWidget extends StatelessWidget {
  final List<Widget> listWidget;

  const FormatInputEventWidget({super.key, required this.listWidget});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 5, 0, 5),
      decoration: BoxDecoration(
          // border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(children: listWidget.map((e) => e).toList()),
    );
  }
}
