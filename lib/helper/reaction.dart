import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

renderImage(link, type) {
  double size = type == 'gif' ? 40 : 20;
  return Image.asset(
    link,
    width: size,
    height: size,
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

renderGif(type, key, {double size = 30}) {
  return Row(
    children: [
      renderImage('assets/reaction/$key.$type', type),
      type == 'png' ? renderText(key) : const SizedBox()
    ],
  );
}
