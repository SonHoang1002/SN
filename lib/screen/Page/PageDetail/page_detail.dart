import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/about_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/box_quick_update_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/feed_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/page_pinned_post.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/photo_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/review_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/video_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widget/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/header_tabs.dart';

class PageDetail extends ConsumerStatefulWidget {
  final pageData;
  const PageDetail({super.key, this.pageData});

  @override
  ConsumerState<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends ConsumerState<PageDetail> {
  dynamic pageData;
  GlobalKey _widgetKey = GlobalKey();
  final scrollController = ScrollController();
  String menuSelected = 'home_page';
  int pageReview = 1;
  double headerTabToTop = 0;
  bool showHeaderTabFixed = false;
  String typeMedia = 'image';

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    if (pageData != null) {
      if (mounted) {
        setState(() {
          pageData = widget.pageData;
        });
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final RenderBox renderBox =
          _widgetKey.currentContext?.findRenderObject() as RenderBox;
      if (mounted) {
        setState(() {
          headerTabToTop = renderBox.size.height;
        });
      }
    });

    if (ref.read(pageControllerProvider).pagePined.isEmpty) {
      Future.delayed(
          Duration.zero,
          () => ref
              .read(pageControllerProvider.notifier)
              .getListPagePined(pageData['id']));
    }

    scrollController.addListener(() {
      if (scrollController.offset >= headerTabToTop &&
          showHeaderTabFixed == false) {
        if (mounted) {
          setState(() {
            showHeaderTabFixed = true;
          });
        }
      } else if (scrollController.offset < headerTabToTop &&
          showHeaderTabFixed == true) {
        if (mounted) {
          setState(() {
            showHeaderTabFixed = false;
          });
        }
      }
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        switch (menuSelected) {
          case 'home_page':
            Map<String, dynamic> paramsFeedPage = {
              "limit": 5,
              "exclude_replies": true,
              'page_id': pageData['id'],
              'page_owner_id': pageData['id']
            };
            if (ref.read(pageControllerProvider).pageFeed.isNotEmpty &&
                ref.read(pageControllerProvider).isMoreFeed) {
              String maxId =
                  ref.read(pageControllerProvider).pageFeed.last['score'];
              ref.read(pageControllerProvider.notifier).getListPageFeed(
                  {"max_id": maxId, ...paramsFeedPage}, pageData['id']);
            }
            break;
          case 'review_page':
            if (ref.read(pageControllerProvider).pageReview.isNotEmpty &&
                ref.read(pageControllerProvider).isMoreReview) {
              ref
                  .read(pageControllerProvider.notifier)
                  .getListPageReview({'page': '$pageReview'}, pageData['id']);
              setState(() {
                pageReview =
                    ref.read(pageControllerProvider).pageReview.length ~/ 20 +
                        1;
              });
            }
            break;
          case 'photo_page':
            if (ref.read(pageControllerProvider).pagePhoto.isNotEmpty &&
                ref.read(pageControllerProvider).isMorePhoto &&
                typeMedia == 'image') {
              String maxId =
                  ref.read(pageControllerProvider).pagePhoto.last['id'];

              ref.read(pageControllerProvider.notifier).getListPageMedia(
                  {"max_id": maxId, "limit": 20, 'media_type': 'image'},
                  pageData['id']);
            } else if (ref.read(pageControllerProvider).pageAlbum.isNotEmpty &&
                ref.read(pageControllerProvider).isMoreAlbum &&
                typeMedia == 'album') {
              String maxId =
                  ref.read(pageControllerProvider).pageAlbum.last['id'];
              ref.read(pageControllerProvider.notifier).getListPageAlbum(
                  {"max_id": maxId, "limit": 20}, pageData['id']);
            }
            break;
          case 'video_page':
            if (ref.read(pageControllerProvider).pageVideo.isNotEmpty &&
                ref.read(pageControllerProvider).isMoreVideo) {
              String maxId =
                  ref.read(pageControllerProvider).pageVideo.last['id'];
              ref.read(pageControllerProvider.notifier).getListPageMedia(
                  {'media_type': 'video', 'limit': 10, "max_id": maxId},
                  pageData['id']);
            }
            break;
          default:
        }
      }
    });
  }

  Widget renderTab() {
    switch (menuSelected) {
      case 'home_page':
        return Column(
          children: [
            AboutPage(
                aboutPage: pageData,
                isQuickShow: true,
                changeMenuSelected: () {
                  if (mounted) {
                    setState(() {
                      menuSelected = 'about_page';
                    });
                  }
                }),
            const SizedBox(height: 8),
            const PagePinPost(),
            FeedPage(pageData),
          ],
        );
      case 'review_page':
        return ReviewPage(pageData);
      case 'about_page':
        return AboutPage(aboutPage: pageData);
      case 'photo_page':
        return PhotoPage(
            handleTypeMedia: (value) {
              if (mounted) {
                setState(() {
                  typeMedia = value;
                });
              }
            },
            pageData: pageData,
            typeMedia: typeMedia);
      case 'video_page':
        return VideoPage(pageData: pageData);
      default:
        return const SizedBox();
    }
  }

  Widget getBody(size, modeTheme) {
    return SingleChildScrollView(
        controller: scrollController,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            key: _widgetKey,
            children: [
              BannerBase(object: pageData, objectMore: null),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonPrimary(
                      icon: const Icon(
                        FontAwesomeIcons.pen,
                        size: 16,
                        color: white,
                      ),
                      label: "Nhắn tin",
                      handlePress: () {},
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                    ),
                    ButtonPrimary(
                      icon: const Icon(
                        FontAwesomeIcons.pen,
                        size: 16,
                        color: white,
                      ),
                      colorButton:
                          modeTheme == 'dark' ? greyColor.shade800 : greyColor,
                      label: "Thích",
                      handlePress: () {},
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                    ),
                    ButtonPrimary(
                      label: "···",
                      handlePress: () {},
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                child: Divider(
                  thickness: 1,
                ),
              ),
              const BoxQuickUpdatePage(),
              const CrossBar(
                height: 5,
                margin: 10,
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                headerTab(),
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                    child: Divider(thickness: 1))
              ],
            ),
          ),
          renderTab()
        ]));
  }

  Widget headerTab() {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: HeaderTabs(
            chooseTab: (tab) {
              if (tab == 'photo_page') {
                if (mounted) {
                  setState(() {
                    typeMedia == 'image';
                  });
                }
              } else if (tab == 'video_page') {
                if (mounted) {
                  setState(() {
                    typeMedia == 'video';
                  });
                }
              }
              if (mounted) {
                setState(() {
                  menuSelected = tab;
                });
              }
            },
            listTabs: pageMenu,
            tabCurrent: menuSelected));
  }

  void showModalSwitchRole(context, listSwitch, rolePage) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (context) => Container(
              height: 300,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
              child: Column(children: [
                const Text('Chọn cách tương tác',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                const Text(
                    'Đăng bài, bình luận và bày tỏ cảm xúc dưới tên trang cá nhân hoặc Trang của bạn.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13)),
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Divider(height: 2),
                ),
                Column(
                  children: List.generate(
                      listSwitch.length,
                      (index) => InkWell(
                            onTap: () {
                              if (index == 0) {
                                ref
                                    .read(pageControllerProvider.notifier)
                                    .switchToRolePage(false);
                                Navigator.of(context).pop();
                              } else {
                                ref
                                    .read(pageControllerProvider.notifier)
                                    .switchToRolePage(true);
                                Navigator.of(context).pop();
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      AvatarSocial(
                                          width: 36,
                                          height: 36,
                                          path: listSwitch[index]
                                                      ['avatar_media']
                                                  ?['show_url'] ??
                                              listSwitch[index]['avatar_media']
                                                  ?['preview_url'] ??
                                              listSwitch[index]['avatar_media']
                                                  ?['url'] ??
                                              linkAvatarDefault),
                                      const SizedBox(
                                        width: 7,
                                      ),
                                      Text(
                                        listSwitch[index]?['display_name'] ??
                                            listSwitch[index]['title'],
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 5, right: 8),
                                    child: Icon(
                                      (rolePage && index == 1) ||
                                              (!rolePage && index == 0)
                                          ? FontAwesomeIcons.circleDot
                                          : FontAwesomeIcons.circle,
                                      size: 16,
                                      color: secondaryColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                )
              ]),
            ));
  }

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context)?.settings.arguments != null) {
      setState(() {
        pageData = ModalRoute.of(context)?.settings.arguments;
      });
    }
    final theme = pv.Provider.of<ThemeManager>(context);
    var meData = ref.watch(meControllerProvider);
    var rolePage = ref.watch(pageControllerProvider).rolePage;
    List listSwitch = [meData[0], pageData];

    String modeTheme = theme.themeMode == ThemeMode.dark
        ? 'dark'
        : theme.themeMode == ThemeMode.light
            ? 'light'
            : 'system';
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            )),
        title: InkWell(
          onTap: () {
            if (pageData['page_relationship']['role'] == 'admin') {
              showModalSwitchRole(context, listSwitch, rolePage);
            }
          },
          child: Wrap(children: [
            Text(rolePage ? pageData['title'] : meData[0]['display_name'],
                style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 15)),
            if (pageData['page_relationship']['role'] == 'admin')
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Icon(
                  FontAwesomeIcons.angleDown,
                  size: 18,
                ),
              )
          ]),
        ),
        centerTitle: true,
        actions: [
          SizedBox(
            width: 38,
            height: 38,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                modeTheme == 'dark' ? 'assets/ChatDM.svg' : 'assets/chat.svg',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(11.0),
            child: Icon(
              Icons.search,
              size: 22,
              color: Theme.of(context).textTheme.displayLarge!.color,
            ),
          )
        ],
      ),
      body: Stack(children: [
        getBody(size, modeTheme),
        if (showHeaderTabFixed)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            decoration:
                BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
            child: SingleChildScrollView(
                scrollDirection: Axis.horizontal, child: headerTab()),
          ),
      ]),
    );
  }
}