import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    List pageDiscover = ref.watch(pageListControllerProvider).pageSuggestions;
    return SizedBox(
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(pageListControllerProvider.notifier)
              .getListPageSuggest({'limit': 10});
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pageDiscover.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PageDetail(),
                              settings: RouteSettings(
                                  arguments:
                                      pageDiscover[index]['id'].toString()),
                            ));
                      },
                      child: Column(
                        children: [
                          ListTile(
                            leading: FittedBox(
                              child: ClipOval(
                                child: ExtendedImage.network(
                                    pageDiscover[index]['banner'] != null
                                        ? pageDiscover[index]['banner']
                                            ['preview_url']
                                        : linkBannerDefault,
                                    fit: BoxFit.cover,
                                    width: 64,
                                    height: 64),
                              ),
                            ),
                            title: Padding(
                              padding:
                                  const EdgeInsets.only(top: 12.0, bottom: 5.0),
                              child: Text(pageDiscover[index]['title'],
                                  style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${pageDiscover[index]['like_count'].toString()} người thích trang này",
                                  style: const TextStyle(
                                      fontSize: 12, color: greyColor),
                                ),
                                pageDiscover[index]['page_relationship']['like']
                                    ? const Text('Bạn đã thích Trang này.',
                                        style: TextStyle(color: greyColor))
                                    : Row(
                                        children: [
                                          ButtonPrimary(
                                            label: "Thích",
                                            handlePress: () {
                                              ref
                                                  .read(
                                                      pageListControllerProvider
                                                          .notifier)
                                                  .likePageSuggestion(
                                                      pageDiscover[index]['id'],
                                                      'like');
                                            },
                                            icon: const Icon(
                                                FontAwesomeIcons.solidThumbsUp,
                                                size: 16,
                                                color: Colors.white),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          ButtonPrimary(
                                            label: "Gỡ",
                                            colorText: theme.isDarkMode
                                                ? Colors.white
                                                : Colors.black,
                                            colorButton: theme.isDarkMode
                                                ? greyColor.shade800
                                                : greyColor,
                                            handlePress: () {
                                              ref
                                                  .read(
                                                      pageListControllerProvider
                                                          .notifier)
                                                  .likePageSuggestion(
                                                      pageDiscover[index]['id'],
                                                      'filter');
                                            },
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 45),
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
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
