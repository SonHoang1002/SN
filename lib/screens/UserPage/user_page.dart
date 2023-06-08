import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_edit_profile.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_friend_block.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_infomation_block.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_pin_post.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_photo_video.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

import '../../apis/post_api.dart';
import '../../apis/user_page_api.dart';
import '../../constant/post_type.dart';
import '../../helper/push_to_new_screen.dart';
import '../../providers/UserPage/user_information_provider.dart';
import '../../widgets/GeneralWidget/text_content_widget.dart';
import '../../widgets/chip_menu.dart';
import '../../widgets/cross_bar.dart';
import '../../widgets/skeleton.dart';
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
        var pinNew = await PostApi().getListPostPinApi(id) ?? [];
        List lifeEventNew = await UserPageApi().getListLifeEvent(id) ?? [];

        ref
            .read(postControllerProvider.notifier)
            .getListPostUserPage(id, {"limit": 3, "exclude_replies": true});
        ref.read(userInformationProvider.notifier).getUserInformation(id);
        ref.read(userInformationProvider.notifier).getUserMoreInformation(id);
        ref.read(userInformationProvider.notifier).getUserLifeEvent(id);
        ref.read(userInformationProvider.notifier).getUserFeatureContent(id);
        var friendNew = await UserPageApi().getUserFriend(id, {'limit': 20});
        setState(() {
          userData = ref.watch(userInformationProvider).userInfor;
          userAbout = ref.watch(userInformationProvider).userMoreInfor;
          lifeEvent = ref.watch(userInformationProvider).userLifeEvent;
          postUser = ref.watch(postControllerProvider).postUserPage;
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
              if (postUser.isNotEmpty) {
                maxId = postUser.last['id'];
              }
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

  _reloadFunction(dynamic type,dynamic newData) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(postControllerProvider.notifier)
          .changeProcessingPost(type, newData);
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
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
    );
  }

  Widget buildUserPageBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List featureContents = ref.watch(userInformationProvider).featureContent;
    if (ref.watch(postControllerProvider).postUserPage.isNotEmpty) {
      postUser = ref.read(postControllerProvider).postUserPage;
      isMorePageUser = ref.watch(postControllerProvider).isMoreUserPage;
    }
    return SingleChildScrollView(
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
                          builder: (context) => const CreateModalBaseMenu(
                            title: "Chỉnh sửa trang cá nhân",
                            body: UserPageEditProfile(),
                            buttonAppbar: SizedBox(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 35,
                  width: 48,
                  child: ButtonPrimary(
                    label: "···",
                    handlePress: () {},
                  ),
                ),
              ],
            ),
          ),
          const CrossBar(),
          UserPageInfomationBlock(
            user: userData,
            lifeEvent: lifeEvent,
            userAbout: userAbout,
            featureContents: featureContents,
          ),
          const CrossBar(),
          UserPageFriendBlock(user: userData, friends: friend),
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
          CreatePostButton(preType: postPageUser, reloadFunction: _reloadFunction,),
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
          UserPagePinPost(user: userData, pinPosts: pinPost),
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
            ),
          ),
          isMorePageUser
              ? Center(child: SkeletonCustom().postSkeleton(context))
              : Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: buildTextContent("Không còn bài viết nào khác", true,
                      fontSize: 20, isCenterLeft: false),
                )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          Future.delayed(const Duration(milliseconds: 800), () {
            ref.read(postControllerProvider.notifier).getListPostUserPage(
                id, {"exclude_replies": true, "limit": 20});
          });
        },
        child: buildUserPageBody(context),
      ),
    );
  }
}
