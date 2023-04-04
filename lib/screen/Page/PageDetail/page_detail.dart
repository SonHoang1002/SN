import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/data/list_menu.dart';
import 'package:social_network_app_mobile/providers/page/page_provider.dart';
import 'package:social_network_app_mobile/screen/Feed/create_post_button.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/box_quick_update_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/feed_page.dart';
import 'package:social_network_app_mobile/screen/Page/PageDetail/review_page.dart';
import 'package:social_network_app_mobile/screen/Post/post.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/widget/Banner/banner_base.dart';
import 'package:social_network_app_mobile/widget/box-quick-update.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/header_tabs.dart';
import 'package:social_network_app_mobile/widget/skeleton.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class PageDetail extends ConsumerStatefulWidget {
  final pageData;
  const PageDetail({super.key, this.pageData});

  @override
  ConsumerState<PageDetail> createState() => _PageDetailState();
}

class _PageDetailState extends ConsumerState<PageDetail> {
  final scrollController = ScrollController();
  String menuSelected = 'home_page';
  int pageReview = 1;

  @override
  void initState() {
    if (!mounted) return;
    super.initState();
    Map<String, dynamic> paramsFeedPage = {
      "limit": 5,
      "exclude_replies": true,
      'page_id': widget.pageData['id'],
      'page_owner_id': widget.pageData['id']
    };

    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        switch (menuSelected) {
          case 'home_page':
            if (ref.read(pageControllerProvider).pageFeed.isNotEmpty) {
              String maxId =
                  ref.read(pageControllerProvider).pageFeed.last['score'];
              ref.read(pageControllerProvider.notifier).getListPageFeed(
                  {"max_id": maxId, ...paramsFeedPage}, widget.pageData['id']);
            }
            break;
          case 'review_page':
            if (ref.read(pageControllerProvider).pageReview.isNotEmpty) {
              ref.read(pageControllerProvider.notifier).getListPageReview(
                  {'page': '$pageReview'}, widget.pageData['id']);
              setState(() {
                pageReview = pageReview + 1;
              });
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
        return FeedPage(widget.pageData);
      case 'review_page':
        return ReviewPage(widget.pageData);

      default:
        return SizedBox();
    }
  }

  Widget getBody(size, modeTheme) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BannerBase(object: widget.pageData, objectMore: null),
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            child: Divider(
              thickness: 1,
            ),
          ),
          const BoxQuickUpdatePage(),
          const CrossBar(
            height: 5,
            margin: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: HeaderTabs(
              chooseTab: (tab) {
                if (mounted) {
                  setState(() {
                    menuSelected = tab;
                  });
                }
              },
              listTabs: pageMenu,
              tabCurrent: menuSelected,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            child: Divider(
              thickness: 1,
            ),
          ),
          renderTab()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);

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
          child: const Icon(FontAwesomeIcons.angleLeft, size: 18),
        ),
        title: Text(
          widget.pageData['title'],
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontSize: 15),
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
      body: getBody(size, modeTheme),
    );
  }
}
