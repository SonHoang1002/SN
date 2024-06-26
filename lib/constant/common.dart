import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List typeVisibility = [
  {
    "key": 'public',
    "icon": FontAwesomeIcons.earthAsia,
    "label": 'Công khai',
    "subLabel": 'Tất cả mọi người đều có thể xem'
  },
  {
    "key": 'friend',
    "icon": FontAwesomeIcons.user,
    "label": 'Bạn bè',
    "subLabel": 'Chỉ bạn bè của bạn mới xem được'
  },
  {
    "key": 'private',
    "icon": FontAwesomeIcons.lock,
    "label": 'Riêng tư',
    "subLabel": 'Không hiển thị trên bảng tin của người khác'
  }
];
List<Map<String, dynamic>> isPrivate = [
  {
    'is_private': false,
    'title': 'Công khai',
    'subTitle':
        'Bất kỳ ai cũng có thể nhìn thấy mọi người trong nhóm và những gì họ đăng.',
    'icon': 'assets/groups/publish.png',
  },
  {
    'is_private': true,
    'title': 'Riêng tư',
    'subTitle':
        'Chỉ thành viên mới nhìn thấy mọi người trong nhóm và những gì họ đăng.',
    'icon': 'assets/groups/private.png',
  },
];
List<Map<String, dynamic>> isVisible = [
  {
    'is_visible': true,
    'title': 'Hiển thị',
    'subTitle': 'Ai cũng có thể tìm thấy nhóm này.',
    'icon': 'assets/groups/trueVisible.png'
  },
  {
    'is_visible': false,
    'title': 'Ẩn nhóm',
    'subTitle': 'Chỉ thành viên mới tìm thấy nhóm này.',
    'icon': 'assets/groups/falseVisible.png'
  },
];
String linkAvatarDefault =
    'https://snapi.emso.asia/avatars/original/missing.png';

String linkBannerDefault =
    "https://sn.emso.vn/static/media/group_cover.81acfb42.png";

dynamic pollOptionMenuPost = {
  "key": 'poll',
  "label": 'Thăm dò ý kiến',
  "icon": FontAwesomeIcons.poll,
  "color": 0xFFf7923b,
  "display": 'group',
  "disabled": [
    'media',
    'life-event',
    'gif',
    'file',
    'write-suggest',
    'event-group',
    'answer-learn',
    'answer'
  ]
};

List listMenuPost = [
  {
    "key": 'media',
    "label": 'Ảnh/Video',
    "image": "assets/images_and_video.png",
    "disabled": [
      'life-event',
      'gif',
      'answer-learn',
      'answer',
      'poll',
      'event-group',
      'write-suggest',
      'file'
    ]
  },
  {
    "key": 'emoji-activity',
    "label": 'Cảm xúc/Hoạt động',
    "icon": FontAwesomeIcons.laugh,
    "color": 0xFFF5C33B,
    "disabled": []
  },
  {
    "key": 'tag-people',
    "label": 'Gắn thẻ người khác',
    "icon": FontAwesomeIcons.userTag,
    "color": 0xFF1877F2,
    "disabled": []
  },
  {
    "key": 'checkin',
    "label": 'Check in',
    "icon": FontAwesomeIcons.mapMarkedAlt,
    "color": 0xFFFA383E,
    "disabled": []
  },
  {
    "key": 'life-event',
    "label": 'Sự kiện trong đời',
    "icon": FontAwesomeIcons.solidFlag,
    "color": 0xFF39afd5,
    "disabled": ['media', 'gif', 'answer', 'answer-learn']
  },
  {
    "key": 'live-video',
    "label": 'Video trực tiếp',
    "image": "assets/live_video.png",
    "color": 0xFFFA383E,
    "disabled": []
  },
  {
    "key": 'bg-color',
    "label": 'Màu nền',
    "image": "assets/bg_color.png",
    "color": 0xFFFA383E,
    "disabled": []
  },
  {
    "key": 'camera',
    "label": 'Camera',
    "image": "assets/camera_menu.png",
    "color": 0xFFFA383E,
    "disabled": []
  },
  {
    "key": 'gif',
    "label": 'File GIF',
    "image": "assets/gif.png",
    "color": 0xFF2abba7,
    "disabled": [
      'media',
      'life-event',
      'answer',
      'poll',
      'write-suggest',
      'file',
      'answer-learn'
    ]
  },
  {
    "key": 'answer',
    "label": 'Tổ chức buổi H&Đ',
    "icon": FontAwesomeIcons.microphone,
    "color": 0xFFf02849,
    "disabled": [
      'media',
      'life-event',
      'gif',
      'poll',
      'file',
      'write-suggest',
      'answer-learn'
    ]
  },
  // {
  //   "key": 'event-group',
  //   "label": 'Tạo sự kiện',
  //   "icon": FontAwesomeIcons.calendarAlt,
  //   "color": 0xFFF35369,
  //   "display": 'group'
  // },
  // {
  //   "key": 'tag-event-group',
  //   "label": 'Gắn thẻ sự kiện',
  //   "icon": FontAwesomeIcons.calendarDay,
  //   "color": 0xFFF35369,
  //   "display": 'group',
  //   "disabled": []
  // },
  // {
  //   "key": 'write-suggest',
  //   "label": 'Viết gợi ý',
  //   "icon": FontAwesomeIcons.notesMedical,
  //   "color": 0xFF9360f7,
  //   "display": 'group',
  //   "disabled": [
  //     'media',
  //     'life-event',
  //     'gif',
  //     'file',
  //     'event-group',
  //     'answer-learn',
  //     'answer'
  //   ]
  // },
  // {
  //   "key": 'file',
  //   "label": 'Thêm file',
  //   "icon": FontAwesomeIcons.file,
  //   "color": 0xFF3578E5,
  //   "display": 'group',
  //   "disabled": [
  //     'media',
  //     'life-event',
  //     'gif',
  //     'poll',
  //     'write-suggest',
  //     'event-group',
  //     'answer-learn',
  //     'answer'
  //   ]
  // },
  // {
  //   "key": 'gifts',
  //   "label": 'Quà tặng',
  //   "icon": FontAwesomeIcons.gifts,
  //   "color": 0xFFdb1a8b,
  //   "disabled": []
  // },
  // {
  //   "key": 'call',
  //   "label": 'Nhận cuộc gọi',
  //   "icon": FontAwesomeIcons.phone,
  //   "color": 0xFF1877f2,
  //   "disabled": []
  // },
  // {
  //   "key": 'message',
  //   "label": 'Thu hút tin nhắn',
  //   "icon": FontAwesomeIcons.commentSms,
  //   "color": 0xFF0099ff,
  //   "disabled": []
  // },
  {
    "key": 'target',
    "label": 'Công bố mục tiêu',
    "image": "assets/target_menu.png",
    "color": 0xFFFA383E,
    "disabled": [
      'media',
      'life-event',
      'gif',
      'poll',
      'file',
      'write-suggest',
      'answer-learn'
    ]
  }
];

double eGLRModalBtmHeight = 250.0; // eGLR = event + grow + learning + recruit
const String vtcpay = "VTCPAY";

const String momo = "MOMO";

const String cod = "COD";

const String vnpay = "VNPAY";
