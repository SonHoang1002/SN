import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_time_ago/get_time_ago.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/notification/notification_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  final scrollController = ScrollController();

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
  }

  void fetchNotifications(params) async {
    await ref
        .read(notificationControllerProvider.notifier)
        .getListNotifications(params);
  }

  @override
  Widget build(BuildContext context) {
    List notifications =
        ref.watch(notificationControllerProvider).notifications;
    renderName(noti) {
      dynamic status = noti['status'];
      dynamic account = noti['account'];
      switch (noti['type']) {
        case 'event_invitation_host':
          return status['event']?['page']?['title'] ?? account['display_name'];
        case 'status':
          if (status != null) {
            return status['group']?['title'] ??
                status['page']?['title'] ??
                account['display_name'];
          } else {
            return account['display_name'];
          }

        default:
          return account['display_name'];
      }
    }

    dynamic renderContent(noti) {
      dynamic status = noti['status'] ?? {};
      String type = noti['type'];
      if (type == 'folow') {
        return {'textNone': ' đã theo dõi bạn'};
      } else if (type == 'reblog') {
        return {'textNone': ' đã chia sẻ bài viết của bạn'};
      } else if (type == 'mention') {
        return {'textNone': ' đã nhắc đến bạn trong một bài viết'};
      } else if (type == 'poll') {
        return {'textNone': ' đã bầu chọn trong cuộc thăm dò của bạn'};
      } else if (type == 'friendship_request') {
        return {'textNone': ' đã gửi cho bạn lời mời kết bạn'};
      } else if (type == 'event_invitation') {
        return {'textNone': ' đã gửi cho bạn lời mời tham gia sự kiện'};
      } else if (type == 'event_invitation_host') {
        return {'textNone': ' đã mời bạn đồng tổ chức sự kiện:'};
      } else if (type == 'page_follow') {
        return {'textNone': ' đã thích'};
      } else if (type == 'page_invitation') {
        return {'textNone': ' đã mời bạn làm quản trị viên '};
      } else if (type == 'page_invitation_follow') {
        return {'textNone': ' đã mời bạn thích trang'};
      } else if (type == 'group_invitation') {
        return {'textNone': ' đã mời bạn tham gia nhóm'};
      } else if (type == 'accept_event_invitation') {
        return {'textNone': ' đã đồng ý tham gia sự kiện'};
      } else if (type == 'accept_event_invitation_host') {
        return {'textNone': ' đã đồng ý đồng tổ chức sự kiện'};
      } else if (type == 'accept_page_invitation') {
        return {'textNone': ' đã đồng ý làm quản trị viên trang'};
      } else if (type == 'accept_page_invitation_follow') {
        return {'textNone': ' đã chấp nhận lời mời thích trang'};
      } else if (type == 'accept_group_invitation') {
        return {'textNone': ' đã chấp nhận lời mời tham gia nhóm'};
      } else if (type == 'accept_friendship_request') {
        return {'textNone': ' đã chấp nhận lời mời kết bạn'};
      } else if (type == 'group_join_request') {
        return {'textNone': ' đã yêu cầu tham gia'};
      } else if (type == 'created_status') {
        return {
          'textNone': ' Video của bạn đã sẵn sàng.Bây giờ bạn có thể mở xem'
        };
      } else if (type == 'status_tag') {
        return {
          'textNone': status['in_reply_to_parent_id'] != null ||
                  status['in_reply_to_id'] != null
              ? ' đã nhắc đến bạn trong một bình luận'
              : ' đã gắn thẻ bạn trong một bài viết'
        };
      } else if (type == 'comment') {
        return {
          'textNone':
              ' đã bình luận về một bài viết có thể bạn quan tâm: ${status['content']}'
        };
      } else if (type == 'approved_group_join_request') {
        return {
          'textNone':
              ' Quản trị viên đã phê duyệt yêu cầu tham gia của bạn. Chào mừng bạn đến với'
        };
      } else if (type == 'course_invitation') {
        return {'textNone': ' đã mời bạn tham gia khóa học'};
      } else if (type == 'product_invitation') {
        return {'textNone': ' đã mời bạn quan tâm đến sản phẩm'};
      } else if (type == 'admin_page_invitation') {
        return {
          'textNone': ' đã mời bạn làm quản trị viên',
          'textBold': '${status?['page']?['title']}'
        };
      } else if (type == 'approved_group_status') {
        return {
          'textNone':
              '  bài viết của bạn tại ${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']} đã được phê duyệt',
        };
      } else if (type == 'accept_admin_page_invitation') {
        return {
          'textNone': ' đã đồng ý làm quản trị viên trang',
          'textBold': '${status?['page']?['title']}'
        };
      } else if (type == 'recruit_apply') {
        return {
          'textNone': ' đã ứng tuyển vào công việc',
          'textBold': '${status?['recruit']?['title']}'
        };
      } else if (type == 'recruit_invitation') {
        return {
          'textNone': ' đã mời bạn tham gia tuyển dụng',
          'textBold': '${status?['recruit']?['title']}'
        };
      } else if (type == 'moderator_page_invitation') {
        return {
          'textNone': ' đã đồng ý làm kiểm duyệt viên trang',
          'textBold': '${status?['page']?['title']}'
        };
      }
      if (type == 'favourite') {
        return {
          'textNone':
              ' đã bày tỏ cảm xúc về ${status['in_reply_to_parent_id'] != null || status['in_reply_to_id'] != null ? 'bình luận:' : 'bài viết:'} ${status['page_owner'] == null && status['account']?['id'] == ref.watch(meControllerProvider)[0]['id'] ? 'của bạn' : ''} ${status['content']}'
        };
      } else if (type == 'status') {
        if (status != null) {
          if (status['reblog'] != null) {
            return {
              'textNone':
                  ' đã chia sẻ một bài viết ${status['reblog']?['page'] != null || status['reblog']?['group'] != null ? 'trong' : ''}'
            };
          } else if (status['page_owner'] != null) {
            return {
              'textNone': status['post_type'] == 'event_shared}'
                  ? ' đã tạo một sự kiện '
                  : ' có một bài viết mới: ${status['content']} '
            };
          } else if (status['group'] != null || status['page'] != null) {
            if (noti['account']['relationship'] != null &&
                noti['account']['relationship']['friendship_status'] ==
                    'ARE_FRIENDS') {
              return {
                'textNone': status['post_type'] == 'event_shared}'
                    ? ' đã tạo một sự kiện trong '
                    : ' có tạo bài viết trong ',
                'textBold': status['post_type'] == 'event_shared}'
                    ? '${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']}'
                    : '${status['group'] != null ? 'nhóm' : 'trang'} ${status['group'] != null ? status['group']['title'] : status['page']['title']}'
              };
            } else {
              return {
                'textNone': status['post_type'] == 'event_shared}'
                    ? ' có sự kiện mới: ${status['content'] ?? ""}'
                    : ' có bài viết mới: ${status['content'] ?? ""}'
              };
            }
          } else if (status['post_type'] == 'moment') {
            return {'textNone': ' đã đăng một khoảnh khắc mới'};
          } else if (status['post_type'] == 'watch') {
            return {'textNone': ' đã đăng một video mới trong watch'};
          } else if (status['post_type'] == 'question') {
            return {'textNone': ' đã đặt một câu hỏi'};
          } else if (status['post_type'] == 'target') {
            return {'textNone': ' đã đặt một mục tiêu mới'};
          } else {
            return {
              'textNone': ' đã tạo bài viết mới ${status['content'] ?? ""}'
            };
          }
        }
      } else {
        return {'textNone': ' đã tạo bài viết mới'};
      }
    }

    renderLinkAvatar(noti) {
      dynamic account = noti['account'];

      return account['avatar_media']['preview_url'];
    }

    renderLinkSvg(type, status) {
      switch (type) {
        case 'mention':
          return 'assets/Noti/Friend.png';
        case 'status':
          if (status != null) {
            if (status?['group'] != null) {
              return 'assets/Noti/group.png';
            } else if (status?['page'] != null) {
              return 'assets/Noti/Page.png';
            } else if (status?['post_type'] == 'event_shared') {
              return 'assets/Noti/event.png';
            } else if (status?['post_type'] == 'watch') {
              return 'assets/Noti/watch.png';
            } else if (status?['post_type'] == 'moment') {
              return 'assets/Noti/moment.png';
            } else {
              return 'assets/Noti/post.png';
            }
          } else {
            return 'assets/Noti/post.png';
          }

        case 'friendship_request':
        case 'accept_friendship_request':
          return 'assets/Noti/Friend.png';
        case 'event_invitation':
        case 'event_invitation_host':
        case 'accept_event_invitation':
        case 'accept_event_invitation_host':
          return 'assets/Noti/event.png';
        case 'page_follow':
        case 'page_invitation':
        case 'page_invitation_follow':
        case 'accept_page_invitation':
        case 'accept_page_invitation_follow':
        case 'accept_moderator_page_invitation':
        case 'accept_admin_page_invitation':
          return 'assets/Noti/Page.png';
        case 'group_invitation':
        case 'group_invitation_host':
        case 'group_join_request':
        case 'accept_group_invitation':
        case 'approved_group_join_request':
          return 'assets/Noti/group.png';
        case 'comment':
          return 'assets/Noti/comment.png';
        case 'status_tag':
          return 'assets/Noti/post.png';
        case 'created_status':
          return 'assets/Noti/livestream.png';
        default:
          return 'assets/Noti/Noti.png';
      }
    }

    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                controller: scrollController,
                itemBuilder: ((context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                        color: !notifications[index]['read']
                            ? secondaryColorSelected
                            : null),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            notifications[index]['type'] == 'created_status'
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: SvgPicture.asset(
                                      'assets/LogoEmso.svg',
                                      width: 60,
                                      height: 60,
                                    ))
                                : AvatarSocial(
                                    width: 60,
                                    height: 60,
                                    object: notifications[index]['account'],
                                    path:
                                        renderLinkAvatar(notifications[index])),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Image.asset(
                                  renderLinkSvg(notifications[index]['type'],
                                      notifications[index]['status']),
                                  width: 24,
                                  height: 24,
                                ))
                          ],
                        ),
                        const SizedBox(
                          width: 12.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.75,
                              child: Text.rich(
                                TextSpan(
                                    text: renderName(notifications[index]),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500),
                                    children: [
                                      TextSpan(
                                          text: renderContent(
                                              notifications[index])['textNone'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          )),
                                      TextSpan(
                                          text: renderContent(
                                                      notifications[index])[
                                                  'textBold'] ??
                                              '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          )),
                                      TextSpan(
                                          text:
                                              ' ${notifications[index]['page']?["title"] ?? notifications[index]['group']?["title"] ?? notifications[index]['event']?["title"] ?? ""}')
                                    ]),
                              ),
                            ),
                            const SizedBox(
                              height: 4.0,
                            ),
                            Text(
                                GetTimeAgo.parse(DateTime.parse(
                                  notifications[index]['created_at'],
                                )),
                                style: const TextStyle(
                                    color: greyColor, fontSize: 12))
                          ],
                        )
                      ],
                    ),
                  );
                }))),
      ],
    );
  }
}
