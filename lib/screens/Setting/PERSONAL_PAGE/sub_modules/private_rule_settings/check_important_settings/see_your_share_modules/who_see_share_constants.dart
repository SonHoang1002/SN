import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';

class WhoCanSeeYourShareConstants {
  static const String WHO_CAN_SEE_WHAT_YOU_SHARE_COMPONENT_TITLE =
      "Ai có thể nhìn thấy nội dung bạn chia sẻ";
  static const String WHO_CAN_SEE_WHAT_YOU_SHARE_COMPONENT_SUBTITLE =
      "Chúng tôi sẽ giải thích rõ các lựa chọn để bạn có quyết định phù hợp.";
  static const Map<String, dynamic>
      WHO_CAN_SEE_WHAT_YOU_SHARE_COMPONENT_CONTENTS = {
    "key": "who_can_see_what_you_share",
    "data": [
      {
        "key": "information_on_personal_page",
        "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
        "content": "Thông tin trên trang cá nhân"
      },
      {
        "key": "post_and_story",
        "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
        "content": "Bài viết và tin"
      },
      {
        "key": "block",
        "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
        "content": "Chặn"
      }
    ]
  };
  static const String WHO_CAN_SEE_WHAT_YOU_SHARE_NEXT = "Tiếp tục";

  static const String ALL_COMPLETED_TITLE = "Tất cả đã xong";
  static const String ALL_COMPLETED_SUBTITLE =
      "Cám ơn bạn đã xem lại có thể nhìn thấy nội dung mà bạn chia sẻ. Bạn có thể thay đổi bất kỳ lúc nào trong phần Cài đặt.";
  static const Map<String, dynamic> ALL_COMPLETED_CONTENTS =
      WHO_CAN_SEE_WHAT_YOU_SHARE_COMPONENT_CONTENTS;
}

class InformationOnPersonalPageConstants {
  static const String INFORMATION_ON_PERSONAL_PAGE_APPBAR_TITLE =
      "Thông tin trên trang cá nhân";

  static const String INFORMATION_ON_PERSONAL_PAGE_TITLE =
      "Vui lòng xem lại thông tin này trên trang cá nhân và quyết định người bạn muốn cho xem. Trang cá nhân của bạn có thể chứ nhiều thông tin hơn so với những gì liệt kê tại đây ?";

  static const Map<String, dynamic> INFORMATION_ON_PERSONAL_PAGE_PHONE = {
    "key": "phone",
    "title": "Số điện thoại",
    "data": [
      {"content": "036 6758 465", "status": "Bạn của bạn bè"},
    ]
  };

  static const Map<String, dynamic> INFORMATION_ON_PERSONAL_PAGE_EMAIL = {
    "key": "email",
    "title": "Email",
    "data": [
      {"content": "abc@gmail.com", "status": "Chỉ mình tôi"},
    ]
  };

  static const Map<String, dynamic> INFORMATION_ON_PERSONAL_PAGE_BIRTHDAY = {
    "key": "birthday",
    "title": "Sinh nhật",
    "data": [
      {"content": "1 tháng 7", "status": "Bạn của bạn bè"},
      {"content": "1905", "status": "Bạn của bạn bè"},
    ]
  };

  static const Map<String, dynamic>
      INFORMATION_ON_PERSONAL_PAGE_RELATIONSHIP_STATUS = {
    "key": "relationship_status",
    "title": "Tình trạng mối quan hệ",
    "data": [
      {"content": "Đã kết hôn", "status": "Công khai"},
    ]
  };

  static const Map<String, dynamic> INFORMATION_ON_PERSONAL_PAGE_PROVINCE = {
    "key": "province",
    "title": "Tỉnh/ thành phố hiện tại",
    "data": [
      {"content": "Hà Nội", "status": "Công khai"},
    ]
  };
  static const Map<String, dynamic>
      INFORMATION_ON_PERSONAL_PAGE_FRIEND_AND_FOLLOW = {
    "key": "friend_and_follow",
    "title": "Bạn bè và theo dõi",
    "data": [
      {
        "content":
            "Ai có thể xem danh sách bạn bè trên trang cá nhân của bạn ?",
        "status": "Chỉ mình tôi"
      },
      {
        "content":
            "Ai có thể nhìn thấy những người, Trang và danh sách mà bạn theo dõi ?",
        "status": "Chỉ mình tôi"
      },
    ]
  };

  static const List<Map<String, dynamic>>
      INFORMATION_ON_PERSONAL_PAGE_CHOOSE_PHONE_STATUS = [
    {
      "key": "public",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Công khai",
      "subTitle": "Bất kỳ ai ở trên hoặc ngoài Emso",
      "isCheck": true
    },
    {
      "key": "friend",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn trên Emso",
      "isCheck": false
    },
    {
      "key": "private",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Chỉ mình tôi",
      "subTitle": "Chỉ mình tôi",
      "isCheck": false
    },
  ];
  static const List<Map<String, dynamic>>
      INFORMATION_ON_PERSONAL_PAGE_CHOOSE_EMAIL_STATUS = [
    {
      "key": "public",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Công khai",
      "subTitle": "Bất kỳ ai ở trên hoặc ngoài Emso",
      "isCheck": true
    },
    {
      "key": "friend",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn trên Emso",
      "isCheck": false
    },
    {
      "key": "private",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Chỉ mình tôi",
      "subTitle": "Chỉ mình tôi",
      "isCheck": false
    },
  ];
  static const List<Map<String, dynamic>>
      INFORMATION_ON_PERSONAL_PAGE_CHOOSE_BIRTHDAY_STATUS = [
    {
      "key": "public",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Công khai",
      "subTitle": "Bất kỳ ai ở trên hoặc ngoài Emso",
      "isCheck": true
    },
    {
      "key": "friend_of_friend",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn của bạn bè",
      "subTitle": "Bạn của bạn bè",
      "isCheck": false
    },
    {
      "key": "friend",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn trên Emso",
      "isCheck": false
    },
    {
      "key": "private",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Chỉ mình tôi",
      "subTitle": "Chỉ mình tôi",
      "isCheck": false
    },
  ];
  static const List<Map<String, dynamic>>
      INFORMATION_ON_PERSONAL_PAGE_CHOOSE_PROVINCE_STATUS = [
    {
      "key": "public",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Công khai",
      "subTitle": "Bất kỳ ai ở trên hoặc ngoài Emso",
      "isCheck": true
    },
    {
      "key": "friend",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn trên Emso",
      "isCheck": false
    },
    {
      "key": "private",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Chỉ mình tôi",
      "subTitle": "Chỉ mình tôi",
      "isCheck": false
    },
  ];
  static const List<Map<String, dynamic>>
      INFORMATION_ON_PERSONAL_PAGE_CHOOSE_RELATIONSHIP_STATUS = [
    {
      "key": "public",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Công khai",
      "subTitle": "Bất kỳ ai ở trên hoặc ngoài Emso",
      "isCheck": true
    },
    {
      "key": "friend",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn trên Emso",
      "isCheck": false
    },
    {
      "key": "private",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Chỉ mình tôi",
      "subTitle": "Chỉ mình tôi",
      "isCheck": false
    },
  ];

  static const List<Map<String, dynamic>>
      INFORMATION_ON_PERSONAL_PAGE_CHOOSE_FRIEND_AND_FOLLOW_STATUS = [
    {
      "key": "public",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Công khai",
      "subTitle": "Bất kỳ ai ở trên hoặc ngoài Emso",
      "isCheck": true
    },
    {
      "key": "friend",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè",
      "subTitle": "Bạn bè của bạn trên Emso",
      "isCheck": false
    },
    {
      "key": "friends_except",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè ngoại trừ",
      "subTitle": "Không hiển thị với một số bạn bè",
      "isCheck": false
    },
    {
      "key": "specific_friends",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Bạn bè cụ thể",
      "subTitle": "Chỉ hiển thị với một số bạn bè",
      "isCheck": false
    },
    {
      "key": "private",
      "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
      "title": "Chỉ mình tôi",
      "subTitle": "Chỉ mình tôi",
      "isCheck": false
    },
  ];
}

class BlockConstants {
  static const String BLOCK_APPBAR_TITLE = "Chặn";
  static const String BLOCK_TITLE =
      "Khi bạn chặn ai đó, họ sẽ không xem được nội dung bạn đăng trên dòng thời gian của mình, gắn thẻ bạn, mời bạn tham gia sự kiện hoặc nhóm, bắt đầu cuộc trò chuyện với bạn hay thêm bạn làm bạn bè.";
  static const String BLOCK_TIP =
      "Mẹo: Khi bạn chặn ai đó, chúng tôi sẽ không cho họ biết đâu";

  static const Map<String, dynamic> BLOCK_ADD_TO_BLOCK_LIST = {
    "key": "add_to_block_list",
    "title": "Thêm vào danh sách chặn",
    "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
    // "data": [
    //   {"name": "abc"},
    //   {"name": "sdfh"},
    //   {"name": "sdjfier"},
    // ]
  };
  static const Map<String, dynamic> BLOCK_SEE_BLOCK_LIST = {
    "key": "see_block_list",
    "title": "Xem danh sách chặn của bạn",
    "icon": "${SettingConstants.PATH_ICON}bell_icon.svg",
    "data": [
      {"name": "abc"},
      {"name": "sdfh"},
      {"name": "sdjfier"},
    ]
  };
}

class PostAndStoryConstants {
  static const String POST_AND_STORY_APPBAR_TITLE = "Bài viết và tin";

  static const String POST_AND_STORY_TITLE =
      "Bạn là người quyết định bài viết và tin của mình sẽ hiển thị với ai.";
  static const Map<String, dynamic> POST_AND_STORY_DEFAULT_OBJECT = {
    "key": "default_object",
    "title": "Đối tượng mặc định",
    "data": [
      {
        "content":
            "Đối tượng mặc định của bạn là Bạn bè. Đây sẽ là đối tượng của các bài viết trong tương lai. Tuy nhiên, bất cứ lúc nào bạn cũng có thể thay đổi đối tượng của riêng một bài viết nào đó.",
        "status": "Bạn bè"
      },
    ]
  };

  static const Map<String, dynamic> POST_AND_STORY_STORY = {
    "key": "story",
    "title": "Tin",
    "data": [
      {
        "content":
            "Kiểm soát ai có thể xem tin. Tin hiển thị trên Emso và Messenger trong 24 giờ",
        "status": "Chỉ mình tôi"
      },
    ]
  };

  static const Map<String, dynamic> POST_AND_STORY_OLD_STORY_LIMITATION = {
    "key": "old_story_limitation",
    "title": "Giới hạn bài viết cũ",
    "data": [
      {
        "content":
            "Thay đổi người xem được bài viết cũ từ Bạn của bạn bè hoặc Công khai thành chỉ Bạn bè. Bất kì ai được gắn thẻ trong những bài viết này và bạn bè đều vẫn xem được bài viết.",
      },
    ]
  };
  static const POST_AND_STORY_LIMITATION_DESCRIPTION =
      "Bạn sắp giới hạn tất cả bài viết cũ trên dòng thời gian. Sau này, cách duy nhất để hoàn tác là thay đổi đối tượng của từng bài viết một.";
}
