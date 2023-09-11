
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/Page/PageCreate/page_create.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';

import '../../providers/page/page_list_provider.dart';
import '../../theme/colors.dart';
import '../../theme/theme_manager.dart';
import 'PageDetail/page_detail.dart';

class PageDiscover extends ConsumerStatefulWidget {
  const PageDiscover({super.key});

  @override
  ConsumerState<PageDiscover> createState() => _PageDiscoverState();
}

class _PageDiscoverState extends ConsumerState<PageDiscover> {
  final scrollController = ScrollController();
  List? pageDiscover;
  @override
  void initState() {
    if (!mounted) return;
    super.initState();

    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        String maxId = ref
            .read(pageListControllerProvider)
            .pageSuggestions
            .last['id']
            .toString();
        ref.read(pageListControllerProvider.notifier).getListPageSuggest({
          "max_id": maxId,
          "limit": 10,
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getApiData() async {
    await ref
        .read(pageListControllerProvider.notifier)
        .getListPageSuggest({'limit': 10});
    pageDiscover = ref.watch(pageListControllerProvider).pageSuggestions;
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    String modeTheme = theme.isDarkMode ? 'dark' : 'light';
    if (ref.watch(pageListControllerProvider).pageSuggestions.isNotEmpty) {
      pageDiscover = ref.watch(pageListControllerProvider).pageSuggestions;
    } else {
      getApiData();
    }
    return SizedBox(
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          children: [
            pageDiscover != null
                ? pageDiscover!.isNotEmpty
                    ? ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: pageDiscover!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () async {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const PageDetail(),
                                    settings: RouteSettings(
                                        arguments: pageDiscover![index]['id']
                                            .toString()),
                                  ));
                            },
                            child: Column(
                              children: [
                                ListTile(
                                  leading: FittedBox(
                                    child: ClipOval(
                                      child: ExtendedImage.network(
                                          (pageDiscover![index]?['avatar_media']
                                                  ?['url']) ??
                                              (pageDiscover![index]?['banner']
                                                  ?['preview_url']) ??
                                              linkBannerDefault,
                                          fit: BoxFit.cover,
                                          width: 64,
                                          height: 64),
                                    ),
                                  ),
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 12.0, bottom: 5.0),
                                    child: Text(pageDiscover![index]['title'],
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${pageDiscover![index]['like_count'].toString()} người thích trang này",
                                        style: const TextStyle(
                                            fontSize: 12, color: greyColor),
                                      ),
                                      pageDiscover![index]['page_relationship']
                                              ['like']
                                          ? const Text(
                                              'Bạn đã thích Trang này.',
                                              style:
                                                  TextStyle(color: greyColor))
                                          : Flex(
                                              direction: Axis.horizontal,
                                              children: [
                                                Flexible(
                                                  child: ButtonPrimary(
                                                    label: "Thích",
                                                    handlePress: () {
                                                      ref
                                                          .read(
                                                              pageListControllerProvider
                                                                  .notifier)
                                                          .likePageSuggestion(
                                                              pageDiscover![
                                                                  index]['id'],
                                                              'like');
                                                    },
                                                    fontSize: 13,
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .solidThumbsUp,
                                                        size: 13,
                                                        color: Colors.white),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 30),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Flexible(
                                                  child: ButtonPrimary(
                                                    label: "Gỡ",
                                                    colorText: theme.isDarkMode
                                                        ? Colors.white
                                                        : Colors.black,
                                                    colorButton:
                                                        theme.isDarkMode
                                                            ? greyColor.shade800
                                                            : greyColorOutlined,
                                                    fontSize: 13,
                                                    handlePress: () {
                                                      ref
                                                          .read(
                                                              pageListControllerProvider
                                                                  .notifier)
                                                          .likePageSuggestion(
                                                              pageDiscover![
                                                                  index]['id'],
                                                              'filter');
                                                    },
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 45),
                                                  ),
                                                )
                                              ],
                                            )
                                    ],
                                  ),
                                ),
                                const Divider(
                                  height: 1,
                                  indent: 90,
                                  endIndent: 25,
                                  thickness: 1,
                                )
                              ],
                            ),
                          );
                        })
                    : Container(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/reaction/wow.gif',
                              width: 80.0,
                              height: 80.0,
                              fit: BoxFit.contain,
                            ),
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 25.0),
                                child: Text(
                                  "Hiện bạn chưa có Trang nào, vui lòng tạo trang",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) =>
                                        const CreateModalBaseMenu(
                                      title: "Tạo",
                                      body: PageCreate(),
                                      buttonAppbar: SizedBox(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: const ButtonPrimary(
                                  label: "Tạo trang ngay",
                                  colorText: Colors.white,
                                  icon: Icon(Icons.add, color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: 10,
                    itemBuilder: (context, index) {
                      return Center(
                        child: SkeletonCustom().postSkeletonDiscovery(context),
                      );
                    })
          ],
        ),
      ),
    );
  }
}
