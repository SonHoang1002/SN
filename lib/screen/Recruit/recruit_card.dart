import 'package:flutter/material.dart';

class RecruitCard extends StatefulWidget {
  const RecruitCard({Key? key}) : super(key: key);

  @override
  State<RecruitCard> createState() => _RecruitCardState();
}

class _RecruitCardState extends State<RecruitCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
      child: Placeholder(),
    ));
  }
}
