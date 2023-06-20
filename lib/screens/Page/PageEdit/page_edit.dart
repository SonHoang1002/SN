import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../../constant/common.dart';
import '../../../widgets/Banner/page_edit_media_profile.dart';
import '../../../widgets/Banner/page_pick_frames.dart';
import '../../../widgets/Banner/page_pick_media.dart';
import '../../../widgets/appbar_title.dart';
import '../../../widgets/avatar_social.dart';
import 'edit_detail.dart';

class PageEdit extends StatefulWidget {
  final dynamic data;
  final Function? handleChangeDependencies;
  const PageEdit({super.key, this.data, this.handleChangeDependencies});

  @override
  State<PageEdit> createState() => _PageEditState();
}

class _PageEditState extends State<PageEdit> {
  late File image;
  dynamic dataPage;
  List detailPage = [];
  @override
  void initState() {
    super.initState();
    dataPage = widget.data;
    updateDetailPage();
  }

  void updateDetailPage() {
    setState(() {
      detailPage = [
        {
          "key": "page",
          "label": dataPage?['page_categories'].isNotEmpty
              ? "Trang \u2022 ${dataPage?['page_categories']?[0]?['text']}"
              : "Trang",
          "icon": 'assets/pages/circleWarning.png',
        },
        {
          "key": "andress",
          "label": "${dataPage?['address'] ?? "Địa chỉ"}",
          "icon": 'assets/pages/direction.png',
        },
        {
          "key": "phone",
          "label": "${dataPage?['phone_number'] ?? "Điện thoại"}",
          "icon": 'assets/pages/phone.png',
        },
        {
          "key": "email",
          "label": "${dataPage?['email'] ?? "Email"}",
          "icon": 'assets/pages/email.png',
        }
      ];
    });
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
                  entityObj: widget.data,
                  entityType: type,
                  handleChangeDependencies: (value) {
                    setState(() {
                      dataPage = value;
                    });
                  },
                  type: 'page',
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
                    entityObj: widget.data,
                    entityType: 'file',
                    handleChangeDependencies: (value) {
                      setState(() {
                        dataPage = value;
                      });
                    },
                    type: 'page',
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
                    user: widget.data, handleAction: handleChooseMedia)));
      } else if (key == 'frames') {
        showBarModalBottomSheet(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            context: context,
            builder: (context) => SingleChildScrollView(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: PagePickFrames(handleAction: handleChooseMedia)));
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .background,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Chỉnh sửa trang'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ảnh đại diện'),
                      TextButton(
                          onPressed: () {
                            showModal(context, 'avatar');
                          },
                          child: Text(dataPage['avatar_media'] != null
                              ? 'Chỉnh sửa'
                              : 'Thêm')),
                    ],
                  ),
                  AvatarSocial(
                    width: 120,
                    height: 120,
                    path: dataPage['avatar_media'] != null
                        ? dataPage['avatar_media']['preview_url']
                        : linkAvatarDefault,
                    object: dataPage,
                  ),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Ảnh bìa'),
                      TextButton(
                          onPressed: () {
                            showModal(context, 'banner');
                          },
                          child: Text(dataPage['banner'] != null
                              ? 'Chỉnh sửa'
                              : 'Thêm')),
                    ],
                  ),
                  dataPage['banner'] != null
                      ? ClipRRect(
                          child: ExtendedImage.network(
                            dataPage['banner']['preview_url'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        )
                      : Container(
                          height: 200,
                          color: Colors.black,
                          child: Center(
                            child: Image.asset(
                              'assets/pages/banner.png',
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ),
                  const Divider(
                    height: 30,
                    thickness: 1,
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Chi tiết'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    builder: (context) => EditDetail(
                                          data: dataPage,
                                          handleChangeDependencies: (value) {
                                            setState(() {
                                              dataPage = value;
                                              updateDetailPage();
                                            });
                                          },
                                        )));
                          },
                          child: const Text('Chỉnh sửa')),
                    ],
                  ),
                  ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: detailPage.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          horizontalTitleGap: 0,
                          dense: true,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 0.0),
                          visualDensity:
                              const VisualDensity(horizontal: -4, vertical: -1),
                          leading: Image.asset(
                            detailPage[index]['icon'],
                            width: 20,
                            height: 20,
                          ),
                          title: Text(detailPage[index]['label']),
                        );
                      }),
                  const Divider(
                    height: 20,
                    thickness: 1,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
