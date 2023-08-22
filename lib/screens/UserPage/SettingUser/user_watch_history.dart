import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/providers/UserPage/user_watch_history_provider.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        page += 1;
        if (ref.read(userWatchControllerProvider).history.isNotEmpty) {
          ref
              .read(userWatchControllerProvider.notifier)
              .getInviteListPage(page);
        }
      }
    });
    //getData();
  }

  Future<void> fetchData() async {
    await ref
        .read(userWatchControllerProvider.notifier)
        .getInviteListPage(page);

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

  @override
  Widget build(BuildContext context) {
    List listWatched = ref.watch(userWatchControllerProvider).history;
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
                                          horizontal: 20, vertical: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(formatCustomDate(
                                              listWatched[i]["created_at"])),
                                          ListItem(data: listWatched[i]),
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
    final size = MediaQuery.sizeOf(context);
    return Row(
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
              child: Text(
                "${data['account']['display_name']} đã xem một video",
                maxLines: 1,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    overflow: TextOverflow.ellipsis),
              ),
            ),
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
            )
          ],
        )
      ],
    );
  }
}
