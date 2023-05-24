import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/post_api.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screen/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_edit_profile.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_friend_block.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_infomation_block.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_page_pin_post.dart';
import 'package:social_network_app_mobile/screen/UserPage/user_photo_video.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../constant/post_type.dart';
import '../../helper/push_to_new_screen.dart';
import '../../widget/GeneralWidget/text_content_widget.dart';
import '../../widget/chip_menu.dart';
import '../../widget/cross_bar.dart';
import '../../widget/skeleton.dart';
import '../Feed/create_post_button.dart';

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
  List lifeEvent = [];

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
        List postUserNew =
            await UserPageApi().getListPostApi(id, {"exclude_replies": true}) ??
                [];
        List lifeEventNew = await UserPageApi().getListLifeEvent(id) ?? [];
        ref
            .read(postControllerProvider.notifier)
            .getListPostUserPage(id, {"exclude_replies": true, "limit": 5});
        dynamic userDataNew = await UserPageApi().getAccountInfor(id);
        dynamic userAboutNew =
            await UserPageApi().getAccountAboutInformation(id);
        var friendNew = await UserPageApi().getUserFriend(id, {'limit': 20});
        var pinNew = await PostApi().getListPostPinApi(id) ?? [];

        setState(() {
          lifeEvent = lifeEventNew;
          postUser = postUserNew;
          userData = userDataNew;
          userAbout = userAboutNew;
          pinPost = pinNew;
          friend = friendNew;
        });
      });
    }

    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (double.parse((scrollController.offset).toStringAsFixed(0)) %
                100.0 ==
            0) {
          EasyDebounce.debounce(
              'my-debouncer', const Duration(milliseconds: 300), () {
            String maxId = "";
            if (ref.read(postControllerProvider).postUserPage.isEmpty) {
              maxId = postUser.last['id'];
            } else {
              maxId = ref.read(postControllerProvider).postUserPage.last['id'];
            }
            ref.read(postControllerProvider.notifier).getListPostUserPage(
                id, {"max_id": maxId, "exclude_replies": true, "limit": 10});
          });
        }
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
    if (ref.watch(postControllerProvider).postUserPage.isNotEmpty) {
      postUser = ref.read(postControllerProvider).postUserPage;
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
      body: RefreshIndicator(
        onRefresh: () async {
          Future.delayed(const Duration(milliseconds: 800), () {
            ref.read(postControllerProvider.notifier).getListPostUserPage(
                id, {"exclude_replies": true, "limit": 20});
          });
        },
        child: SingleChildScrollView(
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
              // Row(
              //   children: const [
              //     SizedBox(
              //       child: ChipMenu(
              //         isSelected: true,
              //         label: "Bài viết",
              //       ),
              //     ),
              //     SizedBox(
              //       child: ChipMenu(
              //         isSelected: false,
              //         label: "Ảnh",
              //       ),
              //     ),
              //   ],
              // ),
              const Divider(
                height: 20,
                thickness: 1,
              ),
              UserPageInfomationBlock(
                  user: userData,
                  lifeEvent: lifeEvent,
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
              CreatePostButton(
                preType: postPageUser,
              ),
              const CrossBar(),
              InkWell(
                onTap: () {
                  pushToNextScreen(context, UserPhotoVideo(id: id));
                },
                child: SizedBox(
                  width: 130,
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
                        reloadFunction: () {
                          setState(() {});
                        },
                      )),
              isMorePageUser
                  ? Center(child: SkeletonCustom().postSkeleton(context))
                  : Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: buildTextContent(
                          "Không còn bài viết nào khác", true,
                          fontSize: 20, isCenterLeft: false),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
