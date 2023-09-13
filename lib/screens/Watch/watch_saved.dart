import 'package:flutter/material.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/data/watch.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';

class WatchSaved extends StatefulWidget {
  const WatchSaved({Key? key}) : super(key: key);

  @override
  State<WatchSaved> createState() => _WatchSavedState();
}

class _WatchSavedState extends State<WatchSaved>
    with AutomaticKeepAliveClientMixin {
  late List listWatchSaved;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    listWatchSaved = [];
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.sizeOf(context);
    return listWatchSaved.isNotEmpty
        ? Container(
            color: Theme.of(context).canvasColor,
            height: size.height - 120,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: List.generate(
                  listWatchSaved.length,
                  (index) {
                    var watch = listWatchSaved[index];
                    var media = watch?['media_attachments'].isEmpty
                        ? {}
                        : (watch?['media_attachments']?[0]);
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          media.isEmpty
                              ? Container(
                                  width: 86,
                                  height: 86,
                                  decoration: BoxDecoration(
                                      color: greyColor,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: const Icon(
                                    Icons.play_circle_outline,
                                    color: white,
                                  ),
                                )
                              : Stack(children: [
                                  AvatarSocial(
                                      isGroup: true,
                                      width: 86,
                                      height: 86,
                                      object: {'avatar_media': media},
                                      path: media?['preview_remote_url'] ??
                                          media?['preview_url']),
                                  const Positioned(
                                      top: 28,
                                      left: 28,
                                      child: Icon(
                                        Icons.play_circle_outline,
                                        color: white,
                                        size: 30,
                                      ))
                                ]),
                          const SizedBox(
                            width: 8,
                          ),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: size.width - 135,
                                  child: Text(
                                    media?['description'] ?? "---",
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AvatarSocial(
                                        width: 30,
                                        height: 30,
                                        object: watch?['page'],
                                        path: watch?['page']?['avatar_media'] !=
                                                null
                                            ? (watch?['page']?['avatar_media']
                                                ?['preview_url'])
                                            : linkAvatarDefault),
                                    const SizedBox(width: 7),
                                    SizedBox(
                                      width: size.width - 170,
                                      child: RichText(
                                          text: TextSpan(
                                              text: "được lưu từ bài viết của ",
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .color),
                                              children: <TextSpan>[
                                            TextSpan(
                                                text: watch?['page']?['title'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    overflow:
                                                        TextOverflow.ellipsis))
                                          ])),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: size.width - 135,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: primaryColor),
                                          onPressed: () {},
                                          child: const Text(
                                            "Bỏ lưu",
                                            style: TextStyle(color: white),
                                          ))
                                    ],
                                  ),
                                )
                              ])
                        ],
                      ),
                    );
                  },
                ),
              ),
            ))
        : Center(
            child: buildTextContent("Chưa có video đã lưu nào !!", false,
                isCenterLeft: false));
  }
}
