import 'package:provider/provider.dart' as pv;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_watch_history_provider.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class UserSearchHistory extends ConsumerStatefulWidget {
  const UserSearchHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserSearchHistoryState();
}

class _UserSearchHistoryState extends ConsumerState<UserSearchHistory> {
  final scrollController = ScrollController();
  bool _isLoading = true;
  int page = 1;
  String dateSection = "";
  @override
  void initState() {
    super.initState();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        page += 1;
        if (ref.read(userHistoryControllerProvider).history.isNotEmpty) {
          ref
              .read(userHistoryControllerProvider.notifier)
              .addSearchHistoryList({
            "page": page,
            "perpage": 15,
          });
        }
      }
    });
  }

  Future<void> fetchData() async {
    await ref
        .read(userHistoryControllerProvider.notifier)
        .getSearchHistoryList({"page": page, "perpage": 15});

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  String formatCustomDate(String dateTimeString) {
    final monthsInVietnamese = [
      'Tháng 01',
      'Tháng 02',
      'Tháng 03',
      'Tháng 04',
      'Tháng 05',
      'Tháng 06',
      'Tháng 07',
      'Tháng 08',
      'Tháng 09',
      'Tháng 10',
      'Tháng 11',
      'Tháng 12'
    ];

    DateTime dateTime = DateTime.parse(dateTimeString);
    String formattedDate =
        "${dateTime.day} ${monthsInVietnamese[dateTime.month - 1]}, ${dateTime.year}";
    return formattedDate;
  }

  String titleDate(data) {
    if (dateSection != formatCustomDate(data)) {
      dateSection = formatCustomDate(data);
      return dateSection;
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    List listWatched = ref.watch(userHistoryControllerProvider).history;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: const AppBarTitle(title: 'Lịch sử tìm kiếm'),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              FontAwesomeIcons.angleLeft,
              size: 18,
              color: Theme.of(context).textTheme.titleLarge?.color,
            ),
          ),
          shape:
              const Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                _isLoading
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 10,
                        itemBuilder: (context, i) {
                          return Center(
                            child: SkeletonCustom().postSkeletonInList(context),
                          );
                        })
                    : listWatched.isNotEmpty
                        ? ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: listWatched.length,
                            itemBuilder: (context, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              titleDate(listWatched[i]
                                                          ["updated_at"]) !=
                                                      ""
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 10.0),
                                                      child: Text(
                                                        dateSection,
                                                        style: const TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                        ListItem(data: listWatched[i]),
                                      ],
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: greyColor,
                                    )
                                  ],
                                ),
                              );
                            },
                          )
                        : Container()
              ],
            )));
  }
}

class ListItem extends ConsumerWidget {
  final dynamic data;

  const ListItem({
    Key? key,
    this.data,
  }) : super(key: key);

  String formatTime(String dateTimeString) {
    List<String> parts = dateTimeString.split('T')[1].split(':');
    String formattedTime = '${parts[0]}:${parts[1]}';
    return formattedTime;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = pv.Provider.of<ThemeManager>(context);
    final size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AvatarSocial(
                  width: 40,
                  height: 40,
                  object: data,
                  path:
                      ref.read(meControllerProvider)[0]['avatar_media'] == null
                          ? linkAvatarDefault
                          : ref.read(meControllerProvider)[0]['avatar_media']
                              ["preview_url"]),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: size.width - 180,
                      child: Text(
                        "Bạn đã tìm kiếm trên EMSO:",
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: theme.isDarkMode ? white : blackColor,
                            overflow: TextOverflow.ellipsis),
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                      width: size.width - 180,
                      child: Text(
                        '"' + data["keyword"] + '"',
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: theme.isDarkMode ? white : blackColor,
                            overflow: TextOverflow.ellipsis),
                      )),
                  const SizedBox(
                    height: 5.0,
                  ),
                  SizedBox(
                    width: size.width - 180,
                    child: TextDescription(
                      description: formatTime(data["updated_at"]),
                      maxLinesDescription: 1,
                      size: 14,
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
              onTap: () async {
                var res = await UserPageApi().removeSearchHistory(data["id"]);
                if (res != null) {
                  ref
                      .read(userHistoryControllerProvider.notifier)
                      .removeItem(data["id"]);
                }
              },
              child: const Icon(Icons.delete))
        ],
      ),
    );
  }
}
