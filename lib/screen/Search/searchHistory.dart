import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/search/search_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';
import 'package:social_network_app_mobile/widget/text_action.dart';
import 'package:social_network_app_mobile/widget/text_description.dart';

class SearchHistory extends ConsumerWidget {
  final List searchHistory;
  const SearchHistory({Key? key, required this.searchHistory})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        margin: const EdgeInsets.all(8.0),
        child: Column(children: [
          searchHistory.isNotEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Tìm kiếm gần đây',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                    TextAction(
                      title: "Xem tất cả",
                      fontSize: 15,
                      action: () {},
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    "Không có lịch sử tìm kiếm nào",
                    style: TextStyle(fontSize: 13, color: greyColor),
                  ),
                ),
          Column(
              children: List.generate(
                  searchHistory.length,
                  (index) => InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/story.svg',
                                    width: 35,
                                    height: 35,
                                  ),
                                  const SizedBox(
                                    width: 8.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: Text(
                                          searchHistory[index]['keyword'],
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ),
                                      SizedBox(
                                          height: searchHistory[index]
                                                      ['entity_type'] !=
                                                  null
                                              ? 2.0
                                              : 0),
                                      searchHistory[index]['entity_type'] !=
                                              null
                                          ? TextDescription(
                                              description: searchHistory[index]
                                                          ['entity_type'] ==
                                                      'Account'
                                                  ? 'Tài khoản cá nhân'
                                                  : searchHistory[index]
                                                              ['entity_type'] ==
                                                          'Page'
                                                      ? 'Trang'
                                                      : searchHistory[index][
                                                                  'entity_type'] ==
                                                              'Group'
                                                          ? 'Nhóm'
                                                          : searchHistory[index]
                                                              ['entity_type'])
                                          : const SizedBox()
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  searchHistory[index]['image_url'] != null
                                      ? Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                  width: 0.3,
                                                  color: greyColor)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: ImageCacheRender(
                                              path: searchHistory[index]
                                                  ['image_url'],
                                              width: 34.0,
                                              height: 34.0,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(
                                              searchControllerProvider.notifier)
                                          .deleteSearchHistory(
                                              searchHistory[index]['id']);
                                    },
                                    child: const Icon(
                                      FontAwesomeIcons.xmark,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      )))
        ]));
  }
}
