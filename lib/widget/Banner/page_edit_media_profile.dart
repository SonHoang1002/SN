import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:social_network_app_mobile/apis/user_page_api.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/providers/me_provider.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/Banner/page_pick_frames.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/avatar_social.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/cross_bar.dart';
import 'package:social_network_app_mobile/widget/image_cache.dart';

class PageEditMediaProfile extends ConsumerStatefulWidget {
  final String typePage;
  final dynamic entityObj;
  final dynamic file;
  final String entityType;

  const PageEditMediaProfile(
      {Key? key,
      required this.typePage,
      this.entityObj,
      this.file,
      required this.entityType})
      : super(key: key);

  @override
  ConsumerState<PageEditMediaProfile> createState() =>
      _PageEditMediaProfileState();
}

class _PageEditMediaProfileState extends ConsumerState<PageEditMediaProfile> {
  dynamic avatar;
  dynamic header;
  bool isClick = false;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    handleUpdateMediaProfile() async {
      String fileName = '';
      final base64String;
      var fileData =
          widget.typePage == 'avatar' ? avatar['file'] : header['file'];

      if (fileData != null) {
        fileName = fileData?.path?.split('/')?.last;
        final bytes = await fileData.readAsBytes();
        base64String = base64.encode(bytes);
      }

      FormData formData = FormData.fromMap({
        (widget.typePage == 'avatar' ? 'avatar' : 'header'): {
          "id": widget.typePage == 'avatar' ? avatar['id'] : header['id'],
          "status": avatar?['status'],
          "frame_id": avatar?['frame_id'],
          "file": fileData != null
              ? await MultipartFile.fromFile(fileData.path, filename: fileName)
              : null,
          // "show_url": base64String
        }
      });
      var response = await UserPageCredentical().updateCredentialUser(formData);

      if (response != null) {
        setState(() {
          isClick = false;
        });
        ref.read(meControllerProvider.notifier).updateMedata(response);
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }

    handleUpdateData(type, data) {
      if (mounted) {
        avatar = widget.typePage == 'avatar'
            ? {...(avatar ?? {}), '$type': data}
            : avatar;
        header = widget.typePage != 'avatar'
            ? {...(header ?? {}), '$type': data}
            : header;
      }
    }

    return GestureDetector(
      onTap: () {
        hiddenKeyboard(context);
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BackIconAppbar(),
              AppBarTitle(
                  title: widget.typePage == 'avatar'
                      ? "Xem trước ảnh đại diện"
                      : "Xem trước ảnh bìa"),
              ButtonPrimary(
                label: "Lưu",
                handlePress: isClick
                    ? null
                    : () {
                        setState(() {
                          isClick = true;
                        });
                        handleUpdateMediaProfile();
                      },
              )
            ],
          ),
        ),
        body: widget.typePage == 'avatar'
            ? AvatarWiget(
                controller: controller,
                size: size,
                widget: widget,
                handleUpdateData: handleUpdateData)
            : BannerWidget(
                size: size, widget: widget, handleUpdateData: handleUpdateData),
      ),
    );
  }
}

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    super.key,
    required this.size,
    required this.widget,
    required this.handleUpdateData,
  });

  final Size size;
  final PageEditMediaProfile widget;
  final Function handleUpdateData;

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  void initState() {
    super.initState();
    if (widget.widget.entityType == 'image' && widget.widget.file != null) {
      widget.handleUpdateData('id', widget.widget.file['id']);
    } else if (widget.widget.entityType == 'file' &&
        widget.widget.file != null) {
      widget.handleUpdateData('file', widget.widget.file);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    renderBanner() {
      String path = '';

      if (widget.widget.entityType == 'file') {
        return Image.file(
          widget.widget.file!,
          width: widget.size.width,
          height: 240,
          fit: BoxFit.cover,
        );
      } else if (widget.widget.entityType == 'image') {
        path = widget.widget.file['url'];
      } else {
        path = widget.widget.entityObj['banner']['url'];
      }

      return ImageCacheRender(
        path: path,
        height: 240.0,
        width: widget.size.width,
      );
    }

    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 290),
          child: Stack(
            children: [
              renderBanner(),
              Positioned(
                  top: 120,
                  left: 15,
                  child: Container(
                      width: 172.0,
                      height: 172.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2.0, color: white)),
                      child: Stack(
                        children: [
                          AvatarSocial(
                              width: 170.0,
                              height: 170.0,
                              object: widget.widget.entityObj,
                              path: widget.widget.entityObj['avatar_media']
                                  ['url']),
                        ],
                      ))),
            ],
          ),
        ),
        const SizedBox(
          height: 12.0,
        ),
        const CrossBar(
          height: 1,
        ),
        const SizedBox(
          height: 12.0,
        ),
        SizedBox(
          width: widget.size.width - 50,
          child: ButtonPrimary(
            icon: const Icon(
              FontAwesomeIcons.scissors,
              size: 16,
              color: white,
            ),
            label: "Chỉnh sửa hình ảnh",
            isPrimary: true,
            handlePress: () {},
          ),
        ),
      ],
    );
  }
}

class AvatarWiget extends StatefulWidget {
  const AvatarWiget({
    super.key,
    required this.controller,
    required this.size,
    required this.widget,
    required this.handleUpdateData,
  });

  final TextEditingController controller;
  final Size size;
  final PageEditMediaProfile widget;
  final Function handleUpdateData;

  @override
  State<AvatarWiget> createState() => _AvatarWigetState();
}

class _AvatarWigetState extends State<AvatarWiget> {
  dynamic frameSelected;

  @override
  void initState() {
    super.initState();

    if (widget.widget.entityType == 'frame' && widget.widget.file != null) {
      widget.handleUpdateData('frame_id', widget.widget.file['id']);
      widget.handleUpdateData(
          'id', widget.widget.entityObj['avatar_media']?['id']);

      setState(() {
        frameSelected = widget.widget.file;
      });
    } else if (widget.widget.entityType == 'image' &&
        widget.widget.file != null) {
      widget.handleUpdateData('id', widget.widget.file['id']);
    } else if (widget.widget.entityType == 'file' &&
        widget.widget.file != null) {
      widget.handleUpdateData('file', widget.widget.file);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    renderAvatar() {
      String path = '';

      if (widget.widget.file != null) {
        if (widget.widget.entityType == 'file') {
          return ClipRRect(
            borderRadius: BorderRadius.circular((widget.size.width - 100) / 2),
            child: Image.file(
              widget.widget.file!,
              width: widget.size.width - 100,
              height: widget.size.width - 100,
              fit: BoxFit.cover,
            ),
          );
        } else if (widget.widget.entityType == 'image') {
          path = widget.widget.file['url'] ?? '';
        } else {
          path = widget.widget.entityObj['avatar_media']['preview_url'];
        }
      }

      return AvatarSocial(
          width: widget.size.width - 100,
          height: widget.size.width - 100,
          path: path);
    }

    return Container(
      margin: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Text(
                        "Chế độ hiển thị: ",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(
                        width: 8.0,
                      ),
                      Icon(
                        FontAwesomeIcons.earthAsia,
                        size: 16,
                      ),
                      SizedBox(
                        width: 4.0,
                      ),
                      Text("Công khai", style: TextStyle(fontSize: 14))
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  const Text(
                    "Ảnh đại diện của bạn sẽ được hiển thị công khai trên bảng tin của bạn bè và trên trang cá nhân của bạn. Việc này giúp bạn bè của bạn trên Emso có thể tìm thấy bạn.",
                    style: TextStyle(fontSize: 14, color: greyColor),
                  )
                ],
              ),
            ),
            const CrossBar(
              height: 1,
            ),
            TextFormField(
              autofocus: true,
              onChanged: (value) {
                widget.handleUpdateData('status', value);
              },
              maxLines: null,
              controller: widget.controller,
              decoration: const InputDecoration(
                hintText: "Nói gì đấy về ảnh đại diện này...",
                hintStyle: TextStyle(fontSize: 14),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Stack(
              children: [
                renderAvatar(),
                frameSelected != null
                    ? ClipRRect(
                        borderRadius:
                            BorderRadius.circular(widget.size.width / 2 - 50),
                        child: ImageCacheRender(
                          path: frameSelected['url'],
                          width: widget.size.width - 100,
                          height: widget.size.width - 100,
                        ),
                      )
                    : const SizedBox()
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            const CrossBar(
              height: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonPrimary(
                  icon: const Icon(
                    FontAwesomeIcons.scissors,
                    size: 16,
                    color: white,
                  ),
                  label: "Chỉnh sửa",
                  isPrimary: true,
                  handlePress: () {},
                ),
                const SizedBox(
                  width: 12.0,
                ),
                ButtonPrimary(
                  icon: const Icon(
                    FontAwesomeIcons.box,
                    size: 16,
                    color: white,
                  ),
                  label: "Thêm khung",
                  isPrimary: true,
                  handlePress: () {
                    showBarModalBottomSheet(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (context) =>
                            PagePickFrames(handleAction: (type, frame) {
                              setState(() {
                                frameSelected = frame;
                              });
                              widget.handleUpdateData('frame_id', frame['id']);
                            }));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}