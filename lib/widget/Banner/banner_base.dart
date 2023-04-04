import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Banner/page_edit_media_profile.dart';
import 'package:social_network_app_mobile/widget/Banner/page_pick_frames.dart';
import 'package:social_network_app_mobile/widget/Banner/page_pick_media.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class BannerBase extends StatefulWidget {
  final dynamic object;
  final dynamic objectMore;
  const BannerBase({Key? key, required this.object, this.objectMore})
      : super(key: key);

  @override
  State<BannerBase> createState() => _BannerBaseState();
}

class _BannerBaseState extends State<BannerBase> {
  late File image;

  @override
  Widget build(BuildContext context) {
    String path = widget.object['banner']?['preview_url'] ?? linkBannerDefault;
    String pathAvatar =
        widget.object['avatar_media']?['preview_url'] ?? linkAvatarDefault;
    String title =
        widget.object?['display_name'] ?? widget.object?['title'] ?? '';
    String subTitle =
        widget.objectMore?['general_information']?['other_name'] ?? '';
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 240),
          child: Stack(
            children: [
              ImageCacheRender(
                path: path,
                height: 200.0,
                width: size.width,
              ),
              Positioned(
                  top: 100,
                  left: 15,
                  child: Container(
                      width: 132.0,
                      height: 132.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2.0, color: white)),
                      child: Stack(
                        children: [
                          AvatarSocial(
                            width: 130.0,
                            height: 130.0,
                            path: pathAvatar,
                            object: widget.object,
                          ),
                          Positioned(
                              right: 6,
                              bottom: 6,
                              child: GestureDetector(
                                onTap: () {
                                  showModal(context, 'avatar');
                                },
                                child: const CameraIcon(),
                              ))
                        ],
                      ))),
              Positioned(
                  right: 6,
                  top: 159,
                  child: GestureDetector(
                      onTap: () {
                        showModal(context, 'banner');
                      },
                      child: const CameraIcon())),
            ],
          ),
        ),
        SizedBox(
          width: size.width - 30,
          child: Text(
            '$title ${subTitle != '' ? '($subTitle)' : ''}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  Future<dynamic> showModal(BuildContext context, typePage) {
    List listMenu = [
      {
        "key": "upload",
        "label": "Tải ảnh lên",
        "icon": FontAwesomeIcons.upload,
        "isVisibled": true
      },
      {
        "key": "pick_media",
        "label": "Chọn ảnh trên Emso",
        "icon": FontAwesomeIcons.images,
        "isVisibled": true
      },
      {
        "key": "frames",
        "label": "Thêm khung",
        "icon": FontAwesomeIcons.box,
        "isVisibled": typePage == 'avatar'
      },
    ];

    handleChooseMedia(type, entity) {
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => PageEditMediaProfile(
                  typePage: typePage,
                  entityObj: widget.object,
                  entityType: type,
                  file: entity)));
    }

    void openEditor() async {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });

        // ignore: use_build_context_synchronously
        await Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PageEditMediaProfile(
                    typePage: typePage,
                    entityObj: widget.object,
                    entityType: 'file',
                    file: File(pickedFile.path))));
      }
    }

    handleActionMenu(key) {
      Navigator.pop(context);
      if (key == 'upload') {
        openEditor();
      } else if (key == 'pick_media') {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => PagePickMedia(
                    user: widget.object, handleAction: handleChooseMedia)));
      } else if (key == 'frames') {
        showBarModalBottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            context: context,
            builder: (context) =>
                PagePickFrames(handleAction: handleChooseMedia));
      }
    }

    return showBarModalBottomSheet(
        context: context,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        builder: (context) => Container(
              margin: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: List.generate(
                      listMenu.length,
                      (index) => listMenu[index]['isVisibled']
                          ? InkWell(
                              onTap: () {
                                handleActionMenu(listMenu[index]['key']);
                              },
                              borderRadius: BorderRadius.circular(8.0),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12.0, horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          shape: BoxShape.circle),
                                      child: Icon(
                                        listMenu[index]['icon'],
                                        size: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge!
                                            .color,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      listMenu[index]['label'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox()),
                ),
              ),
            ));
  }
}

class CameraIcon extends StatelessWidget {
  const CameraIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
          color: white,
          shape: BoxShape.circle,
          border: Border.all(width: 1.0, color: Colors.black)),
      child: const Icon(
        FontAwesomeIcons.camera,
        size: 18,
        color: Colors.black,
      ),
    );
  }
}
