import '../../../../../../../setting_constants/general_settings_constants.dart';

class SelectionPrivateRuleOfStoryConstants {
  static const SELECTION_PRIVATE_RULE_OF_STORY_APPBAR_TITLE =
      "Quyền riêng tư của tin";
  static const SELECTION_PRIVATE_RULE_OF_STORY_TITLE = [
    "Ai có thể xem tin của bạn ?",
    "Cài đặt bình luận"
  ];
  static const SELECTION_PRIVATE_RULE_OF_STORY_DESCRIPTION =
      "Tin của bạn sẽ hiển thị trên Emso và Messenger trong 24 giờ.";
  static const Map<String, dynamic> SELECTION_PRIVATE_RULE_OF_STORY_CONTENT = {
    "key": "selection_private_rule_of_story",
    "data": [
      {
        "key": "who_can_See_your_story",
        "subData": [
          {
            "key": "public",
            "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
            "title": "Công khai",
            "subTitle": "Bất kỳ ai ở trên hoặc ngoài Emso",
            "iconNext": "",
          },
          {
            "key": "friend",
            "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
            "title": "Bạn bè",
            "subTitle": "Bạn bè của bạn trên Emso",
            "iconNext": "",
          },
          {
            "key": "custom",
            "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
            "title": "Tùy chỉnh",
            "subTitle":
                "Thiet, An và 102 người khác có thể nhìn thấy tin của bạn",
            "iconNext": "",
          },
          {
            "key": "hide_story_with",
            "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
            "title": "Ẩn tin với",
            "iconNext": SettingConstants.NEXT_ICON_DATA
          },
        ]
      },
      {
        "key": "comment_setting",
        "subData": [
          {
            "key": "comment",
            "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
            "title": "Bình luận",
            "subTitle": "Đang bật với mọi tin",
            "iconNext": ""
          },
          {
            "key": "story_you_turn_off",
            "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
            "title": "Tin bạn đã tắt",
            "iconNext": SettingConstants.NEXT_ICON_DATA
          },
          {
            "key": "always_share_on_instagram",
            "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
            "title": "Luôn chia sẻ lên Instagram",
            "subTitle": "Tự động chia sẻ tin trên Emso lên Instagram",
            "iconNext": ""
          },
        ]
      }
    ]
  };
}
