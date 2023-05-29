import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class UserPagePinPost extends ConsumerStatefulWidget {
  final dynamic user;
  final List pinPosts;
  const UserPagePinPost({Key? key, this.user, required this.pinPosts})
      : super(key: key);

  @override
  ConsumerState<UserPagePinPost> createState() => _UserPagePinPostState();
}

class _UserPagePinPostState extends ConsumerState<UserPagePinPost> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.pinPosts.isNotEmpty
        ? Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  children: const [
                    Icon(
                      FontAwesomeIcons.thumbtack,
                      size: 18,
                    ),
                    SizedBox(
                      width: 4.0,
                    ),
                    Text(
                      'Bài viết đã ghim',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 12.0,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    widget.pinPosts.length,
                    (index) => Container(
                      width: size.width * 0.85,
                      height: size.height * 0.4,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: const EdgeInsets.only(top: 15.0, bottom: 7.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.3, color: greyColor),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: ClipRect(
                        child: Align(
                          alignment: Alignment.topCenter,
                          heightFactor: 1.0,
                          widthFactor: 1.0,
                          child: Post(
                            type: postPageUser,
                            isHiddenCrossbar: true,
                            isHiddenFooter: true,
                            post: widget.pinPosts[index],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const CrossBar(),
            ],
          )
        : const SizedBox();
  }
}
