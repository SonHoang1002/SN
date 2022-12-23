import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/gradient_color.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class PostTarget extends StatelessWidget {
  final dynamic post;
  const PostTarget({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.width + 100,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: getGradientColor(
              '${post['status_target']['color'].replaceAll('-', '').replaceAll(' ', '')}')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          post['status_target']['target_status'] == postTargetStatus
              ? SvgPicture.asset(
                  "assets/win.svg",
                  width: size.width * 0.5,
                )
              : SvgPicture.asset(
                  "assets/target.svg",
                  width: size.width * 0.5,
                ),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: Text(
              post['status_target']['content'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: white, fontSize: 30, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
