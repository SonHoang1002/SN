// APPLICATION_AND_WEBSITE_

import 'package:social_network_app_mobile/screens/Setting/setting_constants/general_settings_constants.dart';

class SetYourDataOnEmsoConstants {
  static const SET_YOUR_DATA_ON_Emso_TITLE =
      "Cài đặt dữ liệu của bạn trên Fcebook";
  static const SET_YOUR_DATA_ON_Emso_SUBTITLE =
      "Hãy cùng xem một vài bước hướng dẫn để bảo vệ tài khoản của bạn nhé.";
  static const Map<String, dynamic> SET_YOUR_DATA_ON_Emso_CONTENTS = {
    "key": "set_your_data_on_Emso",
    "data": [
      {
        "key": "application_and_website",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Ứng dụng và trang web"
      },
      {
        "key": "location",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Vị trí"
      },
    ]
  };
  static const String WHO_CAN_SEE_WHAT_YOU_SHARE_NEXT = "Tiếp tục";
}

class ApplicationAndWebsiteConstants {
  static const APPLICATION_AND_WEBSITE_APPBAR_TITLE = "Ứng dụng và trang web";
  static const APPLICATION_AND_WEBSITE_TITLE =
      "Dưới đây là các ứng dụng và trang web của công ty khác mà bạn đã dùng Emso để đăng nhập và sử dụng gần đây. Bạn có I2 gỡ bất kỳ ứng dụng/trang web nào mình không muốn dùng nữa";

  static const Map<String, dynamic> APPLICATION_AND_WEBSITE_CONTENTS = {
    "key": "application_and_website",
    "data": [
      {
        // "key": "application_and_website",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Duo Lingo",
      },
      {
        // "key": "location",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Liên quân mô bai -  thắng bại tại wifi",
      },
      {
        // "key": "location",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Spotify",
      },
    ]
  };
  static const Map<String, dynamic> APPLICATION_AND_WEBSITE_TIP = {
    "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
    "content":
        "Bí quyết: Bạn có thể thay đổi thông tin mình đang chia sẻ bất cứ lúc nào trong phần cài đặt. Bạn cũng có thể xem lại các ứng dụng đã gỡ hoặc đã hết hạn.",
  };

  // bottom sheet

  static const Map<String, dynamic>
      APPLICATION_AND_WEBSITE_BOTTOM_SHEET_CONTENTS = {
    "key": "application_and_website_bottom_sheet",
    "title": "Gỡ Duo Lingo ?",
    "data": [
      {
        "title":
            "Hành động này có thê xóa tài khoản và hoạt động của bạn trên Duo lingo có thể vẫn có quyền truy cập vào thông tin mà trước đó bạn chia sẻ, nhưng không thể hận bất kỳ thông tin không công khai nào khác.",
      },
      {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title":
            "Xóa tất cả bài viết, ảnh và video mà Duo lingo đã đăng lên dòng thời thoi gian của bạn.",
      },
      {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title":
            "Gửi thông báo cho Duo Lingo rằng bạn đã gỡ ứng dụng/trang web này. Họ có thể sẽ hướng dẫn bạn cách đăng nhập khác.",
      },
    ]
  };

  static const String APPLICATION_AND_WEBSITE_NEXT = "Tiếp";
}

class LocationConstants {
  static const LOCATION_APPBAR_TITLE = "Vị trí";
  static const LOCATION_TITLE =
      "Bạn kiểm soát những ai xem được vị trí của bạn trên các Sản phầm của Emso. Bạn có thê tắt Dịch vụ vị trí bất cứ lúc nào trong phần cài đặt của thiết bị.";
  static const Map<String, dynamic> LOCATION_CONTENTS = {
    "data": [
      {
        "title": "Luôn luôn",
        "subTitle":
            'Emso sẽ không hỗ trợ cài đặt "Mọi lúc" nữa. Hãy cập nhật ứng dụng đê gỡ cài đặt này.'
      },
      {
        "title": "Khi đang sử dụng",
        "subTitle":
            'Chúng tôi chỉ nhận vị trí chính xác của thiết bị này khi bạn sử dụng Emso.'
      },
      {
        "title": "Không bao giờ",
        "subTitle":
            'Chúng tôi sẽ không nhận vị trí chính xác của thiết bị này nhưng vẫn dùng những thông tin như địa chỉ IP để ước chừng vị trí của bạn. Tìm hiêu thêm'
      },
    ]
  };
  static const LOCATION_GO_TO_SETTING = "Đi đến phần Cài đặt thiết bị";
  static const Map<String, dynamic> LOCATION_TIP = {
    "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
    "content":
        "Bí quyết: Hãy xem lại phần Cài đặt vị trí để tìm thêm các tùy chọn kiểm soát khác,chẳng hạn như Lịch sử vị trí."
  };
  static const String LOCATION_NEXT = "Tiếp";
}

class AllComplete4Constants {
  static const String ALL_COMPLETED_TITLE = "Tất cả đã xong";
  static const ALL_COMPLETED_SUBTITLE =
      "Cảm ơn bạn đã xem lại các cài đặt dữ liệu trên Emso. Bạn có thể thay đổi bất kỳ lúc nào trong phân cài đặt.";
  static const Map<String, dynamic> ALL_COMPLETED_CONTENTS = {
    // "key": "set_your_data_on_Emso",
    "data": [
      {
        // "key": "application_and_website",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Ứng dụng và trang web"
      },
      {
        // "key": "location",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Vị trí"
      },
    ]
  };
  static const NEARLY_DONE_REVIEW_OTHER_TOPICS = "Xem lại chủ đề khác";
}
