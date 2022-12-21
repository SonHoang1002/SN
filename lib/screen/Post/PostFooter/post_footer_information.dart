import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class PostFooterInformation extends StatelessWidget {
  const PostFooterInformation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: greyColor, fontSize: 14);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '2.3K',
            style: style,
          ),
          Row(
            children: const [
              Text(
                "81 bình luận",
                style: style,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                '12 lượt chia sẻ',
                style: style,
              )
            ],
          )
        ],
      ),
    );
  }
}
