import 'dart:convert';
import 'dart:math';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/home/home.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/post_provider.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_post.dart';
import 'package:social_network_app_mobile/screens/MarketPlace/screen/main_market_page.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/screens/Post/post.dart';
import 'package:social_network_app_mobile/screens/UserPage/SettingUser/user_list_settings.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_edit_profile.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_friend_block.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_infomation_block.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page_pin_post.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_photo_video.dart';
import 'package:social_network_app_mobile/screens/Watch/watch.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/storage/storage.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/Home/bottom_navigator_bar_emso.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/blue_certified_widget.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../apis/friends_api.dart';
import '../../apis/user_page_api.dart';
import '../../constant/post_type.dart';
import '../../data/list_menu.dart';
import '../../helper/push_to_new_screen.dart';
import '../../providers/UserPage/user_information_provider.dart';
import '../../providers/UserPage/user_media_provider.dart';
import '../../theme/theme_manager.dart';
import '../../widgets/GeneralWidget/text_content_widget.dart';
import '../../widgets/chip_menu.dart';
import '../../widgets/cross_bar.dart';
import '../../widgets/skeleton.dart';
import '../Feed/create_post_button.dart';
import '../Page/PageDetail/photo_page.dart';

class UserPageHome extends StatefulWidget {
  final String? id;
  final dynamic user;
  const UserPageHome({super.key, this.id, this.user});

  @override
  State<UserPageHome> createState() => _UserPageHomeState();
}

class _UserPageHomeState extends State<UserPageHome> {
  int _selectedIndex = 0;
  ValueNotifier<bool> isClickedHome = ValueNotifier(false);
  List<Widget> pageUserRoutes = [];

  List<Widget> pageHomeRoutes = [
    const Home(),
    const Moment(typePage: 'home'),
    const SizedBox(),
    const Watch(),
    const MainMarketPage(isBack: false)
  ];

  void initState() {
    super.initState();
    pageUserRoutes = [
      UserPage(
        id: widget.id,
        user: widget.user,
      ),
      const Moment(typePage: 'home'),
      const SizedBox(),
      const Watch(),
      const MainMarketPage(isBack: false)
    ];
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      showBarModalBottomSheet(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          context: context,
          builder: (context) => const CreatePost());
    } else if (index == 0 && isClickedHome.value) {
      Navigator.pushReplacement(
          context, CupertinoPageRoute(builder: (ctx) => const Home()));
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
    if (index == 0 && isClickedHome.value == false) {
      isClickedHome.value = true;
    }
  }

  @override
  void dispose() {
    isClickedHome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: pageUserRoutes,
        ),
        bottomNavigationBar: BottomNavigatorBarEmso(
          selectedIndex: _selectedIndex,
          onTap: _onItemTapped,
        ));
  }
}

class UserPage extends ConsumerStatefulWidget {
  final dynamic user;
  final String? id;

  const UserPage({Key? key, this.user, this.id}) : super(key: key);

  @override
  ConsumerState<UserPage> createState() => _UserPageState();
}

class _UserPageState extends ConsumerState<UserPage>
    with SingleTickerProviderStateMixin {
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
  bool showHeaderTabFixed = false;
  late TabController _tabController;
  var friendNew;

  String menuSelected = 'user_posts';

  ValueNotifier<bool> following = ValueNotifier(false);
  String userType = '';

  // save id of post
  ValueNotifier<dynamic> focusCurrentPostIndex = ValueNotifier("");

  void onReset() {
    setState(() {
      userData = ref.watch(userInformationProvider).userInfor;
      userAbout = ref.watch(userInformationProvider).userMoreInfor;
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      ref.read(userInformationProvider.notifier).removeUserInfo();
    });
    if (mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.id != null && widget.user != null) {
          setState(() {
            id = widget.id;
            userData = widget.user;
          });
        } else {
          final queryParams = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>;
          setState(() {
            id = queryParams['id'];
            userData = queryParams['user'];
          });
        }
      });
      Future.delayed(Duration.zero, () async {
        // ref.read(userInformationProvider.notifier).getUserInformation(id);
        // ref.read(userInformationProvider.notifier).getUserMoreInformation(id);
        // ref.read(userInformationProvider.notifier).getUserLifeEvent(id);
        // ref.read(userInformationProvider.notifier).getUserFeatureContent(id);
        final deviceUserId = await SecureStorage().getKeyStorage('userId');
        if (deviceUserId == id) {
          userType = 'me';
        } else {
          if (userData['relationships'] != null &&
              userData['relationships']['friendship_status'] == 'ARE_FRIENDS') {
            userType = 'friend';
          } else if (userData['relationships'] != null &&
              userData['relationships']['friendship_status'] ==
                  'OUTGOING_REQUEST') {
            userType = 'requested';
          } else {
            userType = 'stranger';
          }
          following.value = userData['relationships']?['following'];
        }

        ref.read(postControllerProvider.notifier).getListPostPin(id);

        ref.read(postControllerProvider.notifier).getListPostUserPage(
            id == ref.watch(meControllerProvider)[0]['id'],
            id,
            {"limit": 3, "exclude_replies": true});
        // conflict nhé 
      friendNew = await UserPageApi().getUserFriend(id, {'limit': 20}) ?? [];
      Future.delayed(Duration(milliseconds: 700), () async {
          if (mounted) {
            setState(() {
              userData = ref.watch(userInformationProvider).userInfor;
              userAbout = ref.watch(userInformationProvider).userMoreInfor;
              lifeEvent = ref.watch(userInformationProvider).userLifeEvent;
              postUser = (id == ref.watch(meControllerProvider)[0]['id']
                  ? ref.watch(postControllerProvider).postUserPage
                  : ref.watch(postControllerProvider).postAnotherUserPage);
              pinPost = ref.watch(postControllerProvider).postsPin;
            });
          }
        });
      friend = friendNew;
      });
    }

    if (userData == null) {
      final queryParams =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
      setState(() {
        userData = queryParams['user'];
      });
    }
    _tabController = TabController(vsync: this, length: userImageMenu.length);
    scrollController.addListener(() {
      if (!scrollController.hasClients) {
        return; // Avoid unnecessary operations if no clients are attached
      }

      final offset = scrollController.offset;
      final isScrollingDown = scrollController.position.userScrollDirection ==
          ScrollDirection.reverse;

      if (offset >= 300) {
        if (!showHeaderTabFixed) {
          setState(() {
            showHeaderTabFixed = true;
          });
        }
      } else if (offset < 300) {
        if (showHeaderTabFixed) {
          setState(() {
            showHeaderTabFixed = false;
          });
        }
      }

      if (isScrollingDown && offset % 120.0 == 0) {
        EasyDebounce.debounce(
            'my-debouncer', const Duration(milliseconds: 1000), () async {
          String maxId = '';
          final postUserPage = ref.read(postControllerProvider).postUserPage;

          if (postUserPage.isEmpty && postUser.isNotEmpty) {
            maxId = postUser.last['id'];
          } else if (postUserPage.isNotEmpty) {
            maxId = postUserPage.last['id'];
          }

          ref.read(postControllerProvider.notifier).getListPostUserPage(
              id == ref.watch(meControllerProvider)[0]['id'],
              id,
              {"max_id": maxId, "exclude_replies": true, "limit": 10});
        });
      }
    });
  } // void fetchData() async {
  //   ref.read(postControllerProvider.notifier).getListPostPin(id);
  //   ref.read(postControllerProvider.notifier).getListPostUserPage(
  //       id == ref.watch(meControllerProvider)[0]['id'],
  //       id,
  //       {"limit": 3, "exclude_replies": true});
  //   ref.read(userInformationProvider.notifier).getUserInformation(id);
  //   ref.read(userInformationProvider.notifier).getUserMoreInformation(id);
  //   ref.read(userInformationProvider.notifier).getUserLifeEvent(id);
  //   ref.read(userInformationProvider.notifier).getUserFeatureContent(id);
  //   var friendNew = await UserPageApi().getUserFriend(id, {'limit': 20});
  //   setState(() {
  //     userData = ref.watch(userInformationProvider).userInfor;
  //     userAbout = ref.watch(userInformationProvider).userMoreInfor;
  //     lifeEvent = ref.watch(userInformationProvider).userLifeEvent;
  //     postUser = (id == ref.watch(meControllerProvider)[0]['id']
  //             ? ref.watch(postControllerProvider).postUserPage
  //             : ref.watch(postControllerProvider).postAnotherUserPage);
  //     pinPost = ref.watch(postControllerProvider).postsPin;
  //     friend = friendNew;
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero, () async {
      ref.read(userInformationProvider.notifier).getUserInformation(id);
      ref.read(userInformationProvider.notifier).getUserMoreInformation(id);
      ref.read(userInformationProvider.notifier).getUserLifeEvent(id);
      ref.read(userInformationProvider.notifier).getUserFeatureContent(id);
    });
  }

  _reloadFunction(dynamic type, dynamic newData) {
    if (type == null && newData == null) {
      setState(() {});
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postControllerProvider.notifier).changeProcessingPost(newData,
          isIdCurrentUser: userData != null
              ? userData['id'] == ref.watch(meControllerProvider)[0]['id']
              : true);
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    focusCurrentPostIndex.dispose();
    scrollController.dispose();
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
          Row(
            children: [
              AppBarTitle(title: userData?['display_name'] ?? ''),
              userData?['certified'] == true
                  ? buildBlueCertifiedWidget()
                  : const SizedBox()
            ],
          ),
          Row(
            children: [
              Icon(
                FontAwesomeIcons.pen,
                size: 18,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
              const SizedBox(width: 10.0),
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

  PreferredSizeWidget buildAppBarHeader(BuildContext context) {
    return AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          width: MediaQuery.sizeOf(context).width,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 5),
          decoration:
              BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, child: headerTab()),
        ));
  }

  Widget _buildSendMessage() {
    // Nhắn tin cho ai đó -> điều hướng sang app nhắn tin
    return Flexible(
      child: ButtonPrimary(
        icon: const Icon(
          FontAwesomeIcons.facebookMessenger,
          size: 16,
          color: Colors.black,
        ),
        colorButton: Colors.grey[300],
        colorText: Colors.black,
        label: "Nhắn tin",
        handlePress: () {},
      ),
    );
  }

  Widget buildUserPageBody(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = pv.Provider.of<ThemeManager>(context);
    if (id == ref.watch(meControllerProvider)[0]['id']) {
      if (ref.watch(postControllerProvider).postUserPage.isNotEmpty) {
        postUser = ref.watch(postControllerProvider).postUserPage;
        isMorePageUser = ref.watch(postControllerProvider).isMoreUserPage;
      }
    } else {
      if (ref.watch(postControllerProvider).postAnotherUserPage.isNotEmpty) {
        postUser = ref.watch(postControllerProvider).postAnotherUserPage;
        isMorePageUser = ref.watch(postControllerProvider).isMoreAnother;
      }
    }
    return CustomScrollView(controller: scrollController, slivers: [
      SliverToBoxAdapter(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerBase(
            object: userData,
            objectMore: userAbout,
            type: 'user',
          ),
          buildSpacer(height: 10),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 35,
                  width: size.width - 85,
                  child: userType == 'me'
                      ? ButtonPrimary(
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
                                builder: (context) => CreateModalBaseMenu(
                                  title: "Chỉnh sửa trang cá nhân",
                                  body: UserPageEditProfile(onUpdate: onReset),
                                  buttonAppbar: const SizedBox(),
                                ),
                              ),
                            );
                          },
                        )
                      : userType == 'friend'
                          ? SizedBox(
                              width: size.width * 0.8,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Flexible(
                                    child: ButtonPrimary(
                                      icon: const Icon(
                                        FontAwesomeIcons.userCheck,
                                        size: 16,
                                        color: white,
                                      ),
                                      label: "Bạn bè",
                                      handlePress: () {
                                        showBarModalBottomSheet(
                                          context: context,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          builder: (context) {
                                            return Container(
                                              color: Colors.transparent,
                                              width: size.width,
                                              height: size.height * 0.125,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 10.0,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Flexible(
                                                    child: InkWell(
                                                      onTap: () {
                                                        if (following.value) {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Text(
                                                                'Đã bỏ theo dõi'),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ));
                                                          following.value =
                                                              false;
                                                          FriendsApi()
                                                              .unfollow(id);
                                                          return;
                                                        } else {
                                                          Navigator.pop(
                                                              context);
                                                          ScaffoldMessenger.of(
                                                                  context)
                                                              .showSnackBar(
                                                                  const SnackBar(
                                                            content: Text(
                                                                'Đã theo dõi lại'),
                                                            duration: Duration(
                                                                seconds: 2),
                                                          ));
                                                          following.value =
                                                              true;
                                                          FriendsApi()
                                                              .follow(id);
                                                          return;
                                                        }
                                                      },
                                                      child: SizedBox(
                                                        width: size.width,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              FontAwesomeIcons
                                                                  .squareXmark,
                                                              size: 20.0,
                                                              color: theme
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                            const SizedBox(
                                                                width: 15.0),
                                                            Text(
                                                              following.value
                                                                  ? "Bỏ theo dõi"
                                                                  : "Theo dõi lại",
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: theme
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Flexible(
                                                    child: InkWell(
                                                      onTap: () {
                                                        showCupertinoDialog(
                                                          context: context,
                                                          builder: ((context) {
                                                            return CupertinoAlertDialog(
                                                              content:
                                                                  Container(
                                                                margin:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                child: Text(
                                                                  "Bạn có chắc chắn muốn xóa ${userData?['display_name']} khỏi danh sách bạn bè không?",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          14.0),
                                                                ),
                                                              ),
                                                              actions: [
                                                                CupertinoDialogAction(
                                                                  isDefaultAction:
                                                                      true,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Hủy'),
                                                                ),
                                                                CupertinoDialogAction(
                                                                  isDestructiveAction:
                                                                      true,
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                    Navigator.pop(
                                                                        context);
                                                                    ScaffoldMessenger.of(
                                                                            context)
                                                                        .showSnackBar(
                                                                            const SnackBar(
                                                                      content: Text(
                                                                          'Đã hủy kết bạn'),
                                                                      duration: Duration(
                                                                          seconds:
                                                                              2),
                                                                    ));
                                                                    setState(
                                                                        () {
                                                                      userType =
                                                                          'stranger';
                                                                    });

                                                                    FriendsApi()
                                                                        .unfriend(
                                                                            id);
                                                                  },
                                                                  child:
                                                                      const Text(
                                                                          'Xóa'),
                                                                ),
                                                              ],
                                                            );
                                                          }),
                                                        );
                                                      },
                                                      child: SizedBox(
                                                        width: size.width,
                                                        child: Row(
                                                          children: [
                                                            Icon(
                                                              FontAwesomeIcons
                                                                  .userXmark,
                                                              size: 20.0,
                                                              color: theme
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : Colors
                                                                      .black,
                                                            ),
                                                            const SizedBox(
                                                                width: 15.0),
                                                            Text(
                                                              "Hủy kết bạn",
                                                              style: TextStyle(
                                                                fontSize: 15.0,
                                                                color: theme
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .black,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 7.5),
                                  _buildSendMessage(),
                                ],
                              ),
                            )
                          : userType == 'requested'
                              ? SizedBox(
                                  width: size.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: ButtonPrimary(
                                          icon: const Icon(
                                            FontAwesomeIcons.userPlus,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                          label: "Hủy lời mời",
                                          handlePress: () {
                                            setState(() {
                                              userType = 'stranger';
                                            });

                                            FriendsApi()
                                                .cancelFriendRequestApi(id);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 7.5),
                                      _buildSendMessage(),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  width: size.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: ButtonPrimary(
                                          icon: const Icon(
                                            FontAwesomeIcons.userPlus,
                                            size: 16,
                                            color: Colors.black,
                                          ),
                                          colorButton: Colors.grey[300],
                                          colorText: Colors.black,
                                          label: "Kết bạn",
                                          handlePress: () {
                                            setState(() {
                                              userType = 'requested';
                                            });
                                            FriendsApi()
                                                .sendFriendRequestApi(id);
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 7.5),
                                      _buildSendMessage(),
                                    ],
                                  ),
                                ),
                ),
                SizedBox(
                  height: 35,
                  width: 48,
                  child: ButtonPrimary(
                    icon: const Icon(
                      FontAwesomeIcons.ellipsis,
                      size: 16,
                      color: Colors.white,
                    ),
                    handlePress: () {
                      if (userType == "me") {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (_) => UserSettings(
                                    data: userData,
                                    roleUser: userType,
                                  )),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (userAbout != null) const CrossBar(),
          headerTab(),
          const CrossBar(),
          if (userAbout != null)
            UserPageInfomationBlock(
              user: userData,
              lifeEvent: lifeEvent,
              userAbout: userAbout,
              featureContents: featureContents,
            ),
          const CrossBar(
            height: 7,
            opacity: 0.1,
          ),
          UserPageFriendBlock(user: userData, friends: friend),
          id == ref.watch(meControllerProvider)[0]['id'] ||
                  // userType == "friend" ||
                  userData?['allow_post_status'] == true
              ? Column(
                  children: [
                    const CrossBar(
                      height: 7,
                      opacity: 0.1,
                    ),
                    CreatePostButton(
                      preType: postPageUser,
                      reloadFunction: _reloadFunction,
                      friendData: userData,
                      userType: userType,
                    ),
                  ],
                )
              : const SizedBox(),
          const CrossBar(
            height: 7,
            opacity: 0.1,
          ),
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
          id == ref.watch(meControllerProvider)[0]['id']
              ? Column(
                  children: [
                    const CrossBar(
                      height: 7,
                      opacity: 0.1,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: const Text(
                        "Bài viết của bạn",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                )
              : const SizedBox(),
          const CrossBar(
            height: 7,
            opacity: 0.1,
          ),
          UserPagePinPost(user: userData, pinPosts: pinPost)
        ],
      )),
      SliverList(
          delegate: SliverChildBuilderDelegate(
        (context, index) {
          return VisibilityDetector(
              key: Key(((postUser[index]?['id']) ?? Random().nextInt(1000))
                  .toString()),
              onVisibilityChanged: (info) {
                if (info.visibleFraction > 0.6) {
                  if (focusCurrentPostIndex.value != postUser[index]['id']) {
                    focusCurrentPostIndex.value = postUser[index]['id'];
                  }
                }
              },
              child: Post(
                type: postPageUser,
                post: postUser[index],
                isFocus: focusCurrentPostIndex.value == postUser[index]['id'],
                reloadFunction: () {
                  setState(() {});
                },
                friendData: userData,
              ));
        },
        childCount: postUser.length,
      )),
      SliverToBoxAdapter(
          child: isMorePageUser
              ? Center(child: SkeletonCustom().postSkeleton(context))
              : Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 20),
                  child: buildTextContent("Không còn bài viết nào khác", true,
                      fontSize: 20, isCenterLeft: false),
                ))
    ]);
  }

  Widget buildReelsBody(BuildContext context) {
    final userMediaController = ref.read(userMediaControllerProvider.notifier);

    if (userMediaController.state.momentUser.isEmpty) {
      userMediaController.getUserMoment(
          id, {"media_type": "video", "post_type": "moment", "limit": 10});
    }

    final userMoment = ref.watch(userMediaControllerProvider).momentUser;
    final size = MediaQuery.sizeOf(context);
    final theme = pv.Provider.of<ThemeManager>(context);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerBase(
                object: userData,
                objectMore: userAbout,
                type: 'user',
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35,
                      width: size.width - 85,
                      child: userType == 'me'
                          ? ButtonPrimary(
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
                                    builder: (context) => CreateModalBaseMenu(
                                      title: "Chỉnh sửa trang cá nhân",
                                      body: UserPageEditProfile(
                                          onUpdate: onReset),
                                      buttonAppbar: const SizedBox(),
                                    ),
                                  ),
                                );
                              },
                            )
                          : userType == 'friend'
                              ? SizedBox(
                                  width: size.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: ButtonPrimary(
                                          icon: const Icon(
                                            FontAwesomeIcons.userCheck,
                                            size: 16,
                                            color: white,
                                          ),
                                          label: "Bạn bè",
                                          handlePress: () {
                                            showBarModalBottomSheet(
                                              context: context,
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              builder: (context) {
                                                return Container(
                                                  color: Colors.transparent,
                                                  width: size.width,
                                                  height: size.height * 0.125,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Flexible(
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (following
                                                                .value) {
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                content: Text(
                                                                    'Đã bỏ theo dõi'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ));
                                                              following.value =
                                                                  false;
                                                              FriendsApi()
                                                                  .unfollow(id);
                                                              return;
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                content: Text(
                                                                    'Đã theo dõi lại'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ));
                                                              following.value =
                                                                  true;
                                                              FriendsApi()
                                                                  .follow(id);
                                                              return;
                                                            }
                                                          },
                                                          child: SizedBox(
                                                            width: size.width,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .squareXmark,
                                                                  size: 20.0,
                                                                  color: theme.isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        15.0),
                                                                Text(
                                                                  following
                                                                          .value
                                                                      ? "Bỏ theo dõi"
                                                                      : "Theo dõi lại",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: theme.isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: InkWell(
                                                          onTap: () {
                                                            showCupertinoDialog(
                                                              context: context,
                                                              builder:
                                                                  ((context) {
                                                                return CupertinoAlertDialog(
                                                                  content:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                    child: Text(
                                                                      "Bạn có chắc chắn muốn xóa ${userData?['display_name']} khỏi danh sách bạn bè không?",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14.0),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      isDefaultAction:
                                                                          true,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'Hủy'),
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                      isDestructiveAction:
                                                                          true,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Đã hủy kết bạn'),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        ));
                                                                        setState(
                                                                            () {
                                                                          userType =
                                                                              'stranger';
                                                                        });

                                                                        FriendsApi()
                                                                            .unfriend(id);
                                                                      },
                                                                      child: const Text(
                                                                          'Xóa'),
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                            );
                                                          },
                                                          child: SizedBox(
                                                            width: size.width,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .userXmark,
                                                                  size: 20.0,
                                                                  color: theme.isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        15.0),
                                                                Text(
                                                                  "Hủy kết bạn",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: theme.isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 7.5),
                                      _buildSendMessage(),
                                    ],
                                  ),
                                )
                              : userType == 'requested'
                                  ? SizedBox(
                                      width: size.width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: ButtonPrimary(
                                              icon: const Icon(
                                                FontAwesomeIcons.userPlus,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              label: "Hủy lời mời",
                                              handlePress: () {
                                                setState(() {
                                                  userType = 'stranger';
                                                });

                                                FriendsApi()
                                                    .cancelFriendRequestApi(id);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 7.5),
                                          _buildSendMessage(),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      width: size.width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: ButtonPrimary(
                                              icon: const Icon(
                                                FontAwesomeIcons.userPlus,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                              colorButton: Colors.grey[300],
                                              colorText: Colors.black,
                                              label: "Kết bạn",
                                              handlePress: () {
                                                setState(() {
                                                  userType = 'requested';
                                                });
                                                FriendsApi()
                                                    .sendFriendRequestApi(id);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 7.5),
                                          _buildSendMessage(),
                                        ],
                                      ),
                                    ),
                    ),
                    SizedBox(
                      height: 35,
                      width: 48,
                      child: ButtonPrimary(
                        icon: const Icon(
                          FontAwesomeIcons.ellipsis,
                          size: 16,
                          color: Colors.white,
                        ),
                        handlePress: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: CrossBar(),
        ),
        SliverToBoxAdapter(child: headerTab()),
        const SliverToBoxAdapter(
          child: CrossBar(),
        ),
        SliverToBoxAdapter(
          child: RenderPhoto(
            photoData: userMoment,
            hasTitle: false,
          ),
        ),
      ],
    );
  }

  Widget buildImageBody(BuildContext context) {
    setState(() {
      showHeaderTabFixed = false;
    });
    final userMediaController = ref.read(userMediaControllerProvider.notifier);
    if (userMediaController.state.photoUser.isEmpty &&
        userMediaController.state.albumUser.isEmpty &&
        userMediaController.state.videoUser.isEmpty) {
      Future.delayed(Duration.zero, () async {
        userMediaController
            .getUserPhoto(id, {"media_type": "image", "limit": 10});
        userMediaController
            .getUserVideo(id, {"media_type": "video", "limit": 10});
        userMediaController.getUserAlbum(id, {"limit": 10});
      });
    }
    final userPhoto = ref.watch(userMediaControllerProvider).photoUser;
    final userVideo = ref.watch(userMediaControllerProvider).videoUser;
    final userAlbum = ref.watch(userMediaControllerProvider).albumUser;

    final size = MediaQuery.sizeOf(context);
    final theme = pv.Provider.of<ThemeManager>(context);

    return CustomScrollView(
      controller: scrollController,
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BannerBase(
                object: userData,
                objectMore: userAbout,
                type: 'user',
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 35,
                      width: size.width - 85,
                      child: userType == 'me'
                          ? ButtonPrimary(
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
                                    builder: (context) => CreateModalBaseMenu(
                                      title: "Chỉnh sửa trang cá nhân",
                                      body: UserPageEditProfile(
                                          onUpdate: onReset),
                                      buttonAppbar: const SizedBox(),
                                    ),
                                  ),
                                );
                              },
                            )
                          : userType == 'friend'
                              ? SizedBox(
                                  width: size.width * 0.8,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Flexible(
                                        child: ButtonPrimary(
                                          icon: const Icon(
                                            FontAwesomeIcons.userCheck,
                                            size: 16,
                                            color: white,
                                          ),
                                          label: "Bạn bè",
                                          handlePress: () {
                                            showBarModalBottomSheet(
                                              context: context,
                                              backgroundColor: Theme.of(context)
                                                  .scaffoldBackgroundColor,
                                              builder: (context) {
                                                return Container(
                                                  color: Colors.transparent,
                                                  width: size.width,
                                                  height: size.height * 0.125,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 10.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Flexible(
                                                        child: InkWell(
                                                          onTap: () {
                                                            if (following
                                                                .value) {
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                content: Text(
                                                                    'Đã bỏ theo dõi'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ));
                                                              following.value =
                                                                  false;
                                                              FriendsApi()
                                                                  .unfollow(id);
                                                              return;
                                                            } else {
                                                              Navigator.pop(
                                                                  context);
                                                              ScaffoldMessenger
                                                                      .of(
                                                                          context)
                                                                  .showSnackBar(
                                                                      const SnackBar(
                                                                content: Text(
                                                                    'Đã theo dõi lại'),
                                                                duration:
                                                                    Duration(
                                                                        seconds:
                                                                            2),
                                                              ));
                                                              following.value =
                                                                  true;
                                                              FriendsApi()
                                                                  .follow(id);
                                                              return;
                                                            }
                                                          },
                                                          child: SizedBox(
                                                            width: size.width,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .squareXmark,
                                                                  size: 20.0,
                                                                  color: theme.isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        15.0),
                                                                Text(
                                                                  following
                                                                          .value
                                                                      ? "Bỏ theo dõi"
                                                                      : "Theo dõi lại",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: theme.isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Flexible(
                                                        child: InkWell(
                                                          onTap: () {
                                                            showCupertinoDialog(
                                                              context: context,
                                                              builder:
                                                                  ((context) {
                                                                return CupertinoAlertDialog(
                                                                  content:
                                                                      Container(
                                                                    margin: const EdgeInsets
                                                                            .only(
                                                                        top:
                                                                            8.0),
                                                                    child: Text(
                                                                      "Bạn có chắc chắn muốn xóa ${userData?['display_name']} khỏi danh sách bạn bè không?",
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              14.0),
                                                                    ),
                                                                  ),
                                                                  actions: [
                                                                    CupertinoDialogAction(
                                                                      isDefaultAction:
                                                                          true,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child: const Text(
                                                                          'Hủy'),
                                                                    ),
                                                                    CupertinoDialogAction(
                                                                      isDestructiveAction:
                                                                          true,
                                                                      onPressed:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                        Navigator.pop(
                                                                            context);
                                                                        ScaffoldMessenger.of(context)
                                                                            .showSnackBar(const SnackBar(
                                                                          content:
                                                                              Text('Đã hủy kết bạn'),
                                                                          duration:
                                                                              Duration(seconds: 2),
                                                                        ));
                                                                        setState(
                                                                            () {
                                                                          userType =
                                                                              'stranger';
                                                                        });

                                                                        FriendsApi()
                                                                            .unfriend(id);
                                                                      },
                                                                      child: const Text(
                                                                          'Xóa'),
                                                                    ),
                                                                  ],
                                                                );
                                                              }),
                                                            );
                                                          },
                                                          child: SizedBox(
                                                            width: size.width,
                                                            child: Row(
                                                              children: [
                                                                Icon(
                                                                  FontAwesomeIcons
                                                                      .userXmark,
                                                                  size: 20.0,
                                                                  color: theme.isDarkMode
                                                                      ? Colors
                                                                          .white
                                                                      : Colors
                                                                          .black,
                                                                ),
                                                                const SizedBox(
                                                                    width:
                                                                        15.0),
                                                                Text(
                                                                  "Hủy kết bạn",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        15.0,
                                                                    color: theme.isDarkMode
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 7.5),
                                      _buildSendMessage(),
                                    ],
                                  ),
                                )
                              : userType == 'requested'
                                  ? SizedBox(
                                      width: size.width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: ButtonPrimary(
                                              icon: const Icon(
                                                FontAwesomeIcons.userPlus,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                              label: "Hủy lời mời",
                                              handlePress: () {
                                                setState(() {
                                                  userType = 'stranger';
                                                });

                                                FriendsApi()
                                                    .cancelFriendRequestApi(id);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 7.5),
                                          _buildSendMessage(),
                                        ],
                                      ),
                                    )
                                  : SizedBox(
                                      width: size.width * 0.8,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Flexible(
                                            child: ButtonPrimary(
                                              icon: const Icon(
                                                FontAwesomeIcons.userPlus,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                              colorButton: Colors.grey[300],
                                              colorText: Colors.black,
                                              label: "Kết bạn",
                                              handlePress: () {
                                                setState(() {
                                                  userType = 'requested';
                                                });
                                                FriendsApi()
                                                    .sendFriendRequestApi(id);
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: 7.5),
                                          _buildSendMessage(),
                                        ],
                                      ),
                                    ),
                    ),
                    SizedBox(
                      height: 35,
                      width: 48,
                      child: ButtonPrimary(
                        icon: const Icon(
                          FontAwesomeIcons.ellipsis,
                          size: 16,
                          color: Colors.white,
                        ),
                        handlePress: () {},
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SliverToBoxAdapter(
          child: CrossBar(),
        ),
        SliverToBoxAdapter(child: headerTab()),
        const SliverToBoxAdapter(
          child: CrossBar(),
        ),
        SliverToBoxAdapter(
          child: TabBar(
            controller: _tabController,
            indicatorColor: secondaryColor,
            dividerColor: secondaryColor,
            labelColor: Theme.of(context).textTheme.bodyLarge?.color,
            tabs: List.generate(
              userImageMenu.length,
              (index) => Text(
                userImageMenu[index]['label'],
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SizedBox(
              height: size.height * 0.9, // Đặt chiều cao cố định cho TabBarView
              child: TabBarView(
                controller: _tabController,
                children: [
                  RenderPhoto(
                    photoData: userPhoto,
                    hasTitle: false,
                  ),
                  RenderPhoto(
                    photoData: userAlbum,
                    hasTitle: true,
                    type: 'buttonAlbum',
                  ),
                  RenderPhoto(
                    photoData: userVideo,
                    hasTitle: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget headerTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                userMenu.length,
                (index) => InkWell(
                      onTap: () {
                        setState(() {
                          menuSelected = userMenu[index]['key'];
                        });
                      },
                      child: ChipMenu(
                          isSelected: menuSelected == userMenu[index]['key'],
                          label: userMenu[index]['label']),
                    )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    pinPost = ref.read(postControllerProvider).postsPin;

    return Scaffold(
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            if (menuSelected == "user_posts")
              RefreshIndicator(
                onRefresh: () async {
                  await ref
                      .read(postControllerProvider.notifier)
                      .getListPostUserPage(
                          id == ref.watch(meControllerProvider)[0]['id'],
                          id,
                          {"exclude_replies": true, "limit": 20});
                },
                child: buildUserPageBody(context),
              )
            else if (menuSelected == "user_reels")
              Container(
                child: buildReelsBody(context),
              )
            else
              Container(child: buildImageBody(context)),
            if (showHeaderTabFixed)
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor),
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, child: headerTab()),
              )
            else
              const SizedBox(),
          ],
        ));
  }
}
