import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_app_mobile/constant/group_constants.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'dart:io';
import 'package:social_network_app_mobile/screen/Group/GroupCreateModules/screen/detail_group_page.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/build_stage_navigation_bar.dart';
import 'package:social_network_app_mobile/widget/appbar_title.dart';
import 'package:social_network_app_mobile/widget/back_icon_appbar.dart';

import '../../../../theme/colors.dart';

class CoverImageGroupPage extends StatefulWidget {
  @override
  State<CoverImageGroupPage> createState() => _CoverImageGroupPageState();
}

class _CoverImageGroupPageState extends State<CoverImageGroupPage> {
  late double width = 0;
  late double height = 0;
  List<int> radioGroupWorkTime = [0, 1, 2];

  int currentValue = 0;

  File? _pickedCoverImage;
  XFile? _imageCover;
  late String imgPath = "";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              SizedBox(),
              AppBarTitle(title: GroupConstants.CONTINUE_AFTER),
            ],
          ),
        ),
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                // color: Colors.black87,
                child: Column(
                  children: [
                    // title
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Text(
                                CoverImageGroupConstants.TITLE[0],
                                style: const TextStyle(
                                    // color:  white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Text(CoverImageGroupConstants.SUBTITLE[0],
                                  style: const TextStyle(
                                      // color:  white,
                                      fontSize: 18)),
                            ],
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Text(
                                CoverImageGroupConstants.TITLE[1],
                                style: const TextStyle(
                                    // color:  white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    // img
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Stack(
                        children: [
                          Container(
                            height: 200,
                            width: width,
                            decoration: BoxDecoration(
                                color: Colors.grey[800]!.withOpacity(0.8),
                                border: Border.all(
                                    // color:  white,
                                    ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: _pickedCoverImage != null
                                ? Image.file(
                                    _pickedCoverImage!,
                                    fit: BoxFit.fitWidth,
                                  )
                                : imgPath != ""
                                    ? Image.asset(
                                        imgPath,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Container(),
                          ),
                          SizedBox(
                            height: 200,
                            child: imgPath == "" && _pickedCoverImage == null
                                ? Center(
                                    child: GestureDetector(
                                    onTap: (() {
                                      dialogImgSource();
                                    }),
                                    child: Container(
                                        width: 130,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.6),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Row(
                                          children: [
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                                height: 10,
                                                width: 10,
                                                // padding: EdgeInsets.all(),
                                                child: SvgPicture.asset(
                                                  "${GroupConstants.PATH_ICON}add_img_file_icon.svg",
                                                  color: white,
                                                )),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              CoverImageGroupConstants
                                                  .PLACEHOLDER_LIST[0],
                                              style: const TextStyle(
                                                color: white,
                                                fontSize: 13,
                                              ),
                                            )
                                          ],
                                        )),
                                  ))
                                : Container(
                                    // width: 130,
                                    height: 200,
                                    color: transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                          onTap: (() {
                                            dialogImgSource();
                                          }),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5))),
                                            margin: const EdgeInsets.only(
                                                bottom: 10, right: 10),
                                            padding: const EdgeInsets.all(10),
                                            child: Row(children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    right: 10),
                                                child: const Icon(
                                                  FontAwesomeIcons.pen,
                                                  color: white,
                                                  size: 14,
                                                ),
                                              ),
                                              const Text(
                                                "Chỉnh sửa",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 15),
                                              )
                                            ]),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                    //space
                    const SizedBox(
                      height: 15,
                    ),
                    // example
                    Container(
                      height: (width * 0.9 - 4 * 8) / 5,
                      // width: width,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: 5,
                        itemBuilder: ((context, index) {
                          return Container(
                            width: (width * 0.9 - 4 * 9) / 5,
                            decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            margin: EdgeInsets.fromLTRB(
                                index == 0 ? 0 : 5, 0, index == 4 ? 0 : 5, 0),
                            child: GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _pickedCoverImage = null;
                                  imgPath = CoverImageGroupConstants
                                      .IMG_PATH_LIST[index];
                                });
                              }),
                              child: Image.asset(
                                CoverImageGroupConstants.IMG_PATH_LIST[index],
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // bottom
            buildStageNavigatorBar(
                width: width,
                currentPage: 1,
                isPassCondition: true,
                title: GroupConstants.NEXT,
                function: () {
                  pushToNextScreen(context, const DetailGroupPage());
                })
          ]),
        ));
  }

  Future getCoverImage(ImageSource src) async {
    _imageCover = (await ImagePicker().pickImage(source: src))!;
    setState(() {
      _pickedCoverImage = File(_imageCover!.path);
    });
  }

  dialogImgSource() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Camera"),
                    onTap: () {
                      getCoverImage(ImageSource.camera);
                      Navigator.of(context).pop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera),
                    title: const Text("Pick From Galery"),
                    onTap: () {
                      Navigator.of(context).pop();
                      getCoverImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
