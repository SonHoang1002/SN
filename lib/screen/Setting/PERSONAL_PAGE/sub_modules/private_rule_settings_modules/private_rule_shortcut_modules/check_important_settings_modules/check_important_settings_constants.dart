import 'package:social_network_app_mobile/screen/Setting/setting_constants/general_settings_constants.dart';

class CheckImportantSettingsConstants {
  static const CHECK_IMPORTANT_SETTINGS_TITLE = "Kiểm tra quyền riêng tư";
  static const CHECK_IMPORTANT_SETTINGS_SUBTITLE =
      "Chúng tôi sẽ hướng dẫn cách cài đặt để bạn đưa ra lựa chọn phù hợp với tài khoản của mình.";
  static const CHECK_IMPORTANT_SETTINGS_QUESTION =
      "Bạn muốn bắt đầu với chủ đề nào ?";
  static const Map<String, dynamic> CHECK_IMPORTANT_SETTINGS_CONTENTS = {
    "key": "check_important_settings",
    // "title": "Lối tắt quyền riêng tư",
    "data": [
      {
        "key": "who_can_see_what_you_share",
        "content": "Ai có thể nhìn thấy nội dung bạn chia sẻ",
        "img": SettingConstants.PATH_IMG + "example_cover_img_1.jpg",
      },
      {
        "key": "how_to_protect_your_account",
        "content": "Cách bảo vệ tài khoản",
        "img": SettingConstants.PATH_IMG + "example_cover_img_2.jpg",
      },
      {
        "key": "how_people_can_find_you_on_facebook",
        "content": "Cách mọi người có thể tìm bạn trên Facebook",
        "img": SettingConstants.PATH_IMG + "example_cover_img_3.jpg",
      },
      {
        "key": "set_your_data_on_facebook",
        "content": "Cài đặt dữ liệu của bạn trên Facebook",
        "img": SettingConstants.PATH_IMG + "example_cover_img_4.jpg",
      },
      {
        "key": "facebook_advertising_options",
        "content": "Tùy chọn quảng cáo trên Facebook",
        "img": SettingConstants.PATH_IMG + "example_cover_img_5.jpg",
      },
    ]
  };
  static const CHECK_IMPORTANT_SETTINGS_ADDITINAL_INFORMATION =
      "Bạn có thể  vào phần Cài đặt để xem các cài đặt quyền riêng tư khác trên Facebook";
  static const Map<String, dynamic>
      CHECK_IMPORTANT_SETTINGS_BOTTOM_SHEET_CONTENTS = {
    "key": "check_important_settings_bottom_sheet",
    // "title": "Lối tắt quyền riêng tư",
    "data": [
      {
        "key": "who_can_see_what_you_share?",
        "title": "Thiết lập lời nhắc",
        "subTitle": "Chọn tần suất nhận lời nhắc Kiểm tra Quyền riêng tư",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
      },
      {
        "key": "how_to_protect_your_account",
        "title": "Chia sẻ",
        "subTitle":
            "Chia sẻ liên kết để mọi người có thể biết về tính năng Kiểm tra quyền riêng tư",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
      },
    ]
  };
}
