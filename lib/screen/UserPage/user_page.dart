import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/data/post.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_friend_block.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_infomation_block.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';

class UserPage extends StatelessWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(title: meData['display_name']),
            Row(
              children: [
                Icon(
                  FontAwesomeIcons.pen,
                  size: 18,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
                const SizedBox(
                  width: 10.0,
                ),
                Icon(
                  FontAwesomeIcons.magnifyingGlass,
                  size: 18,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                )
              ],
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerBase(object: meData, objectMore: userAbout),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 35,
                      width: size.width - 75,
                      child: ButtonPrimary(
                        icon: const Icon(
                          FontAwesomeIcons.pen,
                          size: 16,
                          color: white,
                        ),
                        label: "Chỉnh sửa trang cá nhân",
                        handlePress: () {},
                      )),
                  SizedBox(
                      height: 35,
                      width: 45,
                      child: ButtonPrimary(
                        label: "···",
                        handlePress: () {},
                      )),
                ],
              ),
            ),
            const CrossBar(),
            UserPageInfomationBlock(user: meData, userAbout: userAbout),
            const CrossBar(),
            const UserPageFriendBlock(),
            ListView.builder(
                shrinkWrap: true,
                primary: true,
                itemCount: postUser.length,
                itemBuilder: (context, index) => Post(
                      type: postPageUser,
                      post: postUser[index],
                    ))
          ],
        ),
      ),
    );
  }
}
