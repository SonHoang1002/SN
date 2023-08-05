import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingConstants {
  static const IconData BACK_ICON_DATA = CupertinoIcons.back;
  static const IconData NEXT_ICON_DATA = FontAwesomeIcons.chevronRight;
  static const IconData CANCEL_ICON_DATA = Icons.close;

  static const IconData MENU_ICON_DATA = FontAwesomeIcons.ellipsis;
  static const IconData DOWN_ICON_DATA = FontAwesomeIcons.caretDown;

  static const PATH_IMG = "assets/images/";
  static const PATH_ICON = "assets/icons/";

  static const PLACE_HOLDER_SEARCH_APPBAR_TITLE = "Tìm kiếm cài đặt";

  static const List<List<dynamic>> BOTTOM_NAVIGATOR_ITEM_LIST = [
    [Icons.home, "Trang chủ"],
    [Icons.group, "Bạn bè"],
    [Icons.food_bank_outlined, "MarketPlace"],
    [Icons.personal_injury, "Trang cá nhân"],
    [Icons.notifications_active, "Thông báo"],
    ["${PATH_IMG}cat_7.png", "Menu"],
  ];

  // trang ca nhan

  static const PERSONAL_PAGE_TITLE = "Trang cá nhân";
  static const PERSONAL_PAGE_DESCRIPTION =
      "Kiểm soát các tùy chọn của trang cá nhân này như quyền riêng tư, thông báo và các cài đặt khác";
  static List<dynamic> USER_EXAMPLE = [
    "${PATH_IMG}cat_7.png",
    "Cài đặt trang cá nhân",
    "Dành cho USER_NAME"
  ];

  // account
  static const ACCOUNT_TITLE = "Tài khoản";
  static const ACCOUNT_DESCRIPTION =
      "Quản lý phần cài đặt liên quan đến quyền, quảng cáo, hoạt động bên ngoài Emso và thông tin khác về tài khoản.";

  static List<Map<String, dynamic>> ACCOUNT_INFORMATION_LIST = [
    {
      "key": "acount_information",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Thông tin cá nhân",
        "subTitle":
            "Cập nhật tên và thông tin liên hệ mà bạn kết nối với tài khoản Emso của mình"
      }
    },
    {
      "key": "tranlate_post",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Dịch bài viết",
        "subTitle":
            "Hãy cho chúng tôi biết tùy chọn dịch mà bạn muốn áp dụng cho bài viết của bạn bè và bài viết song ngữ"
      }
    },
    {
      "key": "tranlate_post",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Thanh toán quảng cáo",
        "subTitle": "Thanh toán hoặc chỉnh sửa cài đặt thanh toán của bạn"
      }
    },
    {
      "key": "pay_advertisement",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Emso Pay",
        "subTitle":
            "Quản lý cài đạt thanh toán, xem lịch sử thanh toán và nhận hỗ trợ qua tính năng chat trực tiếp"
      }
    },
    {
      "key": "access_and_control_rule",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Quyền truy cập và kiểm soát",
        "subTitle":
            "Quản lý dữ liệu, sửa đổi người liên hệ thừa kế, vô hiệu hóa hoặc xóa tài khoản của bạn, vv"
      }
    },
  ];

  // security

  static const SECURITY_TITLE = "Bảo mật";
  static const SECURITY_DESCRIPTION =
      "Cập nhật cài đặt đăng nhập và quản lý game/ ứng dụng kết nối với tài khoản của bạn";
  static List<Map<String, dynamic>> SECURITY_INFORMATION_LIST = [
    {
      "key": "security_and_login",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Bảo mật vằ đăng nhập",
        "subTitle":
            "Cập nhật cài đặt đăng nhập và quản lý game/ ứng dụng kết nối với tài khoản của bạn"
      }
    },
    {
      "key": "location",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Vị trí",
        "subTitle": "Quản lý cài đặt vị trí của bạn"
      }
    },
    {
      "key": "application_website",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Ứng dụng và trang web",
        "subTitle":
            "Quản lý thông tin bạn chia sẻ với các ứng dụng và trang web bạn đã đăng nhập bằng Emso"
      }
    },
    {
      "key": "outside_activity_Emso",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Hoạt động bên ngoài Emso",
        "subTitle":
            "Xem hoặc xóa hoạt động từ các doanh nghiệp và tổ chức mà bạn truy cập ngoài Emso"
      }
    },
    {
      "key": "business_integrations",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Tiện ích tích hợp cho doanh nghiệp",
        "subTitle":
            "Xem và gỡ các tiện ích tích hợp cho doanh nghiệp mà bạn kết nối với tài khoản của mình để quản lý quảng cáo, trang cá nhân cùng thông tin doanh nghiệp khác"
      }
    },
  ];
// advertisement
  static const ADVERTISEMENT_TITLE = "Quảng cáo";
  static const ADVERTISEMENT_DESCRIPTION =
      "Xem lại cách chúng tôi sử dụng dữ liệu để hiển thị cho bạn quảng cáo cho phù hợp hơn";
  static List<Map<String, dynamic>> ADVERTISEMENT_INFORMATION_LIST = [
    {
      "key": "advertisement_settings",
      "data": {
        "icon": "${PATH_ICON}bell_icon.svg",
        "title": "Tùy chọn nâng cao",
        "subTitle":
            "Kiểm soát xem dữ liệu ảnh hưởng đến quảng cáo bạn nhìn thấy như thế nào và tìm hiểu thêm về cách quảng cáo hoạt động."
      }
    }
  ];

// meta
  static const META_TITLE = "Meta";
  static const List<String> META_DESCRIPTION = [
    "Trung tâm tài khoản",
    "Kiểm soát chế độ cài đặt khi kết nối các trải nghiệm, chẳng hạn như đăng nhập và chia sẻ tin, bài viết trên Fcebook, Instagram cũng như Messenger"
  ];
//policy
  static const POLICY_TITLE = "Pháp lý và chính sách";
  static const List<Map<String, String>> POLICY_SUBTITLE = [
    {"key": "terms_of_service", "data": "Điều khoản dịch vụ"},
    {"key": "private_rule_policy", "data": "Chính sách quyền riêng tư"},
    {"key": "terms_of_cookie", "data": "Chính sách cookie"},
    {"key": "public_standard", "data": "Tiêu chuẩn cộng đồng"},
  ];
}
