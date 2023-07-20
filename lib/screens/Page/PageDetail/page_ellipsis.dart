import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/screens/Page/PageDetail/page_search.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/page_action.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/page_activity.dart';
import 'package:social_network_app_mobile/screens/Page/PageEdit/page_edit.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/report_category.dart';

import '../../../apis/config.dart';
import '../../../apis/page_api.dart';
import '../../../providers/page/page_provider.dart';
import '../../../theme/theme_manager.dart';
import '../../../widgets/button_primary.dart';
import '../../../widgets/modal_invite_friend.dart';
import '../../../widgets/show_modal_message.dart';

class PageEllipsis extends ConsumerStatefulWidget {
  final dynamic data;
  final bool? rolePage;
  final Function? handleChangeDependencies;
  const PageEllipsis(
      {Key? key, this.data, this.rolePage, this.handleChangeDependencies})
      : super(key: key);

  @override
  ConsumerState<PageEllipsis> createState() => _PageEllipsisState();
}

class _PageEllipsisState extends ConsumerState<PageEllipsis> {
  List<Map<String, dynamic>> pageEllipsis = [];
  dynamic dataPage = {};

  @override
  void initState() {
    super.initState();
    dataPage = widget.data;
    updatePageEllipsis();
  }

  void updatePageEllipsis() {
    setState(() {
      pageEllipsis =
          widget.data?['page_relationship']?['role'] != '' && widget.rolePage!
              ? [
                  {
                    "key": "edit",
                    "label": "Chỉnh sửa",
                    "icon": "assets/pages/edit.png",
                  },
                  {
                    "key": "action",
                    "label": "Thêm nút hành động",
                    "icon": "assets/pages/addAction.png",
                  },
                  {
                    "key": "activity",
                    "label": "Nhật ký hoạt động",
                    "icon": "assets/pages/activityLog.png",
                  },
                  {
                    "key": "setting",
                    "label": "Cài đặt Trang và gắn thẻ",
                    "icon": "assets/pages/settingPage.png",
                  },
                  {
                    "key": "private",
                    "label": "Trung tâm quyền riêng tư",
                    "icon": "assets/pages/privateCenter.png",
                  },
                  {
                    "key": "search",
                    "label": "Tìm kiếm",
                    "icon": "assets/pages/search.png",
                  },
                  {
                    "key": "invite",
                    "label": "Mời bạn bè",
                    "icon": "assets/pages/inviteFriend.png",
                  },
                ]
              : [
                  {
                    "key": "report",
                    "label": "Báo cáo trang cá nhân",
                    "icon": "assets/pages/profileReport.png",
                  },
                  {
                    "key": "block",
                    "label": "Chặn",
                    "icon": "assets/pages/block.png",
                  },
                  {
                    "key": "search",
                    "label": "Tìm kiếm",
                    "icon": "assets/pages/search.png",
                  },
                  {
                    "key": "invite",
                    "label": "Mời bạn bè",
                    "icon": "assets/pages/inviteFriend.png",
                  },
                  {
                    "key": "follow",
                    "label": dataPage['page_relationship']['following'] == true
                        ? "Đang theo dõi"
                        : "Theo dõi",
                    "icon": dataPage['page_relationship']['following'] == true
                        ? "assets/pages/pageFollowing.png"
                        : "assets/pages/inviteFriend.png",
                  },
                ];
    });
  }

  void handlePress(key, context, index) {
    switch (key) {
      case 'report':
        showBarModalBottomSheet(
            context: context,
            builder: (context) =>
                ReportCategory(entityType: 'page', entityReport: widget.data));
        break;
      case 'invite':
        showBarModalBottomSheet(
            context: context,
            builder: (context) =>
                InviteFriend(id: widget.data['id'], type: 'page'));
        break;
      case 'search':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageSearch(data: dataPage)));
        break;
      case 'block':
        showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Chặn ${widget.data['title']}?'),
            content: Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text('${widget.data['title']} sẽ không thể: ',
                    style: const TextStyle(fontSize: 13, color: greyColor)),
                const SizedBox(
                  height: 10,
                ),
                widgetRenderText('Xem bài viết của bạn'),
                widgetRenderText('Gắn thẻ bạn'),
                widgetRenderText('Mời bạn tham gia nhóm hoặc sự kiện'),
                widgetRenderText('Trò chuyện với bạn'),
                widgetRenderText('Thêm bạn làm bạn bè'),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  ' Nếu các bạn là bạn bè, việc chặn ${widget.data['title']} cũng sẽ huỷ kết bạn với họ.',
                  style: const TextStyle(fontSize: 13, color: greyColor),
                ),
              ],
            ),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Huỷ'),
              ),
              CupertinoDialogAction(
                onPressed: () async {
                  await PageApi().blockPage({'page_id': widget.data['id']});
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
                child: const Text('Chặn'),
              ),
            ],
          ),
        );
        break;
      case 'follow':
        ref.read(pageControllerProvider.notifier).updateLikeFollowPageDetail(
            widget.data['id'],
            widget.data['page_relationship']['following'] == true
                ? 'unfollow'
                : 'follow');
        setState(() {
          dataPage = {
            ...dataPage,
            'page_relationship': {
              ...dataPage['page_relationship'],
              'following': dataPage['page_relationship']['following'] == true
                  ? false
                  : true
            }
          };
        });
        updatePageEllipsis();
        break;
      case 'edit':
        // Lấy data pag mới nếu đã được người dùng edit
        var pageInfo = ref.read(pageControllerProvider).pageDetail;
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageEdit(
                    data: pageInfo ?? widget.data,
                    handleChangeDependencies:
                        widget.handleChangeDependencies)));
        break;
      case 'action':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageAction(
                    data: widget.data,
                    handleChangeDependencies:
                        widget.handleChangeDependencies)));
        break;
      case 'activity':
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageActivity(
                      data: widget.data,
                    )));
        break;
      default:
    }
  }

  widgetRenderText(String value) {
    return RichText(
      text: TextSpan(
        text: '\u2022 ',
        style: const TextStyle(fontSize: 14, color: greyColor),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontSize: 12, color: greyColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 0.0),
                        visualDensity:
                            const VisualDensity(horizontal: -4, vertical: -4),
                        horizontalTitleGap: 0,
                        dense: true,
                        leading: Image.asset(pageEllipsis[index]['icon'],
                            width: 20,
                            height: 20,
                            color:
                                theme.isDarkMode ? Colors.white : Colors.black),
                        title: Text(pageEllipsis[index]['label']),
                        onTap: () {
                          handlePress(
                              pageEllipsis[index]['key'], context, index);
                        },
                      ),
                      Divider(
                        thickness: 1,
                        indent: index == pageEllipsis.length - 1 ? 0 : 48,
                      ),
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Liên kết đến trang của ${widget.data['title']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text('Liên kết riêng của ${widget.data['title']} trên EMSO'),
                ],
              ),
            ),
            const Divider(
              height: 20,
              thickness: 1,
              indent: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                '$urlWebEmso/page/${widget.data['id']}',
                style: TextStyle(
                    fontSize: 14,
                    color: theme.isDarkMode ? Colors.white : Colors.black),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 16, right: 16),
                child: ButtonPrimary(
                  handlePress: () {
                    Clipboard.setData(ClipboardData(
                        text: '$urlWebEmso/page/${widget.data['id']}'));
                    showSnackbar(context, 'Đã sao chép liên kết');
                  },
                  label: 'Sao chép liên kết',
                  fontSize: 12,
                  colorText: theme.isDarkMode ? Colors.white : Colors.black,
                  min: MainAxisSize.min,
                  minimumSize: MaterialStateProperty.all(const Size(20, 20)),
                  paddingButton:
                      MaterialStateProperty.all(const EdgeInsets.all(8)),
                  colorBorder: theme.isDarkMode ? Colors.white : Colors.black,
                  colorButton: transparent,
                )),
          ],
        ),
      ),
    );
  }
}
