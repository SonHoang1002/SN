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

String linkAvatarDefault =
    'https://snapi.emso.asia/avatars/original/missing.png';

List listMenuPost = [
  {
    "key": 'media',
    "label": 'Ảnh/Video',
    "image": "assets/post_media.svg",
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
    "icon": FontAwesomeIcons.flag,
    "color": 0xFF39afd5,
    "disabled": ['media', 'gif', 'answer', 'answer-learn']
  },
  {
    "key": 'gif',
    "label": 'File GIF',
    "icon": FontAwesomeIcons.squareParking,
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
  {
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
  },
  {
    "key": 'event-group',
    "label": 'Tạo sự kiện',
    "icon": FontAwesomeIcons.calendarAlt,
    "color": 0xFFF35369,
    "display": 'group'
  },
  {
    "key": 'tag-event-group',
    "label": 'Gắn thẻ sự kiện',
    "icon": FontAwesomeIcons.calendarDay,
    "color": 0xFFF35369,
    "display": 'group',
    "disabled": []
  },
  {
    "key": 'write-suggest',
    "label": 'Viết gợi ý',
    "icon": FontAwesomeIcons.notesMedical,
    "color": 0xFF9360f7,
    "display": 'group',
    "disabled": [
      'media',
      'life-event',
      'gif',
      'file',
      'event-group',
      'answer-learn',
      'answer'
    ]
  },
  {
    "key": 'file',
    "label": 'Thêm file',
    "icon": FontAwesomeIcons.file,
    "color": 0xFF3578E5,
    "display": 'group',
    "disabled": [
      'media',
      'life-event',
      'gif',
      'poll',
      'write-suggest',
      'event-group',
      'answer-learn',
      'answer'
    ]
  },
  {
    "key": 'gifts',
    "label": 'Quà tặng',
    "icon": FontAwesomeIcons.gifts,
    "color": 0xFFdb1a8b,
    "disabled": []
  },
  {
    "key": 'call',
    "label": 'Nhận cuộc gọi',
    "icon": FontAwesomeIcons.phone,
    "color": 0xFF1877f2,
    "disabled": []
  },
  {
    "key": 'message',
    "label": 'Thu hút tin nhắn',
    "icon": FontAwesomeIcons.commentSms,
    "color": 0xFF0099ff,
    "disabled": []
  },
  {
    "key": 'target',
    "label": 'Công bố mục tiêu',
    "icon": FontAwesomeIcons.bullseye,
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
