import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/helper/gradient_color.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';

class PostTarget extends StatelessWidget {
  final dynamic post;
  final String? type;
  final dynamic statusQuestion;
  const PostTarget({Key? key, this.post, this.type, this.statusQuestion})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.width + 100,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: getGradientColor('${([
            postCreateQuestionAnwer,
            postQuestionAnwer,
            'target_create'
          ].contains(type) ? statusQuestion['color'] : post['status_target']['color']).replaceAll('-', '').replaceAll(' ', '')}')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          [postCreateQuestionAnwer, postQuestionAnwer, 'target_create']
                  .contains(type)
              ? type == 'target_create'
                  ? SvgPicture.asset(
                      "assets/target.svg",
                      width: size.width * 0.5,
                    )
                  : AvatarSocial(
                      width: size.width * 0.35,
                      height: size.width * 0.35,
                      path: (post?['account'] ?? meData)['avatar_media']
                          ['preview_url'])
              : post['status_target']['target_status'] == postTargetStatus
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
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              [postCreateQuestionAnwer, postQuestionAnwer, 'target_create']
                      .contains(type)
                  ? statusQuestion['content']
                  : post['status_target']['content'],
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: white, fontSize: 22, fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }
}
