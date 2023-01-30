import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/me_data.dart';
import 'package:social_network_app_mobile/data/post.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_edit_profile.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_friend_block.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_infomation_block.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
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
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 35,
                      width: size.width - 80,
                      child: ButtonPrimary(
                        icon: const Icon(
                          FontAwesomeIcons.pen,
                          size: 16,
                          color: white,
                        ),
                        label: "Chỉnh sửa trang cá nhân",
                        handlePress: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) =>
                                      const CreateModalBaseMenu(
                                          title: "Chỉnh sửa trang cá nhân",
                                          body: UserPageEditProfile(),
                                          buttonAppbar: SizedBox())));
                        },
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
            UserPageFriendBlock(user: meData),
            const SizedBox(
              height: 12.0,
            ),
            const CrossBar(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: const Text(
                "Bài viết của bạn",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 12.0,
            ),
            const CreatePostButton(),
            const CrossBar(),
            Container(
              width: 115,
              margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: ChipMenu(
                isSelected: false,
                label: "Ảnh/video",
                icon: SvgPicture.asset(
                  "assets/post_media.svg",
                  width: 18,
                  height: 18,
                ),
              ),
            ),
            const CrossBar(),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
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
