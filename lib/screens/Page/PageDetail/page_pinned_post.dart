import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';

class PagePinPost extends ConsumerStatefulWidget {
  const PagePinPost({Key? key}) : super(key: key);

  @override
  ConsumerState<PagePinPost> createState() => _PagePinPostState();
}

class _PagePinPostState extends ConsumerState<PagePinPost> {
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
    List pinPosts = ref.watch(pageControllerProvider).pagePined;
    final size = MediaQuery.of(context).size;

    return pinPosts.isNotEmpty
        ? Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                padding: const EdgeInsets.only(top: 12),
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
                      'Đáng chú ý',
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
                    pinPosts.length,
                    (index) => Container(
                      width: size.width,
                      margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                      padding: const EdgeInsets.only(top: 15.0, bottom: 15.0),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0.3, color: greyColor),
                          borderRadius: BorderRadius.circular(12.0)),
                      child: Post(
                        type: postPageUser,
                        isHiddenCrossbar: true,
                        post: pinPosts[index],
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
