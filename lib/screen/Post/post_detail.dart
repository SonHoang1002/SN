import 'package:comment_tree/comment_tree.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_center.dart';
import 'package:social_network_app_mobile/screen/Post/PostFooter/post_footer.dart';
import 'package:social_network_app_mobile/screen/Post/post_header.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';

class PostDetail extends StatelessWidget {
  final dynamic post;
  const PostDetail({Key? key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const BackIconAppbar(),
            PostHeader(
              post: post,
              type: postDetail,
            ),
          ],
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      PostCenter(
                        post: post,
                      ),
                      PostFooter(
                        post: post,
                      ),
                      Container(
                        height: 1,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.3)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 8.0),
                        child: CommentTreeWidget<Comment, Comment>(
                          Comment(
                              avatar: 'null',
                              userName: 'null',
                              content:
                                  'felangel made felangel/cubit_and_beyond public '),
                          [
                            Comment(
                                avatar: 'null',
                                userName: 'null',
                                content:
                                    'A Dart template generator which helps teams'),
                            Comment(
                                avatar: 'null',
                                userName: 'null',
                                content:
                                    'A Dart template generator which helps teams generator which helps teams generator which helps teams'),
                            Comment(
                                avatar: 'null',
                                userName: 'null',
                                content:
                                    'A Dart template generator which helps teams'),
                            Comment(
                                avatar: 'null',
                                userName: 'null',
                                content:
                                    'A Dart template generator which helps teams generator which helps teams '),
                          ],
                          treeThemeData: const TreeThemeData(
                              lineColor: greyColor, lineWidth: 0.2),
                          avatarRoot: (context, data) => const PreferredSize(
                            preferredSize: Size.fromRadius(18),
                            child: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage('assets/post_background.png'),
                            ),
                          ),
                          avatarChild: (context, data) => const PreferredSize(
                            preferredSize: Size.fromRadius(12),
                            child: CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.grey,
                              backgroundImage:
                                  AssetImage('assets/post_background.png'),
                            ),
                          ),
                          contentChild: (context, data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'dangngocduc',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        '${data.content}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            ?.copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                DefaultTextStyle(
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: const [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('Thích'),
                                        SizedBox(
                                          width: 24,
                                        ),
                                        Text('Trả lời'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                          contentRoot: (context, data) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'dangngocduc',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        '${data.content}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .copyWith(
                                                fontWeight: FontWeight.w300,
                                                color: Colors.black),
                                      ),
                                    ],
                                  ),
                                ),
                                DefaultTextStyle(
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.bold),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Row(
                                      children: const [
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text('Like'),
                                        SizedBox(
                                          width: 24,
                                        ),
                                        Text('Reply'),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 0.1, color: greyColor))),
                  padding: const EdgeInsets.only(
                      top: 8.0, left: 8.0, right: 8.0, bottom: 15.0),
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.camera,
                        color: greyColor,
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      Expanded(
                          child: TextFormFieldCustom(
                        minLines: 1,
                        maxLines: 5,
                        autofocus: false,
                        hintText: "Viết bình luận...",
                        suffixIcon: InkWell(
                          onTap: () {},
                          child: const Icon(
                            FontAwesomeIcons.solidFaceSmile,
                            color: greyColor,
                          ),
                        ),
                      ))
                    ],
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
