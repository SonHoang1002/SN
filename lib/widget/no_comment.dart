import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class NoComment extends StatelessWidget {
  const NoComment({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Icon(
          FontAwesomeIcons.solidComments,
          size: 100,
          color: Theme.of(context).canvasColor,
        ),
        const SizedBox(
          height: 20,
        ),
        const SizedBox(
          width: 300,
          child: Text(
            'Chưa có bình luận nào, hãy trở thành người bình luận đầu tiên!',
            textAlign: TextAlign.center,
            style:
                TextStyle(fontSize: 13, color: greyColor, letterSpacing: 0.3),
          ),
        )
      ],
    );
  }
}
