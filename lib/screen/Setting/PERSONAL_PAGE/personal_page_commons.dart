
import '../setting_constants/general_settings_constants.dart';

class PersonalPageCommons {
  static const PRIVATE_APPBAR_TITLE = "Cài đặt quyền riêng tư";
  static const PRIVATE_TITLE = "Quyền riêng tư";
  static const PRIVATE_DESCRIPTION =
      "Kiểm soát người nhìn thấy hoạt động của bạn trên Facebook và cách chúng tôi dùng dữ liệu để cá nhân hóa trải nghiệm";
  static List<Map<String, dynamic>> PRIVATE_INFORMATION_LIST = [
    {
      "key": "private_rule",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Quyền riêng tư",
        "subTitle":
            "Kiểm soát ai có thể kết bạn, liên hệ và xem trang cá nhân của bạn"
      }
    },
    {
      "key": "personal_page_and_tag",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Trang cá nhân và gắn thẻ",
        "subTitle":
            "Quyết định người có thể tương tác với trang cá nhân và các bài viết của bạn trên Facebook"
      }
    },
    {
      "key": "public_post",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Bài viết công khai",
        "subTitle":
            "Quản lý những ai có thể theo dõi trang cá nhân và bình luận về bài viết công khai của bạn"
      }
    },
    {
      "key": "block",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Chặn",
        "subTitle": "Xem lại những người mà bạn đã chặn trước đó"
      }
    },
    {
      "key": "activity_status",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Trạng thái hoạt động",
        "subTitle": "Hiển thị khi bạn hoạt động"
      }
    },
  ];

  // notification
  static const NOTIFICATION_TITLE = "Thông báo";
  static const NOTIFICATION_DESCRIPTION =
      "Quyết định cách bạn muốn giao tiếp trên Facebook và chúng tôi nên thông báo cho bạn bằng cách nào";
  static List<Map<String, dynamic>> NOTIFICATION_INFORMATION_LIST = [
    {
      "key": "notification_setting",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Cài đặt thông báo",
        "subTitle": "Chọn thông báo bạn muốn nhận và nới nhận thông báo"
      }
    },
    {
      "key": "text_messaging",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Nhắn tin văn bản",
        "subTitle": "Chỉnh sửa tùy chọn gửi và nhận tin nhắn văn bản"
      }
    },
    {
      "key": "email",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Email",
        "subTitle": "Quản lý thông báo qua email của bạn"
      }
    },
    {
      "key": "message_preview",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Bản xem trước tin nhắn",
        "subTitle":
            "Chỉnh sửa các tùy chọn nhận bản xem trước tin nhắn trong ứng dụng và lời nhắc từ Messenger"
      }
    },
    {
      "key": "notification_dot",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Dấu chấm thông báo",
        "subTitle":
            "Chỉnh sửa tùy chọn hiển thị dấu chấm thông báo trên lối tắt"
      }
    },
  ];

  // your informationin facebook
  static const YOUR_INFORMATION_IN_FACEBOOK_TITLE =
      "Thông tin của bạn trên Facebook";
  static const YOUR_INFORMATION_IN_FACEBOOK_DESCRIPTION =
      "Xem hoặc tải xuống thông tin trang cá nhân và quản lý hoạt động trên trang cá nhân của bạn";
  static List<Map<String, dynamic>>
      YOUR_INFORMATION_IN_FACEBOOK_INFORMATION_LIST = [
    {
      "key": "access_information_on_facebook",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Truy cập thông tin trên trang cá nhân",
        "subTitle": "Xem thông tin trên trang cá nhân của bạn theo hạng mục."
      }
    },
    {
      "key": "activity_diary",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Nhật ký hoạt động",
        "subTitle": "Xem và quản lý hoạt động trên trang cá nhân của bạn."
      }
    },
    {
      "key": "download_information_on_personal_page",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Tải xuống thông tin trên trang cá nhân",
        "subTitle":
            "Tải xuống bản sao thông tin trên trang cá nhân của bạn để lưu giữ hoặc chuyển sang dịch vụ khác."
      }
    },
    {
      "key": "transfer_a_copy_of_your_information",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Chuyển bản sao thông tin của bạn",
        "subTitle":
            "Sao chép ảnh, video, bài viết hoặc thông tin khác sang dịch vụ khác."
      }
    },
  ];

  // your informationin facebook
  static const FILE_AND_CONTACT_TITLE = "File phương tiện và danh bạ";
  static const FILE_AND_CONTACT_DESCRIPTION =
      "Quản lý ảnh, video và âm thanh, đồng bộ danh bạ liên tục cũng như xóa dữ liệu lướt xem trên điện thoại của bạn.";
  static List<Map<String, dynamic>> FILE_AND_CONTACT_INFORMATION_LIST = [
    {
      "key": "video_and_image",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Video và ảnh",
        "subTitle": "Quản lý tùy chọn của bạn về tải lên và phát lại."
      }
    },
    {
      "key": "sound",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Âm thanh",
        "subTitle":
            "Quản lý tùy chọn của bạn về âm thanh video và trong ứng dụng."
      }
    },
    {
      "key": "browser",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Trình duyệt",
        "subTitle":
            "Ngắt lịch sử trang web mà bạn đã truy cập khi lướt xem trên Facebook bằng điện thoại.  "
      }
    },
    {
      "key": "upload_contact",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Tải danh ba lên",
        "subTitle": "Liên tục tải lên người liên hệ mới thêm và mới cập nhật."
      }
    },
  ];

  // Feed Setting
  static const FEED_SETTINGS_TITLE = "Cài đặt Bảng feed";
  static const FEED_SETTINGS_DESCRIPTION =
      "Quản lý nội dung bạn nhìn thấy trong Bảng feed.";
  static List<Map<String, dynamic>> FEED_SETTINGS_INFORMATION_LIST = [
    {
      "key": "feed_table_setting",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Tùy chọn Bảng feed",
        "subTitle": "Kiểm soát và tùy chỉnh Bảng feed."
      }
    },
    {
      "key": "emotion_setting",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Tùy chọn về cảm xúc",
        "subTitle":
            "Kiểm soát xem có hiển thị tổng số cảm xúc về bài viết trên Facebook hay không."
      }
    },
  ];

  // story
  static const STORY_TITLE = "Tin";
  static const STORY_DESCRIPTION = "Kiểm soát cách chia sẻ và lưu trữ tin.";
  static List<Map<String, dynamic>> STORY_INFORMATION_LIST = [
    {
      "key": "story_setting",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Cài đặt tin",
        "subTitle": "Chọn ai có thể xem tin của bạn và quản lý kho lưu trữ tin."
      }
    },
  ];

  // ShortCut
  static const SHORTCUT_TITLE = "Lối tắt";
  static const String SHORTCUT_DESCRIPTION =
      "Truy cập dễ dàng hơn vào các dịch vụ trên Facebook mà bạn hay dùng nhất.";
  static List<Map<String, dynamic>> SHORTCUT_INFORMATION_LIST = [
    {
      "key": "shortCut_bar",
      "data": {
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Thanh lối tắt",
        "subTitle":
            "Quyết định xem Facebook có thể thêm lối tắt nào vào thanh lối tắt của bạn."
      }
    },
  ];
}
