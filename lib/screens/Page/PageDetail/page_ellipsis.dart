import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class PageEllipsis extends StatefulWidget {
  const PageEllipsis({super.key});

  @override
  State<PageEllipsis> createState() => _PageEllipsisState();
}

List pageEllipsis = [
  {
    "id": "report",
    "label": "Báo cáo trang cá nhân",
    "icon": "assets/pages/profileReport.png",
  },
  {
    "id": "block",
    "label": "Chặn",
    "icon": "assets/pages/block.png",
  },
  {
    "id": "search",
    "label": "Tìm kiếm",
    "icon": "assets/pages/search.png",
  },
  {
    "id": "invite",
    "label": "Mời bạn bè",
    "icon": "assets/pages/inviteFriend.png",
  },
  {
    "id": "follow",
    "label": "Theo dõi",
    "icon": "assets/pages/inviteFriend.png",
  },
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: pageEllipsis.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      ListTile(
                        horizontalTitleGap: 0,
                        dense: true,
                        leading: Image.asset(pageEllipsis[index]['icon'],
                            width: 22, height: 22, color: Colors.white),
                        title: Text(pageEllipsis[index]['label']),
                      ),
                      const Divider(height: 10, indent: 1, color: Colors.black),
                    ],
                  );
                }),
            const Text('Liên kết đến trang của ...'),
            const Text('Liên kết riêng của ... trên EMSO'),
          ],
        ),
      ),
    );
  }
}
