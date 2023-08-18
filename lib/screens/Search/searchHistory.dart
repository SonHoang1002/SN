import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/providers/search/search_provider.dart';
import 'package:social_network_app_mobile/screens/Search/search_result_page_detail.dart';
import 'package:social_network_app_mobile/screens/UserPage/user_page.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';
import 'package:social_network_app_mobile/widgets/text_action.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

import '../../constant/common.dart';
import '../../widgets/avatar_social.dart';
import '../Group/GroupDetail/group_detail.dart';
import '../Page/PageDetail/page_detail.dart';

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
                              InkWell(
                                onTap: () {
                                  searchHistory[index]['entity_type'] ==
                                          'Account'
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => const UserPageHome(),
                                            settings: RouteSettings(
                                              arguments: {
                                                'id': searchHistory[index]
                                                    ['entity_id'],
                                                'user': searchHistory[index]
                                              },
                                            ),
                                          ))
                                      : searchHistory[index]['entity_type'] ==
                                              null
                                          ? {
                                              Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                      builder: (context) =>
                                                          SearchResultPageDetail(
                                                              keyword:
                                                                  searchHistory[
                                                                          index]
                                                                      [
                                                                      'keyword']))),
                                              ref
                                                  .read(searchControllerProvider
                                                      .notifier)
                                                  .getSearchDetail({
                                                "q": searchHistory[index]
                                                    ['keyword'],
                                                'offset': 1,
                                                "limit": 5
                                              })
                                            }
                                          : searchHistory[index]
                                                      ['entity_type'] ==
                                                  'Page'
                                              ? Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PageDetail(),
                                                    settings: RouteSettings(
                                                        arguments:
                                                            searchHistory[index]
                                                                    [
                                                                    'entity_id']),
                                                  ))
                                              : searchHistory[index]
                                                          ['entity_type'] ==
                                                      'Group'
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            GroupDetail(
                                                          id: searchHistory[
                                                                  index]
                                                              ['entity_id'],
                                                        ),
                                                        settings: RouteSettings(
                                                            arguments: searchHistory[
                                                                        index][
                                                                    'entity_id']
                                                                .toString()),
                                                      ))
                                                  : const SizedBox();
                                },
                                child: Row(
                                  children: [
                                    // SvgPicture.asset(
                                    //   'assets/story.svg',
                                    //   width: 35,
                                    //   height: 35,
                                    // ),
                                     searchHistory[index]['entity_type'] ==
                                                'Account'
                                            ? AvatarSocial(
                                                width: 34.0,
                                                height: 35.0,
                                                object: searchHistory[index],
                                                path: searchHistory[index]
                                                    ['image_url']??
                                    linkAvatarDefault,
                                              )
                                            : Container(
                                                width: 34,
                                                height: 34,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    border: Border.all(
                                                        width: 0.3,
                                                        color: greyColor)),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: ImageCacheRender(
                                                    path: searchHistory[index]
                                                        ['image_url']??
                                    linkAvatarDefault,
                                                    width: 34.0,
                                                    height: 34.0,
                                                  ),
                                                ),
                                              ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.55,
                                          child: Text(
                                            searchHistory[index]['keyword'],
                                            style:
                                                const TextStyle(fontSize: 13),
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
                                                description: searchHistory[
                                                                index]
                                                            ['entity_type'] ==
                                                        'Account'
                                                    ? 'Tài khoản cá nhân'
                                                    : searchHistory[index][
                                                                'entity_type'] ==
                                                            'Page'
                                                        ? 'Trang'
                                                        : searchHistory[index][
                                                                    'entity_type'] ==
                                                                'Group'
                                                            ? 'Nhóm'
                                                            : searchHistory[
                                                                    index]
                                                                ['entity_type'])
                                            : const SizedBox()
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
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
