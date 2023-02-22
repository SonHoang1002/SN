import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginConstants {
  static String PATH_IMG = "assets/images/";
  static String PATH_ICON = "assets/icons/";
  static const String NEXT = "Tiếp";
  static const String DONE = "Xong";
  static const String CREATE_GROUP = "Tạo nhóm";
  static const String SKIP = "Bỏ qua";
  static const String CONTINUE_AFTER = "Tiếp tục sau";
  static const IconData MENU_ICON_DATA = FontAwesomeIcons.ellipsis;
  static const IconData DOWN_ICON_DATA = FontAwesomeIcons.caretDown;
}

class OnboardingLoginConstants {
  static const ONBOARDING_LOGIN_USERNAME = "Simon Smiths";
  static const ONBOARDING_LOGIN_LOGIN_WITH_DIFFERENCE_ACCOUNT =
      "Đăng nhập bằng tài khoản khác";
  static const ONBOARDING_LOGIN_SIGNIN_EMSO_ACCOUNT = "Đăng ký tài khoản Emso";
}

class MainLoginConstants {
  static String MAIN_LOGIN_EMAIL_OR_PHONE_PLACEHOLDER =
      "Email hoặc số điện thoại";
  static String MAIN_LOGIN_PASSWORD_PLACEHOLDER = "Mật khẩu";
  static const String MAIN_LOGIN_LOGIN_TEXT_BUTTON = "Đăng nhập";
  static const String MAIN_LOGIN_FORGET_PASSWORD = "Quên mật khẩu ?";
  static const String MAIN_LOGIN_BACK_TEXT = "Quay lại";
  static const String MAIN_LOGIN_OR_TEXT =
      "--------------------- HOẶC ---------------------";
  static const String MAIN_LOGIN_CREATE_NEW_ACCOUNT = "Tạo tài khoản mới";
}

class BeginJoinEmsoLoginConstants {
  static String BEGIN_JOIN_EMSO_LOGIN_TITLE = "Tham gia Mạng xã hội Emso";
  static String BEGIN_JOIN_EMSO_LOGIN_SUBTITLE =
      "Chúng tôi sẽ giúp bạn tạo tài khoản sau vài bước dễ dàng.";
  static const String BEGIN_JOIN_EMSO_LOGIN_BEGIN_TEXT_BUTTON = "Bắt đầu";
}

class NameLoginConstants {
  static String NAME_LOGIN_TITLE = "Bạn tên gì ?";
  static List<String> NAME_LOGIN_NAME_PLACEHOLODER = ["Họ", "Tên"];
  static String NAME_LOGIN_SUBTITLE =
      "Dùng tên thật giúp bạn bè dễ dàng nhận ra bạn hơn.";
  // static const String NAME_LOGIN_BEGIN_TEXT_BUTTON = "Bắt đầu";
}

class BirthDayLoginConstants {
  static String BIRTHDAY_LOGIN_TITLE = "Bạn sinh vào ngày nào ?";
  static String BIRTHDAY_LOGIN_SUBTITLE =
      "Bạn có thể chọn xem ai được thấy nội dung này trên trang cá nhân của mình.";
  static String BIRTHDAY_LOGIN_NAME_PLACEHOLODER =
      'Ngày, tháng, năm sinh của bạn';

  static String BIRTHDAY_LOGIN_QUESTION =
      "Tại sao tôi cần cung cấp ngày sinh của mình ?";
  static String BIRTHDAY_LOGIN_WARNING =
      "Ngày sinh không hợp lệ. Hãy kiểm tra lại nhé !";
}

class GenderLoginConstants {
  static String GENDER_LOGIN_TITLE = "Giới tính của bạn là gì ?";
  static String GENDER_LOGIN_SUBTITLE =
      "Về sau, bạn có thể thay đổi những ai nhìn thấy giới tính của mình trên trang cá nhân ";

  static Map<String, dynamic> GENDER_LOGIN_NAME_SELECTIONS = {
    "key": "gender_login_selections",
    "data": [
      {
        "key": "female",
        "title": "Nữ",
      },
      {
        "key": "male",
        "title": "Nam",
      },
      {
        "key": "other",
        "title": "Khác",
        "subTitle":
            "Chọn lựa chọn này nếu bạn thuộc giới tính khác hoặc không muốn tiết lộ."
      },
    ]
  };
  static Map<String, dynamic> GENDER_LOGIN_SELECTIONS_FOR_BOTTOM_SHEET = {
    "key": "gender_login_selections_for_bottom_sheet",
    "data": [
      {"title": "Cô ấy", "subTitle": "Chúc cô ấy sinh nhật vui vẻ"},
      {"title": "Anh ấy", "subTitle": "Chúc anh ấy sinh nhật vui vẻ"},
      {"title": "Họ", "subTitle": "Chúc họ sinh nhật vui vẻ"},
    ]
  };
  static String GENDER_LOGIN_SELECTION_ANONYMOUS_NAME_PLACEHOLDER =
      "Chọn danh xưng";
  static String GENDER_LOGIN_NAME_PLACEHOLODER =
      "Nhập giới tính của bạn( không bắt buộc )";
  static String GENDER_LOGIN_DESCRIPTION =
      "Danh xưng của bạn hiển thị với tất cả mọi người";
}

class PhoneLoginConstants {
  static List<String> PHONE_LOGIN_TITLE = [
    "Số di động của bạn là gì ?",
    "Địa chỉ email của bạn là gì ?"
  ];
  static List<String> PHONE_LOGIN_PLACEHOLODER = [
    "Nhập số di động của bạn",
    "Nhập địa chỉ email của bạn",
  ];
  static List<String> PHONE_LOGIN_CHANGE_SELECTION_TEXT_BUTTON = [
    "Dùng địa chỉ email của bạn",
    "Dùng số điện thoại của bạn"
  ];
  static List<String> PHONE_LOGIN_DESCRIPTION = [
    "Bạn sẽ dùng số này khi đăng nhập và khi cần đặt lại mật khẩu",
    "Bạn sẽ dùng email này khi đăng nhập và khi cần đặt lại mật khẩu."
  ];
  static const List<String> PHONE_LOGIN_LIST_PHONE = [
    'US +1',
    'AL +355',
    'VN +84',
    'AC +34',
    'JP +99',
    'UK +100',
    "AF +93",
    "AL +355",
    "DZ +213",
    "AS +1-684",
    "AD +376",
    "AO +244",
    "AI +1-264",
    "AQ +672",
    "ER +1-268 ",
    "AR +54",
    "AM +374",
    "AW +297",
    "AU +61",
    "AT +43",
  ];
  static String PHONE_LOGIN_QUESTION =
      "Tại sao tôi cần cung cấp ngày sinh của mình ?";
  static String PHONE_LOGIN_WARNING =
      "Ngày sinh không hợp lệ. Hãy kiểm tra lại nhé !";
}

class EmailLoginConstants {
  static String EMAIL_LOGIN_TITLE = "Tạo mật khẩu";
  static String EMAIL_LOGIN_SUBTITLE =
      "Nhập mật khẩu có tối thiểu 6 ký tự bao gồm số, chữ cái và dấu chấm câu (như ! và &)";
  static String EMAIL_LOGIN_NAME_PLACEHOLODER = 'Mật khẩu';
}

class CompleteLoginConstants {
  static String COMPLETE_LOGIN_TITLE = "Hoàn tất đăng ký";
  static List<String> COMPLETE_LOGIN_SUBTITLE = [
    "Bằng cách nhấn vào Đăng ký, bạn đồng ý với ",
    "Điều khoản",
    ", ",
    "Chính sách dữ liệu",
    " và ",
    "Chính sách cookie",
    " của chúng tôi. Bạn có thể nhận được thông báo của chúng tôi qua SMS và chọn không nhận bất cứ lúc nào."
  ];
  static String COMPLETE_LOGIN_NAME_PLACEHOLODER = 'Hoàn tất';
}

class ConfirmLoginConstants {
  static String CONFIRM_LOGIN_APPBAR_TITLE = "Xác nhận tài khoản";
  static List<String> CONFIRM_LOGIN_TITLE = [
    "Chúng tôi sẽ gửi cho bạn mã để xác nhận tài khoản là của bạn",
    "Mã đã được gửi đến điện thoại của bạn. Hãy nhập mã đó tại đây."
  ];
  static Map<String, dynamic> CONFIRM_LOGIN_USER = {
    "icon": LoginConstants.PATH_IMG + "example_cover_img_1.jpg",
    "title": "Sam Smiths",
    "subTitle": "Người dùng Emso Network"
  };
  static Map<String, dynamic> CONFIRM_LOGIN_SELECTIONS = {
    "key": "confirm_selection_key",
    "data": [
      {"title": "Xác nhận qua SMS", "content": "+840346311359"},
      {"title": "Xác nhận qua email", "content": "abc@gmail.com"},
    ]
  };

  static String CONFIRM_LOGIN_NEXT = 'Tiếp tục';
  static String CONFIRM_LOGIN_ENTER_PASSWORD_TO_LOGIN =
      'Nhập mật khẩu để đăng nhập';
  static String CONFIRM_LOGIN_NOT_ACCESS = 'Không còn truy cập được nữa';
}

class SettingLoginConstants {
  static String GETTING_LOGIN_APPBAR_TITLE = "Cài đặt đăng nhập";
  static String GETTING_LOGIN_GET_NOTI = "Nhận thông báo";
  static Map<String, dynamic> GETTING_LOGIN_SELECTIONS = {
    "key": "confirm_selection_key",
    "data": [
      {
        "title": "Gỡ thông tin đăng nhập đã lưu",
        "subTitle": "Dùng mật khẩu để đăng nhập"
      },
      {
        "title": "Gỡ tài khoản",
        "subTitle": "Dùng số điện thoại hoặc email và mật khẩu để đăng nhập"
      },
    ]
  };

  static String GETTING_LOGIN_DELETE_ACCOUNT = 'Gỡ tài khoản';
}

class LogoutAllDeviceLoginConstants {
  static String LOGOUT_ALL_DEVICE_LOGIN_APPBAR_TITLE =
      "Đăng xuất tất cả thiết bị";
  static String LOGOUT_ALL_DEVICE_LOGIN_TITLE =
      "Bạn có thể đăng xuất tài khoản ra khỏi bất kỳ nơi nào đang mở tài khoản đó.";

  static Map<String, dynamic> LOGOUT_ALL_DEVICE_LOGIN_SELECTIONS = {
    "key": "logout_all_device_login_selection_key",
    "data": [
      {
        "title": "Duy trì đăng nhập",
      },
      {
        "title": "Đăng xuất tôi khỏi thiết bị khác",
        "subTitle": "Chọn đăng xuất nếu có người lạ sử dụng tài khoản của bạn"
      },
    ]
  };
}

class NewPasswordLoginConstants {
  static String NEW_PASWORD_LOGIN_APPBAR_TITLE = "Tạo mật khẩu mới";
  static String NEW_PASWORD_LOGIN_TITLE =
      "Tạo mật khẩu mới. Bạn sẽ sử dụng mật khẩu này để truy cập tài khoản.";
  static String NEW_PASWORD_LOGIN_PLACEHOLDER = "Nhập mật khẩu mới";
  static String NEW_PASWORD_LOGIN_DESCRIPTION =
      "Nhập mật khẩu gồm ít nhất sáu chữ số, chữ cái và dấu câu.";
}
