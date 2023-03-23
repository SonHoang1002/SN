import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/data/notification.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:get_time_ago/get_time_ago.dart';

class NotificationPage extends ConsumerStatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends ConsumerState<NotificationPage> {
  @override
  void initState() {
    GetTimeAgo.setDefaultLocale('vi');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    renderName(noti) {
      dynamic status = noti['status'];
      dynamic account = noti['account'];
      if (noti['type'] == 'event_invitation_host') {
        return status['event']?['page']?['title'] ?? account['display_name'];
      }
      return account['display_name'];
    }

    renderContent(noti) {
      dynamic status = noti['status'] ?? {};
      String type = noti['type'];

      if (type == 'folow') {
        return ' đã theo dõi bạn';
      } else if (type == 'reblog') {
        return ' đã chia sẻ bài viết của bạn';
      } else if (type == 'mention') {
        return ' đã nhắc đến bạn trong một bài viết';
      } else if (type == 'poll') {
        return ' đã bầu chọn trong cuộc thăm dò của bạn';
      } else if (type == 'friendship_request') {
        return ' đã gửi cho bạn lời mời kết bạn';
      } else if (type == 'event_invitation') {
        return ' đã gửi cho bạn lời mời tham gia sự kiện';
      } else if (type == 'event_invitation_host') {
        return ' đã mời bạn đồng tổ chức sự kiện:';
      } else if (type == 'page_follow') {
        return ' đã thích';
      } else if (type == 'page_invitation') {
        return ' đã mời bạn làm quản trị viên ';
      } else if (type == 'page_invitation_follow') {
        return ' đã mời bạn thích trang';
      } else if (type == 'group_invitation') {
        return ' đã mời bạn tham gia nhóm';
      } else if (type == 'accept_event_invitation') {
        return ' đã đồng ý tham gia sự kiện';
      } else if (type == 'accept_event_invitation_host') {
        return ' đã đồng ý đồng tổ chức sự kiện';
      } else if (type == 'accept_page_invitation') {
        return ' đã đồng ý làm quản trị viên trang';
      } else if (type == 'accept_page_invitation_follow') {
        return ' đã chấp nhận lời mời thích trang';
      } else if (type == 'accept_group_invitation') {
        return ' đã chấp nhận lời mời tham gia nhóm';
      } else if (type == 'accept_friendship_request') {
        return ' đã chấp nhận lời mời kết bạn';
      } else if (type == 'group_join_request') {
        return ' đã yêu cầu tham gia';
      } else if (type == 'created_status') {
        return ' Video của bạn đã sẵn sàng.Bây giờ bạn có thể mở xem';
      } else if (type == 'status_tag') {
        return status['in_reply_to_parent_id'] != null ||
                status['in_reply_to_id'] != null
            ? ' đã nhắc đến bạn trong một bình luận'
            : ' đã gắn thẻ bạn trong một bài viết';
      } else if (type == 'comment') {
        return ' đã bình luận về một bài viết có thể bạn quan tâm: ${status['content']}';
      } else if (type == 'approved_group_join_request') {
        return ' Quản trị viên đã phê duyệt yêu cầu tham gia của bạn. Chào mừng bạn đến với';
      }
      if (type == 'favourite') {
        return ' đã bày tỏ cảm xúc về ${status['in_reply_to_parent_id'] != null || status['in_reply_to_id'] != null ? 'bình luận:' : 'bài viết:'} ${status['page_owner'] == null && status['account']?['id'] == ref.watch(meControllerProvider)[0]['id'] ? 'của bạn' : ''} ${status['content']}';
      } else if (type == 'status') {
        if (status['reblog'] != null) {
          return ' đã chia sẻ một bài viết ${status['reblog']?['page'] != null || status['reblog']?['group'] != null ? 'trong' : ''}';
        } else if (status['page_owner'] != null) {
          return status['post_type'] == 'event_shared'
              ? ' đã tạo một sự kiện'
              : ' có một bài viết mới';
        } else if (status['group'] != null || status['page'] != null) {
          return status['post_type'] == 'event_shared'
              ? ' đã tạo một sự kiện trong'
              : 'đã tạo bài viết trong';
        } else if (status['post_type'] == 'moment') {
          return ' đã đăng một khoảnh khắc mới';
        } else if (status['post_type'] == 'moment') {
          return ' đã đăng một video mới trong watch';
        } else if (status['post_type'] == 'question') {
          return ' đã đặt một câu hỏi';
        } else if (status['post_type'] == 'target') {
          return ' đã đặt một mục tiêu mới';
        } else {
          'đã tạo bài viết mới ${status['content']}';
        }
      }
    }

    renderLinkAvatar(noti) {
      dynamic account = noti['account'];

      return account['avatar_media']['preview_url'];
    }

    renderLinkSvg(type, status) {
      switch (type) {
        case 'friendship_request':
        case 'accept_friendship_request':
          return 'assets/friend.svg';
        case 'event_invitation':
        case 'event_invitation_host':
        case 'accept_event_invitation':
        case 'accept_event_invitation_host':
          return 'assets/event.svg';
        case 'page_follow':
        case 'page_invitation':
        case 'page_invitation_follow':
        case 'accept_page_invitation':
        case 'accept_page_invitation_follow':
          return 'assets/Page.svg';
        case 'group_invitation':
        case 'group_join_request':
        case 'accept_group_invitation':
        case 'approved_group_join_request':
          return 'assers/Groups_1.svg';
        case 'status':
          if (status['post_type'] == 'event_shared') {
            return 'assets/event.svg';
          } else if (status['post_type'] == 'watch') {
            return 'assets/WatchFC.svg';
          } else if (status['post_type'] == 'moment') {
            return 'assets/moment_menu/svg';
          } else {
            return 'assets/notification.svg';
          }
        case 'mention':
          return 'assets/Friend';
        default:
          return 'assets/notification.svg';
      }
    }

    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: ((context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    decoration: BoxDecoration(
                        color: [1, 3, 5].contains(index)
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
                                    path:
                                        renderLinkAvatar(notifications[index])),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: SvgPicture.asset(
                                  renderLinkSvg(notifications[index]['type'],
                                      notifications[index]['status']),
                                  color: secondaryColor,
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
                                              notifications[index]),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.normal,
                                          )),
                                      TextSpan(
                                          text:
                                              ' ${notifications[index]['page']?["title"] ?? notifications[index]['group']?["title"] ?? notifications[index]['event']?["title"] ?? ''}')
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
