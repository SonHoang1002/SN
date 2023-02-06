import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../constant/page_constants.dart';
import '../../../../theme/colors.dart';
import '../../../../widget/GeneralWidget/bottom_navigator_with_button_and_chip_widget.dart';
import '../../../../widget/back_icon_appbar.dart';
import 'phone_page_page.dart';

class AvatarPage extends StatefulWidget {
  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  late double width = 0;
  late double height = 0;
  List<int> radioGroupWorkTime = [0, 1, 2];

  int currentValue = 0;

  File? _pickedAvatarImage;
  XFile? _imageAvatar;

  File? _pickedBgImage;
  XFile? _imageBg;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    width = size.width;
    height = size.height;
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
              SizedBox(),
            ],
          ),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(children: [
            Container(
              height: height * 0.78055,
              // color: Colors.black87,
              child: ListView(
                children: [
                  Container(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                AvatarPageConstants.TITLE_AVATAR[0],
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
                          Text(AvatarPageConstants.TITLE_AVATAR[1],
                              style: const TextStyle(
                                  // color:  white,
                                  fontSize: 18)),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Stack(
                    children: [
                      // background img Container
                      Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 170,
                                width: width,
                                decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                child: _pickedBgImage != null
                                    ? Image.file(
                                        _pickedBgImage!,
                                        fit: BoxFit.fitWidth,
                                      )
                                    : Container(),
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 15, 30),
                                height: 200,
                                // color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        dialogImgSource();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 80, top: 80),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              side: BorderSide(width: 2),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: const CircleAvatar(
                                            // backgroundColor: Colors.grey,
                                            child: Icon(
                                              Icons.camera_alt,
                                              // color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      // avatar img background
                      Container(
                        height: 210,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Stack(children: [
                                Container(
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _pickedAvatarImage == null
                                          ? CircleAvatar(
                                              maxRadius: 60,
                                              backgroundImage: AssetImage(
                                                  PageConstants.PATH_IMG +
                                                      "avatar_img.png"))
                                          : CircleAvatar(
                                              maxRadius: 60,
                                              backgroundImage: FileImage(
                                                  _pickedAvatarImage!))
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    dialogImgSource();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 80, top: 80),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(width: 2),
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        child: Icon(Icons.camera_alt,
                                            color: Colors.black, size: 20),
                                      ),
                                    ),
                                  ),
                                )
                              ]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: Text(
                      "NAME OF PAGE",
                      style:
                          TextStyle(color: white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Center(
                      child: ElevatedButton(
                    onPressed: () {},
                    child: Text(AvatarPageConstants.TITLE_AVATAR[2]),
                  ))
                ],
              ),
            ),
            buildBottomNavigatorWithButtonAndChipWidget(
                context: context,
                width: width,
                newScreen: PhonePage(),
                title: "Tiếp",
                isPassCondition: true,
                currentPage: 4)
          ]),
        ));
  }

  // Future getAvatarImage(ImageSource src) async {
  //   _imageAvatar = (await ImagePicker().pickImage(source: src))!;
  //   setState(() {
  //     _pickedAvatarImage = File(_imageAvatar!.path);
  //   });
  // }

  // Future getBgImage(ImageSource src) async {
  //   _imageBg = (await ImagePicker().pickImage(source: src))!;
  //   setState(() {
  //     _pickedBgImage = File(_imageBg!.path);
  //   });
  // }

  dialogImgSource() {
    // showDialog(
    //     context: context,
    //     builder: (_) {
    //       return AlertDialog(
    //         content: SingleChildScrollView(
    //           child: ListBody(
    //             children: [
    //               ListTile(
    //                 leading: const Icon(Icons.camera),
    //                 title: const Text("Pick From Camera"),
    //                 onTap: () {
    //                   getAvatarImage(ImageSource.camera);
    //                   Navigator.of(context).pop();
    //                 },
    //               ),
    //               ListTile(
    //                 leading: const Icon(Icons.camera),
    //                 title: const Text("Pick From Galery"),
    //                 onTap: () {
    //                   Navigator.of(context).pop();
    //                   getAvatarImage(ImageSource.gallery);
    //                 },
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     });
  }
}
