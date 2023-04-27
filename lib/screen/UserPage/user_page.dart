import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_information_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Post/PostCenter/post_media.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_edit_profile.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_friend_block.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_infomation_block.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_pin_post.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_photo_video.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/chip_menu.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';
import 'dart:convert';

class UserPage extends ConsumerStatefulWidget {
  final dynamic user;
  const UserPage({
    Key? key,
    this.user,
  }) : super(key: key);

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage> {
  dynamic id;
  final scrollController = ScrollController();
  dynamic userData = {};
  List postUser = [];
  bool isMorePageUser = true;
  dynamic userAbout = {};
  List featureContents = [];
  List friend = [];
  List pinPost = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final queryParams =
            ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
        setState(() {
          id = queryParams['id'];
        });
      });

      Future.delayed(Duration.zero, () async {
        // ref.read(postControllerProvider.notifier).removeListPost('user');
        // ref.read(userInformationProvider.notifier).removeUserInfo();

        List postUserNew =
            await UserPageApi().getListPostApi(id, {"exclude_replies": true}) ??
                [];
        ref
            .read(postControllerProvider.notifier)
            .getListPostUserPage(id, {"exclude_replies": true, "limit": 5});
        dynamic userDataNew = await UserPageApi().getAccountInfor(id);
        dynamic userAboutNew =
            await UserPageApi().getAccountAboutInformation(id);
        var friendNew = await UserPageApi().getUserFriend(id, {'limit': 20});
        var pinNew = await PostApi().getListPostPinApi(id) ?? [];
        setState(() {
          postUser = postUserNew;
          userData = userDataNew;
          userAbout = userAboutNew;
          pinPost = pinNew;
          friend = friendNew;
        });
      });
    }

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent < 4000 ||
          (scrollController.offset).toDouble() <
                  scrollController.position.maxScrollExtent &&
              (scrollController.offset).toDouble() >
                  scrollController.position.maxScrollExtent - 4000) {
        EasyDebounce.debounce('my-debouncer', const Duration(milliseconds: 300),
            () {
          // if (ref.read(postControllerProvider).postUserPage.isEmpty) return;
          // if (id != null) {

          String maxId = "";
          if (ref.read(postControllerProvider).postUserPage.isEmpty) {
            maxId = postUser.last['id'];
          } else {
            maxId = ref.read(postControllerProvider).postUserPage.last['id'];
          }
          ref.read(postControllerProvider.notifier).getListPostUserPage(
              id, {"max_id": maxId, "exclude_replies": true, "limit": 5});
          // }
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var userAbout = ref.watch(userInformationProvider).userMoreInfor;
    if (ref.watch(postControllerProvider).postUserPage.isNotEmpty) {
      postUser = ref.watch(postControllerProvider).postUserPage;
      isMorePageUser = ref.watch(postControllerProvider).isMoreUserPage;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            AppBarTitle(title: userData?['display_name'] ?? ''),
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
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BannerBase(object: userData, objectMore: userAbout),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 35,
                      width: size.width - 85,
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
                      width: 48,
                      child: ButtonPrimary(
                        label: "···",
                        handlePress: () {},
                      )),
                ],
              ),
            ),
            const CrossBar(),
            UserPageInfomationBlock(
                user: userData,
                userAbout: userAbout,
                featureContents: featureContents),
            const CrossBar(),
            UserPageFriendBlock(user: userData, friends: friend),
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
            InkWell(
              onTap: () {
                pushToNextScreen(context, const UserPhotoVideo());
              },
              child: SizedBox(
                width: 118,
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
            ),
            const CrossBar(),
            UserPagePinPost(
              user: userData,
              pinPosts: pinPost,
            ),
            ListView.builder(
                shrinkWrap: true,
                primary: false,
                itemCount: postUser.length,
                itemBuilder: (context, index) => Post(
                      type: postPageUser,
                      post: postUser[index],
                    )),
            isMorePageUser
                ? Center(child: SkeletonCustom().postSkeleton(context))
                : Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: buildTextContent("Không còn bài viết nào khác", true,
                        fontSize: 20, isCenterLeft: false),
                  )
          ],
        ),
      ),
    );
  }
}
