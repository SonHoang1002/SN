import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class ManagerDetail extends StatefulWidget {
  final dynamic groupDetail;
  const ManagerDetail({super.key, this.groupDetail});

  @override
  State<ManagerDetail> createState() => _ManagerDetailState();
}

List requestManager = [
  {
    'key': 'content',
    'label': 'Nội dung bị báo cáo',
    'icon': 'assets/groups/contentReport.png',
  },
  {
    'key': 'waiting',
    'label': 'Đang chờ phê duyệt',
    'icon': 'assets/groups/waitingRequest.png',
  },
  {
    'key': 'member',
    'label': 'Yêu cầu làm thành viên',
    'icon': 'assets/groups/requestMember.png',
  },
  {
    'key': 'noti',
    'label': 'Thông báo kiểm duyệt',
    'icon': 'assets/groups/notiRequest.png',
  },
  {
    'key': 'spam',
    'label': 'Có thể là spam',
    'icon': 'assets/groups/canSpam.png',
  },
  {
    'key': 'armorial',
    'label': 'Yêu cầu huy hiệu',
    'icon': 'assets/groups/requestArmorial.png',
  },
];

class _ManagerDetailState extends State<ManagerDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: widget.groupDetail['title'] ?? '',
        ),
      ),
      body: Container(
        width: double.infinity,
        color: Colors.grey[800],
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cần xét duyệt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8)),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: requestManager.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 0.0),
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -1),
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            requestManager[index]['icon'],
                            width: 18,
                            height: 18,
                          ),
                        ),
                        title: Text(requestManager[index]['label']),
                      );
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
