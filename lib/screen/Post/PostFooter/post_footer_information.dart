import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';

class PostFooterInformation extends StatelessWidget {
  final dynamic post;
  const PostFooterInformation({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(color: greyColor, fontSize: 13);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          post['favourites_count'] > 0
              ? Text(
                  '${shortenLargeNumber(post['favourites_count'])}',
                  style: style,
                )
              : const SizedBox(),
          Row(
            children: [
              post['replies_total'] > 0
                  ? Text(
                      "${shortenLargeNumber(post['replies_total'])} bình luận",
                      style: style,
                    )
                  : const SizedBox(),
              const SizedBox(
                width: 5,
              ),
              post['reblogs_count'] > 0
                  ? Text(
                      '${shortenLargeNumber(post['reblogs_count'])} lượt chia sẻ',
                      style: style,
                    )
                  : const SizedBox()
            ],
          )
        ],
      ),
    );
  }
}
