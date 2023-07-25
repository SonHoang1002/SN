import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/providers/notification/notification_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

// handle push to another page when tapping
import '../../apis/notification_api.dart';
import '../../helper/push_to_new_screen.dart';
import 'noti_func.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  final scrollController = ScrollController();
  bool isLoading = true;
  bool isMore = false;

  @override
  void initState() {
    GetTimeAgo.setDefaultLocale('vi');
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId =
            ref.read(notificationControllerProvider).notifications.last['id'];
        fetchNotifications({
          "max_id": maxId,
        });
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  void fetchNotifications(params) async {
    setState(() {
      isMore = true;
    });
    await ref
        .read(notificationControllerProvider.notifier)
        .getListNotifications(params);
    setState(() {
      isMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List notifications =
        ref.watch(notificationControllerProvider).notifications;
    return Column(
      children: [
        notifications.isNotEmpty
            ? Expanded(
                child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length + 1,
                controller: scrollController,
                itemBuilder: ((context, index) {
                  return index < notifications.length ||
                          index != notifications.length
                      ? NotiItem(index: index)
                      // : isLoading && notifications.isEmpty || isMore == true
                      : Container(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          height: 50.0,
                          color: secondaryColorSelected,
                          child: const Center(
                            child: CupertinoActivityIndicator(),
                          ),
                        );
                }),
              ))
            : notifications.isEmpty
                ? Column(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/wow-emo-2.gif",
                          height: 125.0,
                          width: 125.0,
                        ),
                      ),
                      const Text('Không tìm thấy thông báo nào'),
                    ],
                  )
                : const SizedBox(),
      ],
    );
  }
}

class NotiItem extends ConsumerStatefulWidget {
  final int index;
  const NotiItem({super.key, required this.index});

  @override
  NotiItemState createState() => NotiItemState();
}

class NotiItemState extends ConsumerState<NotiItem> {
  bool read = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      read = ref
          .read(notificationControllerProvider)
          .notifications[widget.index]['read'];
    });
  }

  @override
  Widget build(BuildContext context) {
    final item = ref.watch(
      notificationControllerProvider.select(
        (e) => e.notifications[widget.index],
      ),
    );
    return InkWell(
      onTap: () async {
        if (read == false) {
          setState(() {
            read = true;
          });
          await NotificationsApi().markNotiAsRead(item['id']);
        }

        var nextScreen = nextScreenFromNoti(item);
        if (nextScreen != null) {
          pushCustomCupertinoPageRoute(context, nextScreen);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 8.0,
        ),
        decoration: BoxDecoration(
          color: read == false ? secondaryColorSelected : null,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                item['type'] == 'created_status'
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: SvgPicture.asset(
                          'assets/LogoEmso.svg',
                          width: 60,
                          height: 60,
                        ),
                      )
                    : AvatarSocial(
                        width: 60,
                        height: 60,
                        object: item['account'],
                        path: renderLinkAvatar(item),
                      ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset(
                    renderLinkSvg(item['type'], item['status']),
                    width: 24,
                    height: 24,
                  ),
                )
              ],
            ),
            const SizedBox(width: 12.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.75,
                  child: Text.rich(
                    TextSpan(
                      text: renderName(item),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      children: [
                        TextSpan(
                          text: renderContent(item, ref)['textNone'],
                          style: const TextStyle(fontWeight: FontWeight.normal),
                        ),
                        TextSpan(
                          text: renderContent(item, ref)['textBold'] ?? '',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text:
                                ' ${item['page']?["title"] ?? item['group']?["title"] ?? item['event']?["title"] ?? ""}')
                      ],
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  GetTimeAgo.parse(DateTime.parse(item['created_at'])),
                  style: const TextStyle(color: greyColor, fontSize: 12),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
