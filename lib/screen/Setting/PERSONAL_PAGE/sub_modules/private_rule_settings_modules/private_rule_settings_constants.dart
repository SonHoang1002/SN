import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';

class PrivateRuleSettingsCommons {
  static const PRIVATE_RULES_APPBAR_TITLE = "Cài đặt quyền riêng tư";

  static const Map<String, dynamic> PRIVATE_RULE_SHORTCUT = {
    "key": "private_rule_shortcut",
    "title": "Lối tắt quyền riêng tư",
    "data": [
      {
        "key": "check_out_a_few_important_settings",
        "subTitle": "Kiểm tra một vài cài đặt quan trọng",
        "content":
            "Hãy xem lại nhanh một số cài đặt quan trọng để đảm bảo bạn đang chia sẻ với những người mình muốn",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "manage_personal_page",
        "subTitle": "Quản lý trang cá nhân",
        "content":
            "Đi đến trang cá nhân để thay đổi quyền riêng tư của thông tin trên trang cá nhân, ví dụ như ai mới được xem ngày sinh hoặc các mối quan hệ của bạn",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "learn_more_with_privacy_basics",
        "subTitle": "Tìm hiểu thêm với Quyền riêng tư cơ bản",
        "content":
            "Xem bản hướng dẫn mang tính tương tác này để được giải đáp các thắc mắc phổ biến",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
    ]
  };

  static const Map<String, dynamic> ACTIVITY_OF_YOU = {
    "key": "activity_of_you",
    "title": "Hoạt động của bạn",
    "data": [
      {
        "key": "who_can_see_your_posts_in_the_future",
        "subTitle": "Ai có thể xem bài viết của bạn trong tương lai ?",
        "content": "Bạn bè or Công khai ...",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "limit_who_can_see_old_posts",
        "subTitle": "Giới hạn ai có thể xem bài viết cũ",
        "content": "",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "who_can_see_the_people,_ages_and_lists_you_follow",
        "subTitle":
            "Ai có thể nhìn thấy những người, Trang và danh sách mà bạn theo dõi ?",
        "content": "Chỉ mình tôi or bạn bè ,....",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "who_can_see_your_footage_in_the_future",
        "subTitle": "Ai có thể xem thước phim của bạn trong tương lai ?",
        "content": "Công khai or bạn bè ,....",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
    ]
  };

  static const Map<String, dynamic> WAY_TO_FIND_AND_CONTACT_WITH_YOU = {
    "key": "way_to_find_and_contact_with_you",
    "title": "Cách mọi người tìm và liên hệ với bạn",
    "data": [
      {
        "key": "who_can_send_friend_requests?",
        "subTitle": "Ai có thể gửi lời mời kết bạn ?",
        "content": "Mọi người",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "who_can_see_your_friends_list",
        "subTitle": "Ai có thể xem danh sách bạn bè của bạn ?",
        "content": "Chỉ mình tôi ( thêm lưu ý bên trên )",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "who_can_search_for_you_using_the_email_address_you_provide",
        "subTitle":
            "Ai có thể tìm kiếm bạn bằng địa chỉ email mà bạn cung cấp ?",
        "content": "Mọi người",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key": "who_can_search_you_using_the_phone_number_you_provide",
        "subTitle":
            "Ai có thể tìm kiếm bạn bằng số điện thoại mà bạn cung cấp ?",
        "content": "Mọi người",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
      {
        "key":
            "would_you_like_a_search_engine_outside_of_facebook_to_link_to_your_profile?",
        "subTitle":
            "Bạn có muốn công cụ tìm kiếm bên ngoài Facebook liên kết đến trang cá nhân của mình không ?",
        "content": "Mọi người",
        "icon": SettingConstants.NEXT_ICON_DATA,
      },
    ]
  };

  static const String ADDTIONAL_FOR_WHO_CAN_SEE_FRIEND_LIST_OF_YOU =
      "Lưu ý: Bạn bè của bạn kiểm soát ai có thể xem mối quan hệ bạn bè của họ trên Dòng thời gian của chính họ. Nếu mọi người có thể xem mối quan hệ bạn bè của bạn trên dòng thời gian khác, họ cũng có thể xem thông tin đó trên Bảng tin, phần tìm kiếm và những nơi khác trên Facebook. Nếu bạn đặt tùy chọn này thành Chỉ mình tôi, chỉ bạn mới có thể xem toàn bộ danh sách bạn bè của mình trên dòng thời gian. Còn người khác sẽ chỉ nhìn thấy nhưng người bạn chung.";
}
