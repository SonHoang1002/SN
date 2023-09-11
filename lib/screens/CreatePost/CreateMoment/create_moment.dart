import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/screens/CreatePost/MenuBody/friend_tag.dart';
import 'package:social_network_app_mobile/screens/CreatePost/create_modal_base_menu.dart';
import 'package:social_network_app_mobile/screens/Moment/moment.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/page_visibility.dart';

class CreateMoment extends ConsumerStatefulWidget {
  final File imageCover;
  final String videoPath;
  const CreateMoment(
      {Key? key, required this.imageCover, required this.videoPath})
      : super(key: key);

  @override
  _CreateMomentState createState() => _CreateMomentState();
}

class _CreateMomentState extends ConsumerState<CreateMoment> {
  dynamic data = {
    "media_ids": [],
    "post_type": "moment",
    "sensitive": false,
    "status": "",
    "visibility": "friend",
    "mention_ids": [],
  };
  List friendsPrePage = [];

  void handleClickAction(key) {
    Widget pageNext = FriendTag(
        handleUpdateData: (key, dataTag) {
          setState(() {
            friendsPrePage = dataTag;
            data = {
              ...data,
              "mention_ids": dataTag?.map((element) => element['id']).toList()
            };
          });
        },
        friendsPrePage: friendsPrePage);
    Widget buttonAppBar = SizedBox(
      height: 40,
      child: ButtonPrimary(
        label: "Xong",
        handlePress: () {
          Navigator.pop(context);
        },
      ),
    );
    if (key == 'visibility') {
      buttonAppBar = const SizedBox();
      pageNext = PageVisibility(
          visibility: typeVisibility
              .firstWhere((element) => element['key'] == data['visibility']),
          handleUpdate: (visibilitySelected) {
            setState(() {
              data = {...data, 'visibility': visibilitySelected['key']};
            });
          });
    }

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) => CreateModalBaseMenu(
                title:
                    key == 'friend_tag' ? 'Gắn thẻ bạn bè' : 'Quyền riêng tư',
                body: pageNext,
                buttonAppbar: buttonAppBar)));
  }

  handleSubmit() {
    Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
            builder: (context) => Moment(
                    imageUpload: widget.imageCover,
                    dataUploadMoment: {
                      ...data,
                      "videoPath": widget.videoPath,
                      "imageCover": widget.imageCover
                    }
                    // dataAdditional: response,
                    )),
        ((route) => route.isFirst));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    const optionAction = [
      {
        "key": "friend_tag",
        "label": "Gắn thẻ mọi người",
        "icon": FontAwesomeIcons.user
      },
      {
        "key": "visibility",
        "label": "Ai có thể xem bài viết này",
        "icon": FontAwesomeIcons.earthAsia
      }
    ];

    TextStyle styleTextSpan = TextStyle(
        color: Theme.of(context).textTheme.bodyLarge!.color,
        fontWeight: FontWeight.w600,
        fontSize: 15);

    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CupertinoActivityIndicator(),
      ),
      child: GestureDetector(
        onTap: () {
          hiddenKeyboard(context);
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const BackIconAppbar(),
                const AppBarTitle(title: "Đăng"),
                Container()
              ],
            ),
            bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: CrossBar(
                  height: 0.3,
                )),
          ),
          body: Container(
            margin:
                const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 150,
                      width: size.width - 130,
                      child: TextField(
                        maxLines: 9,
                        maxLength: 150,
                        cursorColor:
                            Theme.of(context).textTheme.displayLarge?.color,
                        onChanged: (value) {
                          setState(() {
                            data = {...data, "status": value};
                          });
                        },
                        decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(0),
                            hintText:
                                "Bạn muốn chia sẻ điều gì? Hãy nhập không quá 150 kí tự.",
                            hintStyle:
                                TextStyle(color: greyColor, fontSize: 15),
                            isDense: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Hero(
                          tag: widget.imageCover,
                          child: Image.file(
                            widget.imageCover,
                            height: 150,
                            width: 100,
                            fit: BoxFit.cover,
                          )),
                    )
                  ],
                ),
                const CrossBar(
                  height: 0.3,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: optionAction.length,
                      itemBuilder: (context, index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(5.0),
                                onTap: () => handleClickAction(
                                    optionAction[index]['key']),
                                child: Container(
                                  padding: const EdgeInsets.all(4.0),
                                  margin: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            optionAction[index]['icon']
                                                as IconData,
                                            color: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .color,
                                            size: 18,
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            optionAction[index]['label']
                                                as String,
                                            style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          )
                                        ],
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: greyColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              if (optionAction[index]['key'] == 'visibility')
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  margin: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Bài viết hiển thị ở chế độ: ',
                                        style:
                                            const TextStyle(color: greyColor),
                                        children: [
                                          TextSpan(
                                              text: typeVisibility.firstWhere(
                                                          (element) =>
                                                              element['key'] ==
                                                              data[
                                                                  'visibility'])[
                                                      'label'] ??
                                                  '',
                                              style: styleTextSpan)
                                        ]),
                                  ),
                                ),
                              if (optionAction[index]['key'] == 'friend_tag' &&
                                  friendsPrePage.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(4.0),
                                  margin: const EdgeInsets.all(8.0),
                                  child: RichText(
                                    text: TextSpan(
                                        text: 'Cùng với ',
                                        children: [
                                          friendsPrePage.isNotEmpty
                                              ? TextSpan(
                                                  text: friendsPrePage[0]
                                                      ['display_name'],
                                                  style: styleTextSpan)
                                              : const TextSpan(),
                                          friendsPrePage.isNotEmpty &&
                                                  friendsPrePage.length >= 2
                                              ? const TextSpan(
                                                  text: ' và ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal))
                                              : const TextSpan(),
                                          friendsPrePage.isNotEmpty &&
                                                  friendsPrePage.length == 2
                                              ? TextSpan(
                                                  text: friendsPrePage[1]
                                                      ['display_name'],
                                                  style: styleTextSpan)
                                              : const TextSpan(),
                                        ],
                                        style:
                                            const TextStyle(color: greyColor)),
                                  ),
                                ),
                            ],
                          )),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 48,
                        width: 130,
                        child: ButtonPrimary(
                          label: 'Lưu nháp',
                          isGrey: true,
                          handlePress: () {},
                          icon: const Icon(
                            FontAwesomeIcons.folder,
                            size: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20.0,
                      ),
                      SizedBox(
                        height: 48,
                        width: 130,
                        child: ButtonPrimary(
                          label: 'Đăng bài',
                          handlePress: data['status']?.trim().isNotEmpty
                              ? () {
                                  handleSubmit();
                                }
                              : null,
                          icon: const Icon(
                            FontAwesomeIcons.arrowUpFromBracket,
                            size: 18,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
