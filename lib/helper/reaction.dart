import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

renderImage(link, type, size) {
  // double iconSize = type == 'gif' ? size ?? 40 : 25;
  double iconSize = size;
  return Image.asset(
    link,
    width: iconSize,
    height: iconSize,
    errorBuilder: (context, error, stackTrace) =>
        const Icon(FontAwesomeIcons.faceAngry),
  );
}

renderText(key) {
  String text = 'Thích';
  if (key == 'like') {
    text = 'Thích';
  } else if (key == 'love') {
    text = 'Yêu thích';
  } else if (key == 'yay') {
    text = 'Tự hào';
  } else if (key == 'wow') {
    text = 'Wow';
  } else if (key == 'haha') {
    text = 'Haha';
  } else if (key == 'sad') {
    text = 'Buồn';
  } else {
    text = 'Phẫn nộ';
  }

  return Text(
    ' $text',
    style: TextStyle(
        fontWeight: FontWeight.w500,
        color: key == 'like'
            ? secondaryColor
            : key == 'love'
                ? Colors.red
                : primaryColor,
        fontSize: 12),
  );
}

Widget renderGif(type, key, {double size = 35, double? iconPadding = 0}) {
  return Padding(
    padding: EdgeInsets.zero,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(top: iconPadding!),
          child: renderImage('assets/reaction/$key.$type', type, size),
        ),
        type == 'png' ? renderText(key) : const SizedBox()
      ],
    ),
  );
}
