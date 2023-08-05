import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EventConstants {
  static String PATH_IMG = "assets/images/";
  static String PATH_ICON = "assets/icons/";
  static const String NEXT = "Tiếp";
  static const String CANCEL = "Hủy";
  static const String DONE = "Xong";
  static const String CREATE_EVENT = "Tạo nhóm";
  static const String SKIP = "Bỏ qua";
  static const String CONTINUE_AFTER = "Tiếp tục sau";
  static const ICON_DATA_NEXT = FontAwesomeIcons.chevronRight;
  static const ICON_PRIVIOUS = FontAwesomeIcons.chevronLeft;
}

class CreateEventConstants {
  static const String CREATE_EVENT_TITLE = "Tạo sự kiện";

  static const List<dynamic> ONLINE_COMPONENT = [
    FontAwesomeIcons.globe,
    "Online",
    "Chat video bằng Phòng họp mặt trên Messenger, phát trực tiếp bằng Emso Live hoặc thê liên kết ngoài",
  ];
  static const List<dynamic> LIVE_MEETING_COMPONENT = [
    FontAwesomeIcons.userGroup,
    "Gặp mặt trực tiếp",
    "Họp mặt với mọi người ở một nơi cụ thể",
  ];
}

class DetailEventConstants {
  static const String DETAIL_EVENT_TITLE = "Chi tiết sự kiện";
  static List<dynamic> USER_EXAMPLE = [
    "${EventConstants.PATH_IMG}cat_1.png",
    "User_Name",
    "Trang cá nhân"
  ];
  static const String EVENT_NAME_PLACEHOLDER = "Tên sự kiện";
  static const String DAY_AND_TIME_BEGIN_TITLE = "Ngày và giờ bắt đầu";
  static const String DAY_AND_TIME_END_TITLE = "Ngày và giờ kết thúc";

  static const List<dynamic> ONLINE_COMPONENT = [
    Icon(FontAwesomeIcons.globe),
    "Online",
    "Chat video bằng Phòng họp mặt trên Messenger, phát trực tiếp bằng Emso Live hoặc thê liên kết ngoài",
  ];

  static List<dynamic> PRIVATE_RULE_COMPONENT = [
    FontAwesomeIcons.lock,
    "Quyền riêng tư",
    "Chọn quyền riêng tư"
  ];
  static const String PRIVATE_OF_EVENT = "Quyền riêng tư của sự kiện";
  static const String DESCRIPTION_FOR_PRIVATE_OF_EVENT =
      "Chọn xem ai có thể nhìn thấy và tham gia sự kiện này. Bạn có thể mời mợi người";
  static const List<List<dynamic>> SELECTION_FOR_PRIVATE_OF_EVENT = [
    [FontAwesomeIcons.lock, "Riêng tư", "Chỉ những người được mời"],
    [
      FontAwesomeIcons.earthAmericas,
      "Công khai",
      "Bất kỳ ai ở trên hoặc ngoài Emso"
    ],
    [FontAwesomeIcons.userGroup, "Bạn bè", "Bạn bè trên Emso"],
    [
      FontAwesomeIcons.peopleGroup,
      "Nhóm",
      "Thành viên nhóm mà bạn đang tham gia"
    ],
  ];
  static const String SELECTION_GROUP = "Chọn nhóm";

  static List<List<dynamic>> SELECTION_FOR_CHOOSE_GROUP_EVENT = [
    [
      "${EventConstants.PATH_IMG}cat_1.png",
      "Hoạt Hình Trung Quốc - Chinese Animation",
      "Có Nguyen van a va nhưng nguoi khac"
    ],
    [
      "${EventConstants.PATH_IMG}cat_2.png",
      "Nhóm thông tin sinh viên NEU",
      "Nơi các bạn sinh viên có quyền chia sẻ tất tần tật mọi thứ."
    ],
    [
      "${EventConstants.PATH_IMG}cat_3.png",
      "Mobile Development Jobs VN",
      "Đăng tin tuyển dụng/tim việc về Mobile Place to post Mobile Development related job-ads"
    ],
    [
      "${EventConstants.PATH_IMG}cat_4.png",
      "Tuyển dụng Flutter tại Việt Nam",
      "Chỉ thành viên mới nhìn thấy mọi người trong nhóm và những gì họ đăng."
    ],
    [
      "${EventConstants.PATH_IMG}cat_1.png",
      "Hoạt Hình Trung Quốc - Chinese Animation",
      "Có Nguyen van a va nhưng nguoi khac"
    ],
    [
      "${EventConstants.PATH_IMG}cat_2.png",
      "Nhóm thông tin sinh viên NEU",
      "Nơi các bạn sinh viên có quyền chia sẻ tất tần tật mọi thứ."
    ],
    [
      "${EventConstants.PATH_IMG}cat_3.png",
      "Mobile Development Jobs VN",
      "Đăng tin tuyển dụng/tim việc về Mobile Place to post Mobile Development related job-ads"
    ],
    [
      "${EventConstants.PATH_IMG}cat_4.png",
      "Tuyển dụng Flutter tại Việt Nam",
      "Chỉ thành viên mới nhìn thấy mọi người trong nhóm và những gì họ đăng."
    ],
  ];
}

class LocationEventConstants {
  static const String LOCATION_EVENT_TITLE = "Vị trí";
  // online
  static const String ONLINE_LOCATION_EVENT_SUBTITLE =
      "Chọn cách tham gia sự kiện online của bạn";

  static List<dynamic> MEETING_ROOM_COMPONENT = [
    "${EventConstants.PATH_ICON}camera_plus_icon.svg",
    "Phòng họp mặt trên Messenger",
    "Họp mặt qua tính năng chat video. Mọi người có thể tham gia phòng họp mặt ngay tạitrang sự kiện",
  ];
  static List<dynamic> Emso_LIVE_COMPONENT = [
    "${EventConstants.PATH_ICON}camera_eye_icon.svg",
    "Emso Live",
    "Lên lịch phát trực tiếp sự kiện của bạn bằng Emso Live để mọi người cùng xem",
  ];
  static const String ADD_PRIVATE_LINK = "Thêm liên kết riêng";
  static const String DIFFERENT_SELECTION = "Lựa chọn khác";
  static const String CHANGE_SELECTION = "Thay đổi";

  static List<List<dynamic>> DIFFERENT_SELECTION_COMPONENT = [
    [
      "${EventConstants.PATH_ICON}link_icon.svg",
      "Liên kết bên ngoài",
      "Thêm liên kết đẻ mọi người biết cần truy cập vào đâi khi sự kiện bắt đầu"
    ],
    [
      "${EventConstants.PATH_ICON}more_icon.svg",
      "Khác",
      "Thêm hướng dẫn vào phần chi tiết sự kiện để chỉ rõ cách tham gia"
    ],
  ];

  static const String EVENT_WITH_Emso_LIVE_TITLE = "Sự kiện với Emso Live";
  static List<dynamic> EVENT_WITH_Emso_LIVE_CONTENT_LIST = [
    [
      "${EventConstants.PATH_ICON}camera_eye_icon.svg",
      "Phát trực tiếp ngay trong sự kiện",
      "Bắt đầu video trực tiếp của bạn và mọi người có thể xem ngay trong sự kiện",
    ],
    [
      "${EventConstants.PATH_ICON}bell_icon.svg",
      "Chúng tôi sẽ nhắc bạn",
      "Ít lâu trước khi sự kiện bắt đầu, chúng tôi sẽ gửi thông báo để nhắc bạn",
    ],
    [
      "${EventConstants.PATH_ICON}group_icon.svg",
      "Chỉ mình bạn có thể phát trực tiếp",
      "Người đồng tổ chức có thể yêu cầu tham gia buổi phát trực tiếp nhưng chỉ bạn mới có thể bắt đầu phát",
    ]
  ];

  // offline
  static const String OFFLINE_LOCATION_EVENT_SUBTITLE =
      "Thêm vị trí để mọi người tham gia sự kiện";
  static const List<String> OFFLINE_PLACEHOLDER_EVENT = ["Vị trí", "Tìm kiếm"];
  static const String OFFLINE_PRIVATE_OF_EVENT = "Chọn vị trí";
  static const String OFFLINE_FIND_LOCATION_NEAR_FOR_YOU =
      "Tìm địa điểm gần bạn";
  static const String OFFLINE_OPEN_LOCATION_SERVICE =
      "Hãy bật Dịch vụ vị trí để xem những địa điểm gần bạn hoặc để check in ở một vị trí cụ thể.";
  static const String OFFLINE_OPEN_LOCATION_SERVICE_BUTTON = "Bật";
}

class DescriptionEventConstants {
  static const String DESCRIPTION_EVENT_TITLE = "Mô tả";
  static const String DESCRIPTION_EVENT_SUBTITLE =
      "Cung cấp thêm thông tin về sự kiện để khách mời biết nên mong đợi điều gì";
  static const String PLACEHOLDER_EVENT = "Thêm mô tả";
}

class ReviewEventConstants {
  static const String REVIEW_EVENT_APPBAR_TITLE = "Xem lại sự kiện";
  static const String REVIEW_EVENT_SUBTITLE =
      "Cung cấp thêm thông tin về sự kiện để khách mời biết nên mong đợi điều gì";
  static const String PLACEHOLDER_EVENT = "Thêm mô tả";

  static const String TIME_EVENT = "Hôm nay, 11 tháng 11 lúc 22:00";
  static const String NAME_EVENT = "NAME_OF_EVENT";
  static const String RANGE_EVENT = "Riêng tư - Người tổ chức: ";
  static const String ORGANIZE_PERSON = "USERNAME";
  static List<dynamic> REVIEW_EVENT_CONTENT_LIST = [
    [
      FontAwesomeIcons.pen,
      "Mô tả",
      "CONTENT_DESCRIPTION_PART",
    ],
    [
      "${EventConstants.PATH_ICON}camera_plus_icon.svg",
      "Vị trí",
      "Online - Phòng hợp mặt trên Messenger",
    ],
    [
      FontAwesomeIcons.gear,
      "Cài đặt sự kiện",
      "",
    ]
  ];
}

class SettingEventConstants {
  static const String SETTING_TITLE = "Cài đặt sự kiện";
  static const List<dynamic> CO_ORGANIZER = [
    FontAwesomeIcons.microphone,
    "Người đồng tổ chức",
  ];
  static const String SHARE_LINK_CONTENT =
      "Khách mời có thể chia sẻ liên kết của phòng họp mặt";
  static const String DESCRIPTION_FOR_SHARE_LINK_CONTENT =
      "Cho phép mọi người mời bạn bè tham gia sự kiện và chia sẻ liên kết của phòng họp mặt với người khác, bao gồm cả những ai không có tài khoản Emso hoặc Messenger";
}
