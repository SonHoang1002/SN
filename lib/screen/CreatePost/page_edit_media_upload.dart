import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/feed_video.dart';
import 'package:social_network_app_mobile/widget/FeedVideo/flick_multiple_manager.dart';
import 'package:social_network_app_mobile/widget/PickImageVideo/src/gallery/gallery_view.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/text_form_field_custom.dart';
import 'package:transparent_image/transparent_image.dart';

class PageEditMediaUpload extends StatefulWidget {
  final List files;
  final Function handleUpdateData;

  const PageEditMediaUpload(
      {Key? key, required this.files, required this.handleUpdateData})
      : super(key: key);

  @override
  State<PageEditMediaUpload> createState() => _PageEditMediaUploadState();
}

class _PageEditMediaUploadState extends State<PageEditMediaUpload> {
  late FlickMultiManager flickMultiManager;
  List filesRender = [];

  @override
  void initState() {
    super.initState();

    if (widget.files.isNotEmpty) {
      setState(() {
        filesRender = widget.files;
      });
    }

    flickMultiManager = FlickMultiManager();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    checkIsImage(media) {
      return media['type'] == 'image' ? true : false;
    }

    renderMedia(index, file) {
      return Column(
        children: [
          if (checkIsImage(file))
            ClipRect(
                child: Align(
              alignment: Alignment.topCenter,
              heightFactor:
                  (file['aspect'] ?? file['meta']['original']['aspect']) < 0.4
                      ? 0.6
                      : 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: file['subType'] == 'local'
                    ? Image.file(
                        file['file'],
                        fit: BoxFit.cover,
                      )
                    : FadeInImage.memoryNetwork(
                        placeholder: kTransparentImage,
                        image: file['url'],
                        imageErrorBuilder: (context, error, stackTrace) =>
                            const SizedBox(),
                      ),
              ),
            ))
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
                      'update_file_description', filesRender);
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
                : Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filesRender.length,
                        itemBuilder: (context, index) => Stack(
                              children: [
                                renderMedia(index, filesRender[index]),
                                Positioned(
                                    right: 15,
                                    top: 15,
                                    child: GestureDetector(
                                      onTap: () {
                                        List filesUpdate = [
                                          ...filesRender.sublist(0, index),
                                          ...filesRender.sublist(index + 1)
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
                                                BorderRadius.circular(5),
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                        child: const Icon(
                                          FontAwesomeIcons.xmark,
                                          color: white,
                                          size: 20,
                                        ),
                                      ),
                                    ))
                              ],
                            ))),
            Container(
                margin: const EdgeInsets.all(8.0),
                child: ButtonPrimary(
                    icon: const Icon(
                      FontAwesomeIcons.camera,
                      size: 20,
                      color: white,
                    ),
                    label: "Thêm mới",
                    handlePress: () {
                      Navigator.push(
                          context,
                          CupertinoPageRoute(
                              builder: (context) => Expanded(
                                      child: GalleryView(
                                    typePage: 'page_edit',
                                    filesSelected: filesRender,
                                    isMutipleFile: true,
                                    handleGetFiles: (type, data) {
                                      List listPath = [];
                                      List newFiles = [];

                                      for (var item in [
                                        ...filesRender,
                                        ...data
                                      ]) {
                                        if (!listPath
                                            .contains(item['file'].path)) {
                                          newFiles.add(item);
                                          listPath.add(item['file'].path);
                                        }
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
