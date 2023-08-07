
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:social_network_app_mobile/screens/Group/GroupFeed/group.dart';
import 'package:social_network_app_mobile/screens/Group/group_approval.dart';

import '../../constant/common.dart';
import '../../constant/post_type.dart';
import '../../providers/me_provider.dart';
import '../CreatePost/create_modal_base_menu.dart';
import '../Event/event_detail.dart';
import '../Friend/friend_request.dart';
import '../Grows/grow_detail.dart';
import '../LearnSpace/learn_space_detail.dart';
import '../Page/PageDetail/page_detail.dart';
import '../Page/page_invite.dart';
import '../Post/post_detail.dart';
import '../Recruit/recuit_detail.dart';
import 'deleted_status.dart';

renderLinkAvatar(noti) {
  dynamic account = noti['account'];

  return account['avatar_media'] != null
      ? account['avatar_media']['preview_url']
      : linkAvatarDefault;
}

dynamic renderContent(noti, WidgetRef ref) {
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
    return {'textNone': ' Video của bạn đã sẵn sàng.Bây giờ bạn có thể mở xem'};
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
          ' đã bình luận về một bài viết có thể bạn quan tâm: ${status['content'] ?? ''}'
    };
  } else if (type == 'approved_group_join_request') {
    return {
      'textNone':
          ' Quản trị viên đã phê duyệt yêu cầu tham gia của bạn. Chào mừng bạn đến với'
    };
  } else if (type == 'course_invitation') {
    return {
      'textNone': ' đã mời bạn tham gia khóa học ',
      'textBold': '${noti['course']['title']}',
    };
  } else if (type == 'product_invitation') {
    return {'textNone': ' đã mời bạn quan tâm đến sản phẩm'};
  } else if (type == 'admin_page_invitation') {
    return {
      'textNone': ' đã mời bạn làm quản trị viên trang',
      'textBold': '',
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
      'textBold': ' ${noti?['recruit']?['title']}'
    };
  } else if (type == 'recruit_invitation') {
    return {
      'textNone': ' đã mời bạn tham gia tuyển dụng ',
      'textBold': '${noti['recruit']?['title']}'
    };
  } else if (type == 'moderator_page_invitation') {
    return {
      'textNone': ' đã mời bạn làm kiểm duyệt viên trang',
      'textBold': ''
    };
  } else if (type == 'accept_moderator_page_invitation') {
    return {'textNone': ' đã đồng ý làm kiểm duyệt viên trang', 'textBold': ''};
  }
  if (type == 'favourite') {
    return {
      'textNone':
          ' đã bày tỏ cảm xúc về ${status['in_reply_to_parent_id'] != null || status['in_reply_to_id'] != null ? 'bình luận:' : 'bài viết:'} ${status['page_owner'] == null && status['account']?['id'] == ref.watch(meControllerProvider)[0]['id'] ? 'của bạn' : ''} ${status['content'] ?? ''}'
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
        return {'textNone': ' đã tạo bài viết mới ${status['content'] ?? ""}'};
      }
    }
  } else {
    return {'textNone': ' đang chờ phê duyệt bài viết tại ',
      'textBold': '${status['group']?['title']}',};
  }
}

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

Widget? nextScreenFromNoti(item) {
  switch (item['type']) {
    case 'comment':
    // đã bình luận về một bài viết có thể bạn quan tâm
    case 'favourite':
    // đã bày tỏ cảm xúc về
    case 'created_status':
    // Video của bạn đã sẵn sàng.Bây giờ bạn có thể mở xemc
    case 'approved_group_status':
    // bài viết của bạn tại nhóm/trang đã được phê duyệt',
    case 'status_tag':
    case 'mention':
    // đã nhắc đến bạn trong một bình luận, đã gắn thẻ bạn trong một bài viết
    case 'reblog':
    case 'status':
      return item['status'] != null
          ? PostDetail(
              postId: item['status']['id'],
              preType: postDetail,
            )
          : const DeletedStatus(type: "Bài viết");

    case 'friendship_request':
      return const FriendRequest();

    case 'recruit_invitation':
    // đã mời quan tâm công việc',
    case 'recruit_apply':
      // đã ứng tuyển vào công việc',
      return item['recruit'] != null
          ? RecruitDetail(data: item['recruit'])
          : const DeletedStatus(type: "Công việc");

    case 'event_invitation':
    case 'event_invitation_host':
    case 'accept_event_invitation':
    // đã đồng ý tham gia sự kiện
    case 'accept_event_invitation_host':
      // đã đồng ý đồng tổ chức sự kiện
      return item['event'] != null
          ? EventDetail(eventDetail: item['event'])
          : const DeletedStatus(type: "Sự kiện");

    case 'course_invitation':
      return item['course'] != null
          ? LearnSpaceDetail(data: item['course'])
          : const DeletedStatus(type: "Khóa học");

    case 'project_invitation':
    case 'project_invitation_host':
      return item['project'] != null
          ? GrowDetail(data: item['project'])
          : const DeletedStatus(type: "Khóa học");

    case 'page_invitation':
    // đã mời bạn like page
    case 'moderator_page_invitation':
    // đã invite you làm kiểm duyệt viên trang',
    case 'admin_page_invitation':
    // đã mời bạn làm quản trị viên',
    case 'page_invitation_follow':
      // đã mời bạn follow page
      return const CreateModalBaseMenu(
        title: 'Lời mời',
        body: PageInvite(),
        buttonAppbar: SizedBox(),
      );

    case 'accept_page_invitation':
    // đã đồng ý làm quản trị viên trang
    case 'accept_page_invitation_follow':
    // đã chấp nhận lời mời thích trang
    case 'accept_admin_page_invitation':
    // đã đồng ý làm quản trị viên trang',
    case 'page_follow':
    // đã thích your page (not yet)
    case 'accept_moderator_page_invitation':
      return item['page'] != null
          ? PageDetail(pageData: item['page'])
          : const DeletedStatus(type: "Trang");

    case 'poll':
      // Thăm dò ý kiến
      return item['status'] != null
          ? PostDetail(
              postId: item['status']['id'],
              preType: postDetail,
            )
          : const DeletedStatus(type: "Cuộc thăm dò ý kiến");

    case 'group_invitation':
    // đã mời bạn tham gia nhóm
    case 'group_invitation_host':
      return const CreateModalBaseMenu(
        title: 'Lời mời & Yêu cầu',
        body: Group(), // true: GroupInviteRequest()
        buttonAppbar: SizedBox(),
      );

    case 'accept_friendship_request':
    // đã chấp nhận lời mời kết bạn
    case 'folow':
    // ... followed you.
    // return UserPage(user: item['account']);

    case 'accept_group_invitation':
    // đã chấp nhận lời mời tham gia nhóm
    case 'approved_group_join_request':
    // Quản trị viên đã phê duyệt yêu cầu tham gia của bạn. Chào mừng bạn đến với'
    // return GroupDetail()
    case 'group_pending_status':
    // Đang chờ phê duyệt bài duyệt
    return item["status"] != null?  GroupApproval(groupID: item!["status"]?["group"]?["id"]) : const DeletedStatus(type: "Bài viết đang chờ phê duyệt");

    default:
      return null;
  }
}
