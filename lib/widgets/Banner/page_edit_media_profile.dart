import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_network_app_mobile/constant/common.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/Banner/page_pick_frames.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/avatar_social.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/cross_bar.dart';
import 'package:social_network_app_mobile/widgets/image_cache.dart';

import '../../apis/page_api.dart' as page;
import '../../providers/page/page_provider.dart';
import '../EditImage/edit_img_main.dart';

class PageEditMediaProfile extends ConsumerStatefulWidget {
  final String typePage;
  final dynamic entityObj;
  final dynamic file;
  final String entityType;
  final String? type;
  final Function? handleChangeDependencies;

  const PageEditMediaProfile(
      {Key? key,
      required this.typePage,
      this.entityObj,
      this.file,
      this.type,
      this.handleChangeDependencies,
      required this.entityType})
      : super(key: key);

  @override
  ConsumerState<PageEditMediaProfile> createState() =>
      _PageEditMediaProfileState();
}

class _PageEditMediaProfileState extends ConsumerState<PageEditMediaProfile> {
  dynamic avatar;
  dynamic banner;
  bool isClick = false;

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    handleUpdateMediaProfile() async {
      String fileName = '';
      final String base64String;
      var fileData =
          widget.typePage == 'avatar' ? avatar['file'] : banner['file'];

      if (fileData != null) {
        fileName = fileData?.path?.split('/')?.last;
        final bytes = await fileData.readAsBytes();
        base64String = base64.encode(bytes);
      }
      FormData formData = FormData.fromMap({
        (widget.typePage == 'avatar' ? 'avatar' : 'banner'): {
          "id": widget.typePage == 'avatar' ? avatar['id'] : banner['id'],
          "status": avatar?['status'],
          "frame_id": avatar?['frame_id'],
          "file": fileData != null
              ? await MultipartFile.fromFile(fileData.path, filename: fileName)
              : null,
          // "show_url": 'data:image/png;base64,$base64String'
        }
      });

      var response = widget.type == 'page'
          ? await page.PageApi().pagePostMedia(formData, widget.entityObj['id'])
          : null;
      if (response != null) {
        setState(() {
          isClick = false;

          widget.handleChangeDependencies!(response);

          ref.read(pageControllerProvider.notifier).updateMedata(response);
        });

        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      }
    }

    handleUpdateData(type, data) {
      if (mounted) {
        avatar = widget.typePage == 'avatar'
            ? {...(avatar ?? {}), '$type': data}
            : avatar;
        banner = widget.typePage != 'avatar'
            ? {...(banner ?? {}), '$type': data}
            : banner;
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
  File? currentFile;

  @override
  void initState() {
    super.initState();
    if (widget.widget.entityType == 'image' && widget.widget.file != null) {
      widget.handleUpdateData('id', widget.widget.file['id']);
    } else if (widget.widget.entityType == 'file' &&
        widget.widget.file != null) {
      widget.handleUpdateData('file', widget.widget.file);
    }
    currentFile = widget.widget.file!;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<String> generateNewFilePath(String fileName) async {
    String cacheDirectory = '';
    Directory? tempDir = await getTemporaryDirectory();
    cacheDirectory = tempDir.path;
    String uniqueFileName = UniqueKey().toString();
    String extension = fileName.split('.').last;
    return '$cacheDirectory/$uniqueFileName.$extension';
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    File file = File(fileName);
    file.writeAsBytesSync(data, mode: FileMode.write);
    return file;
  }

  @override
  Widget build(BuildContext context) {
    renderBanner() {
      String path = '';
      if (widget.widget.entityType == 'file') {
        return Image.file(
          currentFile!,
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
                  top: 115,
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
                              path: widget.widget.entityObj['avatar_media'] !=
                                      null
                                  ? widget.widget.entityObj['avatar_media']
                                      ['url']
                                  : linkAvatarDefault),
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
            handlePress: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return EditImageMain(
                  imageData: {
                    'file': currentFile!,
                    'type': 'local',
                  },
                  updateData: (_, value) async {
                    String newFilePath =
                        await generateNewFilePath(value['file'].path);
                    setState(() {
                      currentFile = uint8ListToFile(
                          value['newUint8ListFile'], newFilePath);
                      widget.handleUpdateData('file', currentFile);
                    });
                  },
                );
              }));
            },
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
  File? currentFile;

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
    currentFile = widget.widget.file!;
  }

  Future<String> generateNewFilePath(String fileName) async {
    String cacheDirectory = '';
    Directory? tempDir = await getTemporaryDirectory();
    cacheDirectory = tempDir.path;
    String uniqueFileName = UniqueKey().toString();
    String extension = fileName.split('.').last;
    return '$cacheDirectory/$uniqueFileName.$extension';
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    File file = File(fileName);
    file.writeAsBytesSync(data, mode: FileMode.write);
    return file;
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
              currentFile!,
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
                  handlePress: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return EditImageMain(
                        imageData: {
                          'file': currentFile!,
                          'type': 'local',
                        },
                        screenshot: false,
                        updateData: (_, value) async {
                          String newFilePath =
                              await generateNewFilePath(value['file'].path);
                          setState(() {
                            currentFile = uint8ListToFile(
                                value['newUint8ListFile'], newFilePath);
                            widget.handleUpdateData('file', currentFile);
                          });
                        },
                      );
                    }));
                  },
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
                        builder: (context) => SingleChildScrollView(
                              padding: EdgeInsets.only(
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom),
                              child:
                                  PagePickFrames(handleAction: (type, frame) {
                                setState(() {
                                  frameSelected = frame;
                                });
                                widget.handleUpdateData(
                                    'frame_id', frame['id']);
                              }),
                            ));
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
