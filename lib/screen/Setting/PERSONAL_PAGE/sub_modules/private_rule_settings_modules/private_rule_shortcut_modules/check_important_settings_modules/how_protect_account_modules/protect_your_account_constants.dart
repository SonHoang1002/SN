
import '../../../../../../setting_constants/general_settings_constants.dart';

class HowToProtectYourAccountConstants {
  static const HOW_TO_PROTECT_YOUR_ACCOUNT_TITLE = "Cách bảo vệ tài khoản";
  static const HOW_TO_PROTECT_YOUR_ACCOUNT_SUBTITLE =
      "Hãy cùng xem một vài bước hướng dẫn để bảo vệ tài khoản của bạn nhé.";
  static const Map<String, dynamic> HOW_TO_PROTECT_YOUR_ACCOUNT_CONTENTS = {
    "key": "how_to_protect_account",
    "data": [
      {
        "key": "turn_on_login_warning",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Bật cảnh báo đăng nhập"
      },
      {
        "key": "OK_password",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Mật khẩu OK"
      },
      {
        "key": "turn_on_2-factor_authentication",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "content": "Bật tính năng xác thực 2 yếu tố"
      }
    ]
  };
  static const String WHO_CAN_SEE_WHAT_YOU_SHARE_NEXT = "Tiếp tục";
  static const String ALL_COMPLETED_TITLE = "Gần xong rồi";
  static const String ALL_COMPLETED_SUBTITLE = "Cám ơn bạn đã xem lại tùy chọn bảo mật. Bạn có thể thay đổi những tùy chọn này bất cứ lúc nào trong phần cài đặt.";
  static const Map<String, dynamic> ALL_COMPLETED_CONTENTS = HOW_TO_PROTECT_YOUR_ACCOUNT_CONTENTS;
  // static const String ALL_COMPLETED_REVIEW_OTHER_TOPICS = "Xem lại chủ đề khác";
  // static const String ALL_COMPLETED_FIX_REMAINING_BUGS = "Sửa các lỗi còn lại";
}

class LoginWarningConstants {
  static const LOGIN_WARNING_APPAR_TITLE = "Cảnh báo đăng nhập";
  static const LOGIN_WARNING_TITLE = "Bật cảnh báo";
  static const LOGIN_WARNING_SUBTITLE =
      "Khi bật cảnh báo, bạn sẽ biết nếu có người đăng nhập vào tài khoản của bạn từ địa điểm lạ. CHúng tôi sẽ cho bạn biết lần đăng nhập đó được thực hiện ở đâu và trên thiết bị nào.";
  static const Map<String, dynamic> LOGIN_WARNING_CONTENTS = {
    "key": "login_warning",
    "data": [
      {
        "key": "facebook",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Facebook",
        "subTitle": "Chúng tôi sẽ gửi cho bạn thông báo trên Facebook",
      },
      {
        "key": "email",
        "icon": SettingConstants.PATH_ICON + "bell_icon.svg",
        "title": "Email",
        "subTitle": "Chúng tôi sẽ gửi cảnh báo đến a@gmail.com",
      },
    ]
  };
  static const String LOGIN_WARNING_SKIP = "Bỏ qua";
}

class PasswordConstants {
  static const PASSWORD_APPAR_TITLE = "Mật khẩu";
  static const PASSWORD_TITLE = "Có ai biết mật khẩu của bạn không ?";
  static const PASSWORD_SUBTITLE =
      "Nếu bạn dùng mật khẩu Facebook ở cả nơi khác trên mạng thì tài khoản sẽ ít an toàn hơn. Hãy chọn mật khẩu mạnh hơn để bảo vệ chính mình và bạn bè trên Facebook.";

  static const Map<String, dynamic> PASSWORD_CONTENTS = {
    "key": "tip_for_choose_password",
    "title": "Mẹo chọn mật khẩu",
    "subTitle": [
      "Chọn mật khẩu mà bạn chưa dùng ở nơi nào khác trên mạng.",
      "hãy tạo mật khẩu dễ nhớ với bạn nhưng khó đoán với người khác.",
      "Đừng chia sẻ mật khẩu với bất kỳ ai."
    ]
  };
  static const PASSWORD_CHANGE_PASSWORD = "Đổi mật khẩu";
  static const PASSWORD_SAVE_CHANGE = "Lưu thay đổi";
  static const PASSWORD_FORGOT_PASSWORD = "Quên mật khẩu ?";
  static const String PASSWORD_SKIP = "Bỏ qua";
}

// authenticate_two_factors_page
class AuthenticateTwoFactorsConstants {
  static const AUTHENTICATE_TWO_FACTOR_APPAR_TITLE = "Xác nhận 2 yếu tố";
  static const AUTHENTICATE_TWO_FACTOR_TITLE =
      "Tăng cường bảo mật cho tài khoản";
  static const AUTHENTICATE_TWO_FACTOR_SUBTITLE =
      "Khi bạn bật tính năng xác thực 2 yếu tố, chúng tôi sẽ yêu cầu bạn cung cấp mã nếu phát hiện thấy lần đăng nhập từ một thiết bị hoặc trình duyệt lạ";
  static const Map<String, dynamic> AUTHENTICATE_TWO_FACTOR_CONTENTS = {
    "key": "authenticate_two_factors_page",
    "title": "Bí quyết bảo mật",
    "subTitle": [
      "Bạn có thể thiết lập tính năng này thông qua SMS hoặc một ứng dụng xác thực khác trên nhiều thiết bị",
      "Ban không thể đặt lại mật khẩu bằng số điện thoại dùng để xác thực 2 yếu tố. Hãy chắc chắn rằng bạn có ít nhất 1 email hoặc số điện thoại khác trên tài khoản của mình.",
    ]
  };
  static const AUTHENTICATE_TWO_FACTORS_BEGIN_BUTTON = "Bắt đầu";
  static const AUTHENTICATE_TWO_FACTORS_LEARN_MORE_BUTTON = "Tìm hiểu thêm";

  // next part
  static const AUTHENTICATE_TWO_FACTOR_IMG =
      SettingConstants.PATH_IMG + "back_1.jpg";
  static const AUTHENTICATE_TWO_FACTOR_PROTECT_ACCOUNT_TITLE =
      "Giúp bảo vệ tài khoản của bạn";
  static const AUTHENTICATE_TWO_FACTOR_PROTECT_ACCOUNT_SUBTITLE =
      "Nếu phát hiện thấy lần đăng nhập từ thiết bị hoặc trình duyệt khác mà chúng tôi không nhận ra, chúng tôi sẽ yêu cầu bạn cung cấp mật khẩu và mã xác minh.";
  static const AUTHENTICATE_TWO_FACTOR_CHOOSE_A_SECURITY_METHOD_TITLE =
      "Chọn phương thức bảo mật";
  static const Map<String, dynamic>
      AUTHENTICATE_TWO_FACTOR_CHOOSE_A_SECURITY_METHOD_CONTENTS = {
    "key": "authenticate_two_factors",
    "data": [
      {
        "key": "authenticate_application",
        "title": "Ứng dụng xác thực",
        "subTitle":
            "Đề xuất - Tạo mã xác minh bằng các ứng dụng như Google Authenticaor hoặc Duo Mobile để đảm bảo an toàn tốt hơn."
      },
      {
        "key": "text_messages",
        "title": "Tin nhắn văn bản (SMS)",
        "subTitle":
            "Dùng tin nhắn văn bản( SMS) để nhận mã xác minh. Vì lí do bảo mật, bạn không thể sử dụng số điện thoại đã dùng cho xác thực 2 yếu tố để đặt lại mật khẩu khi đang bật tính năng này."
      },
      {
        "key": "security_lock",
        "title": "Khóa bảo mật",
        "subTitle":
            "Sử dụng khóa bảo mật vật lý để không ai có thể truy cập trái phép vào tài khoản Facebook của bạn. Bạn sẽ không cần nhập mã nữa."
      },
    ]
  };
  static const PASSWORD_SKIP = "Bỏ qua";
}


