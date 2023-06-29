import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/providers/group/group_list_provider.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';

class ManagerDetail extends ConsumerStatefulWidget {
  final dynamic groupDetail;

  const ManagerDetail({Key? key, required this.groupDetail}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ManagerDetail> createState() => _ManagerDetailState();
}

class _ManagerDetailState extends ConsumerState<ManagerDetail> {
  List requestManager = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      requestManager = [
        {
          'key': 'content',
          'label': 'Nội dung bị báo cáo',
          'icon': 'assets/groups/contentReport.png',
          'noti':
              '${ref.read(groupListControllerProvider).contentReported.length}',
        },
        {
          'key': 'waiting',
          'label': 'Đang chờ phê duyệt',
          'icon': 'assets/groups/waitingRequest.png',
          'noti':
              '${ref.read(groupListControllerProvider).waitingApproval.length}',
        },
        {
          'key': 'member',
          'label': 'Yêu cầu làm thành viên',
          'icon': 'assets/groups/requestMember.png',
          'noti':
              '${ref.read(groupListControllerProvider).requestMember.length}',
        },
        {
          'key': 'noti',
          'label': 'Thông báo kiểm duyệt',
          'icon': 'assets/groups/notiRequest.png',
          'noti':
              '${ref.read(groupListControllerProvider).notiApproval.length}',
        },
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: AppBarTitle(
          title: widget.groupDetail['title'] ?? '',
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          color: theme.isDarkMode ? Colors.grey[800] : Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cần xét duyệt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: theme.isDarkMode ? Colors.black : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: requestManager.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      color: Colors.grey,
                      thickness: 1,
                      indent: 56,
                      endIndent: 10,
                    ),
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 0.0,
                        ),
                        visualDensity: const VisualDensity(
                          horizontal: -4,
                          vertical: -1,
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.asset(
                            requestManager[index]['icon'],
                            width: 18,
                            height: 18,
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        title: Text(requestManager[index]['label']),
                        subtitle: RichText(
                          text: TextSpan(
                            children: [
                              if (int.parse(requestManager[index]['noti']) > 0)
                                const WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 4.0, right: 3.0),
                                    child: Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              TextSpan(
                                  text:
                                      '${requestManager[index]['noti']} mục mới hôm nay',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  )),
                            ],
                          ),
                        ),
                        trailing: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(requestManager[index]['noti']),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Lối tắt đến công cụ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/settingGroup.png',
                  title: 'Chat cộng đồng',
                  subtitle: '4 gợi ý chat dành cho nhóm của bạn',
                ),
                const SizedBox(
                  height: 5,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/activityLog.png',
                  title: 'Nhật ký hoạt động',
                ),
                const SizedBox(
                  height: 5,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/scheduledStatus.png',
                  title: 'Bài viết đã lên lịch',
                ),
                const SizedBox(
                  height: 5,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/rulesGroup.png',
                  title: 'Quy tắc nhóm',
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Cài đặt',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/settingGroup.png',
                  title: 'Cài đặt nhóm',
                  subtitle: 'Quản lý cuộc thảo luận, quyền và vai trò',
                ),
                const SizedBox(
                  height: 5,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/addFeature.png',
                  title: 'Thêm tính năng',
                  subtitle:
                      'Chọn định dạng bài viết, huy hiệu và các tính năng khác',
                ),
                const SizedBox(
                  height: 5,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/settingProfile.png',
                  title: 'Cài đặt cá nhân',
                  subtitle: 'Thay đổi thông báo và xem nội dung cá nhân',
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Hỗ trợ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/centerHelper.png',
                  title: 'Trung tâm hỗ trợ',
                ),
                const SizedBox(
                  height: 5,
                ),
                const FeatureItem(
                  imagePath: 'assets/groups/centerCommunity.png',
                  title: 'Trung tâm cộng đồng',
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final String? subtitle;

  const FeatureItem({
    Key? key,
    required this.imagePath,
    required this.title,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.isDarkMode ? Colors.black : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 0.0,
        ),
        visualDensity: const VisualDensity(
          horizontal: -4,
          vertical: 0,
        ),
        leading: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Image.asset(
            imagePath,
            width: 18,
            height: 18,
            color: theme.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: const TextStyle(color: Colors.grey),
              )
            : null,
      ),
    );
  }
}
