import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/screen/Event/CreateEvent/map_event.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class MeetingEvent extends StatefulWidget {
  final dynamic checkinSelected;
  final Function(List<dynamic>) onCheckinSelectedChanged;
  const MeetingEvent({
    super.key,
    this.checkinSelected,
    required this.onCheckinSelectedChanged,
  });

  @override
  MeetingEventState createState() => MeetingEventState();
}

List meetingOnline = [
  {
    'id': 0,
    'key': 'meeting-room',
    'label': 'Phòng họp mặt trên messenger',
    'subLabel':
        'Họp mặt qua tính năng chat video. Mọi người có thể tham gia phòng họp mặt ngay từ trang sự kiện.',
    'icon': FontAwesomeIcons.xmark
  },
  {
    'id': 1,
    'key': 'facebook-live',
    'label': 'Facebook Live',
    'subLabel':
        'Lên lịch phát trực tiếp sự kiện của bạn bằng Facebook Live để mọi người cùng xem.',
    'icon': FontAwesomeIcons.xmark
  },
  {
    'id': 2,
    'key': 'outside-link',
    'label': 'Liên kết bên ngoài',
    'subLabel':
        'Thêm liên kết để mọi người biết cần truy cập vào đâu khi sự kiện bắt đầu.',
    'icon': FontAwesomeIcons.xmark
  },
  {
    'id': 3,
    'key': 'other',
    'label': 'Khác',
    'subLabel': 'Thêm hướng dẫn vào phần chi tiết sự kiện để rõ cách tham gia.',
    'icon': FontAwesomeIcons.xmark
  }
];

class MeetingEventState extends State<MeetingEvent>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 1, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: TabBar(
                unselectedLabelColor: Colors.black,
                labelColor: secondaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Gặp mặt trực tiếp'),
                  // Tab(text: 'Trên mạng'),
                ],
                controller: _tabController,
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MapEvent(
                      checkinSelected: widget.checkinSelected,
                      onCheckinSelectedChanged:
                          widget.onCheckinSelectedChanged),
                  // ListView.builder(
                  //     scrollDirection: Axis.vertical,
                  //     shrinkWrap: true,
                  //     physics: const NeverScrollableScrollPhysics(),
                  //     itemCount: meetingOnline.length,
                  //     itemBuilder: ((context, index) {
                  //       return ListTile(
                  //         leading: meetingOnline[index]['icon'],
                  //         title: Text(meetingOnline[index]['label']),
                  //         subtitle: Text(meetingOnline[index]['subLabel']),
                  //         trailing: Radio(
                  //             groupValue: '',
                  //             value: meetingOnline[index]['key'],
                  //             onChanged: (value) {}),
                  //       );
                  //     }))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
