import 'dart:io';
import 'dart:typed_data';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/EditImage/edit_img_main.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widgets/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widgets/PickImageVideo/src/gallery/gallery_view.dart';
import 'package:social_network_app_mobile/widgets/appbar_title.dart';
import 'package:social_network_app_mobile/widgets/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widgets/button_primary.dart';
import 'package:social_network_app_mobile/widgets/text_form_field_custom.dart';
import 'package:transparent_image/transparent_image.dart';

class PageEditMediaUpload extends StatefulWidget {
  final List files;
  final Function handleUpdateData;
  final dynamic post;

  const PageEditMediaUpload(
      {Key? key,
      required this.files,
      required this.handleUpdateData,
      this.post})
      : super(key: key);

  @override
  State<PageEditMediaUpload> createState() => _PageEditMediaUploadState();
}

class _PageEditMediaUploadState extends State<PageEditMediaUpload> {
  late FlickMultiManager flickMultiManager;
  // data để hiển thị
  List filesRender = [];
  //data để lưu
  // List newFileRender = [];

  @override
  void initState() {
    super.initState();
    if (widget.files.isNotEmpty) {
      setState(() {
        filesRender = widget.files;
        // newFileRender = widget.files;
      });
    }
    flickMultiManager = FlickMultiManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  _updateData(int index, dynamic newData) async {
    if (newData != null) {
      final newImage = await uint8ListToFile(
          newData['newUint8ListFile'], newData['file'].path);

      setState(() {
        filesRender[index] = newData;
        // newFileRender[index]['file'] = newImage;
      });
    }
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    File file = File(fileName);
    file.writeAsBytesSync(data, mode: FileMode.write);
    return file;
  }

  Future<Uint8List> fileToUint8List(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List uint8List = byteData.buffer.asUint8List();
    return uint8List;
  }

  navigatorFunction(int index) {
    widget.post == null
        ? pushToNextScreen(
            context,
            EditImageMain(
                imageData: filesRender,
                index: index,
                updateData: (String type, dynamic newData) async {
                  _updateData(index, newData);
                }))
        : null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    Widget renderMedia(index) {
      final file = filesRender[index];
      return Column(
        children: [
          if (checkIsImage(file))
            GestureDetector(
              onTap: () {
                navigatorFunction(index);
              },
              child: Stack(
                children: [
                  ClipRect(
                      child: Align(
                    alignment: Alignment.topCenter,
                    heightFactor:
                        (file['aspect'] ?? file['meta']['original']['aspect']) <
                                0.4
                            ? 0.6
                            : 1,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: file['subType'] == 'local'
                          ? file['newUint8ListFile'] != null
                              ? Hero(
                                  tag: index,
                                  child: Image.memory(
                                    file['newUint8ListFile'],
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Hero(
                                  tag: index,
                                  child: Image.file(
                                    File(file['file'].path),
                                    fit: BoxFit.cover,
                                  ),
                                )
                          : Hero(
                              tag: file['id'] ?? index,
                              child: ExtendedImage.network(
                                file['url'],
                              ),
                            ),
                      // FadeInImage.memoryNetwork(
                      //     placeholder: kTransparentImage,
                      //     image: file['url'],
                      //     imageErrorBuilder: (context, error, stackTrace) =>
                      //         const SizedBox(),
                      //   ),
                    ),
                  )),
                ],
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: SizedBox(
                height:
                    (file['aspect'] ?? file['meta']['original']['aspect']) < 1
                        ? size.width
                        : null,
                child: FeedVideo(
                    path:
                        file['file']?.path ?? file['remote_url'] ?? file['url'],
                    flickMultiManager: flickMultiManager,
                    image: file['preview_remote_url'] ??
                        file['preview_url'] ??
                        ''),
              ),
            ),
          Container(
            margin: const EdgeInsets.all(8.0),
            child: TextFormFieldCustom(
              autofocus: false,
              hintText: "Mô tả",
              handleGetValue: (value) {
                EasyDebounce.debounce(
                    'my-debouncer', const Duration(milliseconds: 500), () {
                  setState(() {
                    filesRender = [
                      ...filesRender.sublist(0, index),
                      {...file, "description": value},
                      ...filesRender.sublist(index + 1)
                    ];
                  });
                });
              },
            ),
          ),
        ],
      );
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
              const AppBarTitle(title: "Chỉnh sửa"),
              ButtonPrimary(
                label: "Xong",
                handlePress: () {
                  widget.handleUpdateData(
                      // 'update_file_description', newFileRender);
                      'update_file_description',
                      filesRender);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        body: Column(
          children: [
            filesRender.isEmpty
                ? Container(
                    margin: const EdgeInsets.all(15.0),
                    child: const Text("Không có hình ảnh nào để hiển thị"),
                  )
                : Flexible(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filesRender.length,
                        itemBuilder: (context, index) => Stack(
                              children: [
                                renderMedia(index),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      widget.post == null
                                          ? Container(
                                              margin: const EdgeInsets.only(
                                                top: 2,
                                              ),
                                              child: ButtonPrimary(
                                                isPrimary: true,
                                                label: "Chỉnh sửa",
                                                handlePress: () {
                                                  navigatorFunction(index);
                                                },
                                                colorButton: blackColor,
                                                fontSize: 12,
                                                icon: Image.asset(
                                                  "assets/icons/edit_create_feed_icon.png",
                                                  height: 12,
                                                  width: 12,
                                                ),
                                              ))
                                          : const SizedBox(),
                                      Row(
                                        children: [
                                          widget.post == null
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 20),
                                                  child: GestureDetector(
                                                    onTap: () {},
                                                    child: Container(
                                                      width: 28,
                                                      height: 28,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Colors.black
                                                              .withOpacity(
                                                                  0.5)),
                                                      child: const Icon(
                                                        FontAwesomeIcons
                                                            .ellipsis,
                                                        color: white,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ))
                                              : const SizedBox(),
                                          Container(
                                              margin: const EdgeInsets.only(
                                                  right: 15, top: 15),
                                              child: GestureDetector(
                                                onTap: () {
                                                  List filesUpdate = [
                                                    ...filesRender.sublist(
                                                        0, index),
                                                    ...filesRender
                                                        .sublist(index + 1)
                                                  ];
                                                  setState(() {
                                                    filesRender = filesUpdate;
                                                  });
                                                },
                                                child: Container(
                                                  width: 28,
                                                  height: 28,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      color: Colors.black
                                                          .withOpacity(0.5)),
                                                  child: const Icon(
                                                    FontAwesomeIcons.xmark,
                                                    color: white,
                                                    size: 20,
                                                  ),
                                                ),
                                              )),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ))),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: ButtonPrimary(
                    icon: SvgPicture.asset(
                      "assets/icons/add_img_file_icon.svg",
                      height: 20,
                      color: white,
                    ),
                    label: "Thêm mới",
                    handlePress: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Flexible(
                                      child: GalleryView(
                                    typePage: 'page_edit',
                                    filesSelected: filesRender,
                                    isMutipleFile: true,
                                    handleGetFiles: (type, data) {
                                      List listPath = [];
                                      List newFiles = [];
                                      for (var item in data) {
                                        if (!listPath.contains(item?['id'])) {
                                          newFiles.add(item);
                                          listPath.add(item?['id']);
                                        } else if (item['file'] != null) {
                                          if (item['file'].path != null &&
                                              !listPath.contains(
                                                  item['file']!.path)) {
                                            newFiles.add(item);
                                            listPath.add(item['file']!.path);
                                          }
                                        } else {}
                                      }
                                      setState(() {
                                        filesRender = newFiles;
                                      });
                                    },
                                  ))));
                    }))
          ],
        ),
      ),
    );
  }
}
