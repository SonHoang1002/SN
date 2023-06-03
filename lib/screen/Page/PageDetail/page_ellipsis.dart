import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';

import '../../../widget/EmsoIcons/emso_icons.dart';

class PageEllipsis extends StatefulWidget {
  const PageEllipsis({super.key});

  @override
  State<PageEllipsis> createState() => _PageEllipsisState();
}

List pageEllipsis = [
  {
    "id": "report",
    "label": "Báo cáo trang cá nhân",
  },
  {},
  {},
  {},
];

class _PageEllipsisState extends State<PageEllipsis> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Quản lý'),
      ),
      body: Row(
        children: const [
          Icon(EmsoIcons.squareExclamation),
          Icon(FontAwesomeIcons.squareArrowUpRight),
        ],
      ),
    );
  }
}
