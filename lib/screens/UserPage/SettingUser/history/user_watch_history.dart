import 'package:provider/provider.dart' as pv;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/constant/post_type.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_watch_history_provider.dart';
import 'package:social_network_app_mobile/screens/Post/post_detail.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/skeleton.dart';
import 'package:social_network_app_mobile/widgets/text_description.dart';

class UserWatchHistory extends ConsumerStatefulWidget {
  const UserWatchHistory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UserWatchHistoryState();
}

class _UserWatchHistoryState extends ConsumerState<UserWatchHistory> {
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
              .addWatchListPage(page);
        }
      }
    });
    //getData();
  }

  Future<void> fetchData() async {
    await ref
        .read(userHistoryControllerProvider.notifier)
        .getWatchListPage(page);

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
          title: const AppBarTitle(title: 'Lịch sử xem bài viết'),
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
                              return listWatched[i]["status"]
                                              ["media_attachments"]
                                          .length !=
                                      0
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                titleDate(listWatched[i]
                                                            ["created_at"]) !=
                                                        ""
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
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
                                                ListItem(data: listWatched[i]),
                                              ],
                                            ),
                                          ),
                                          Divider(
                                            height: 1,
                                            color: greyColor,
                                          )
                                        ],
                                      ),
                                    )
                                  : Container();
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
      onTap: () {
        pushCustomCupertinoPageRoute(
            context,
            PostDetail(
              postId: data['status']['id'],
              preType: postDetail,
            ));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              AvatarSocial(
                  width: 40,
                  height: 40,
                  object: data,
                  path: data["status"]["media_attachments"].length == 0
                      ? linkAvatarDefault
                      : data["status"]["media_attachments"][0]["preview_url"]),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: size.width - 180,
                      child: RichText(
                        text: TextSpan(
                            text: data['account']['display_name'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: theme.isDarkMode ? white : blackColor,
                                overflow: TextOverflow.ellipsis),
                            children: [
                              TextSpan(
                                text: " đã xem một ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color:
                                        theme.isDarkMode ? white : blackColor),
                              ),
                              TextSpan(
                                text: "video",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color:
                                        theme.isDarkMode ? white : blackColor),
                              )
                            ]),
                      )),
                  const SizedBox(
                    height: 4.0,
                  ),
                  SizedBox(
                    width: size.width - 180,
                    child: TextDescription(
                      description: formatTime(data["created_at"]),
                      maxLinesDescription: 1,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
              onTap: () async {
                var res = await UserPageApi().removeWatchHistory(data["id"]);
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
