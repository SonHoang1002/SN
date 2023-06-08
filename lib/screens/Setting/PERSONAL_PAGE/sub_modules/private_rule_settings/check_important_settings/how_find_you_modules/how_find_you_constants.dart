import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';

class HowPeopleCanFindYouOnEmsoConstants {
  static const String HOW_PEOPLE_CAN_FIND_YOU_ON_Emso_TITLE =
      "Cách mọi người có thể tìm thấy bạn trên Emso";
  static const String HOW_PEOPLE_CAN_FIND_YOU_ON_Emso_SUBTITLE =
      "Chúng tôi sẽ giải thích rõ các lựa chọn để bạn có quyết định phù hợp.";
  static const Map<String, dynamic> HOW_PEOPLE_CAN_FIND_YOU_ON_Emso_CONTENTS = {
    "key": "how_people_can_find_you_on_Emso",
    "data": [
      {
        "key": "add_friend_request",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Lời mời kết bạn"
      },
      {
        "key": "phone_and_email",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Số điện thoại và email"
      },
      {
        "key": "search_tool",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Công cụ tìm kiếm"
      }
    ]
  };
  static const String WHO_CAN_SEE_WHAT_YOU_SHARE_NEXT = "Tiếp tục";

  static const String ALL_COMPLETED_TITLE = "Tất cả đã xong";
  // static const ALL_COMPLETED_SUBTITLE = [
  //   "3 Cảm ơn bạn đã xem lại cách mọi người có thể tìm thấy bạn trên Emso. Bạn có thể thay đổi bất kỳ lúc nào trong phần cài đặt.",
  //   "4 Cảm ơn bạn đã xem lại các cài đặt dữ liệu trênEmso. Bạn có thể thay đổi bất kỳ lúc nào trong phân cài đặt."
  // ];
  static const ALL_COMPLETED_SUBTITLE =
      "Cảm ơn bạn đã xem lại cách mọi người có thể tìm thấy bạn trên Emso. Bạn có thể thay đổi bất kỳ lúc nào trong phần cài đặt.";
  static const Map<String, dynamic> ALL_COMPLETED_CONTENTS =
      HOW_PEOPLE_CAN_FIND_YOU_ON_Emso_CONTENTS;
  static const String NEARLY_DONE_REVIEW_OTHER_TOPICS = "Xem lại chủ đề khác";
  static const String NEARLY_DONE_FIX_REMAINING_BUGS = "Sửa các lỗi còn lại";
}

class AddFriendRequestConstants {
  static const ADD_FRIEND_REQUEST_APPBAR_TITLE = "Lời mời kết bạn";
  static const ADD_FRIEND_REQUEST_TITLE =
      "Bạn kiểm soát ai có thể gửi lời mời kết bạn cho mình.";

  static const Map<String, dynamic> ADD_FRIEND_REQUEST_CONTENT = {
    "key": "add_friend_request_tip",
    "data": {
      "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
      "title": "Ai có thể gửi cho bạn lời mời kết bạn ?",
      "content": "Mọi người"
    }
  };
  static const Map<String, dynamic> ADD_FRIEND_REQUEST_TIP = {
    "key": "add_friend_request_tip",
    "data": {
      "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
      "title":
          "Mẹo: Nếu nhận được quá nhiều lời mời kết bạn không mong muốn, bạn có thể đặt tùy chọn này thành Bạn của bạn bè."
    }
  };

  static const String ADD_FRIEND_REQUEST_NEXT = "Tiếp tục";
}

class PhoneAndEmailConstants {
  static const PHONE_AND_EMAIL_APPBAR_TITLE = "Số điện thoại và email";

  static const Map<String, dynamic> PHONE_AND_EMAIL_TIP = {
    "key": "phone_and_email_tip",
    "data": {
      "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
      "title":
          "Mẹo: Do có nhiều người trùng tên nhau nên chúng tôi cung cấp một vài cách để mọi người tìm thấy nhau trên Emso."
    }
  };

  static const PHONE_AND_EMAIL_TITLE =
      "Chọn người có thể tìm kiếm bạn bằng số điện thoại và địa chỉ email của bạn.";
  static const Map<String, dynamic> PHONE_AND_EMAIL_CONTENTS = {
    "key": "phone_and_email_contents",
    "data": [
      {
        "key": "phone",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Số điện thoại",
        "content": "Mọi người",
      },
      {
        "key": "email",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Email",
        "content": "Mọi người",
      },
    ]
  };
  static const String ADD_FRIEND_REQUEST_NEXT = "Tiếp tục";
}

class SearchToolConstants {
  static const SEARCH_TOOL_APPBAR_TITLE = "Công cụ tìm kiếm";

  static const SEARCH_TOOL_TITLE = [
    "Các công cụ tìm kiếm( như Google) có thể liên kết đến trang cá nhân của bạn để mọi người dễ dàng tìm thấy bạn hơn.",
    "Nếu bạn tắt tùy chọn này, mọi người vẫn có thể tìm thấy trang cá nhân của bạn trên Emso bằng cách tìm kiếm tên bạn.",
  ];
  static const SEARCH_TOOL_LINK_PERSONAL_PAGE =
      "Bạn có muốn công cụ tìm kiếm bên ngoài Emso liên kết đến trang cá nhân của mình không ?";
  static const String ADD_FRIEND_REQUEST_NEXT = "Tiếp tục";
}

class AllCompletedFindsConstants {}
