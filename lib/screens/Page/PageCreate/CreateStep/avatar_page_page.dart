import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../apis/media_api.dart';
import '../../../../apis/page_api.dart' as custom;
import '../../../../constant/page_constants.dart';
import '../../../../widgets/GeneralWidget/bottom_navigator_button_chip.dart';
import '../../../../widgets/back_icon_appbar.dart';
import 'invite_friend_page.dart';

class AvatarPage extends StatefulWidget {
  final dynamic dataCreate;

  const AvatarPage({super.key, this.dataCreate});
  @override
  State<AvatarPage> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  late double width = 0;
  late double height = 0;
  List<int> radioGroupWorkTime = [0, 1, 2];
  dynamic dataAvatar;
  dynamic dataBgAvatar;
  bool isLoading = false;
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
          leading: const BackIconAppbar(),
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: GestureDetector(
          onTap: (() {
            FocusManager.instance.primaryFocus!.unfocus();
          }),
          child: Column(children: [
            SizedBox(
              height: height * 0.78055,
              child: ListView(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
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
                                fontSize: 16)),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
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
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  height: 170,
                                  width: width,
                                  decoration: BoxDecoration(
                                      color: Colors.grey[800],
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10))),
                                  child: _pickedBgImage != null
                                      ? Image.file(
                                          _pickedBgImage!,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Container()),
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 15, 30),
                                height: 200,
                                // color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        getBgImage(ImageSource.gallery);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 80, top: 80),
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(width: 2),
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
                      SizedBox(
                        height: 210,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Center(
                              child: Stack(children: [
                                SizedBox(
                                  height: 120,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      _pickedAvatarImage == null
                                          ? CircleAvatar(
                                              maxRadius: 60,
                                              backgroundImage: AssetImage(
                                                  "${PageConstants.PATH_IMG}avatar_img.png"))
                                          : CircleAvatar(
                                              maxRadius: 60,
                                              backgroundImage: FileImage(
                                                  _pickedAvatarImage!))
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    getAvatarImage(ImageSource.gallery);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 80, top: 80),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(width: 2),
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
                  Center(
                    heightFactor: 2,
                    child: Text(
                      widget.dataCreate['title'],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 17),
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
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: buildBottomNavigatorWithButtonAndChipWidget(
                  context: context,
                  width: width,
                  loading: isLoading,
                  newScreen: InviteFriendPage(dataCreate: {
                    ...widget.dataCreate,
                    'avatar_media':
                        _pickedAvatarImage != null && dataAvatar != null
                            ? dataAvatar
                            : null,
                    'banner': _pickedBgImage != null && dataBgAvatar != null
                        ? dataBgAvatar
                        : null,
                  }),
                  title: "Tiếp",
                  isPassCondition: !isLoading ? true : false,
                  currentPage: 4),
            )
          ]),
        ));
  }

  Future<void> getAvatarImage(ImageSource src) async {
    _imageAvatar = (await ImagePicker().pickImage(source: src))!;
    setState(() {
      _pickedAvatarImage = File(_imageAvatar!.path);
    });

    if (_pickedAvatarImage != null) {
      FormData formData = FormData();
      FormData formDataFile = FormData();

      final imageBytes = await _pickedAvatarImage!.readAsBytes();
      MultipartFile imageFile = MultipartFile.fromBytes(
        imageBytes,
        filename: _pickedAvatarImage!.path.split('/').last,
        contentType: MediaType(
          'image',
          _pickedAvatarImage!.path.split('.').last.toLowerCase(),
        ),
      );

      formData.files.add(MapEntry('avatar[file]', imageFile));

      // Convert the image to base64 format
      String base64Image = base64Encode(imageBytes);
      formDataFile = FormData.fromMap({
        "file": await MultipartFile.fromFile(_pickedAvatarImage!.path,
            filename: _pickedAvatarImage!.path.split('/').last),
        "show_url": 'data:image/png;base64,$base64Image'
      });
      formData.fields.add(
          MapEntry('avatar[show_url]', 'data:image/png;base64,$base64Image'));

      try {
        setState(() {
          isLoading = true;
        });
        var value = await MediaApi().uploadMediaEmso(formDataFile);
        if (value != null) {
          setState(() {
            dataAvatar = value;
            isLoading = false;
            formData.fields.add(MapEntry('avatar[id]', dataAvatar['id']));
          });
        }
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
      await custom.PageApi().pagePostMedia(formData, widget.dataCreate['id']);
    }
  }

  Future<void> getBgImage(ImageSource src) async {
    _imageBg = (await ImagePicker().pickImage(source: src))!;
    setState(() {
      _pickedBgImage = File(_imageBg!.path);
    });

    if (_pickedBgImage != null) {
      FormData formData = FormData();
      FormData formDataFile = FormData();

      final imageBytes = await _pickedBgImage!.readAsBytes();
      MultipartFile imageFile = MultipartFile.fromBytes(
        imageBytes,
        filename: _pickedBgImage!.path.split('/').last,
        contentType: MediaType('image', 'png'),
      );

      formData.files.add(MapEntry('banner[file]', imageFile));

      // Convert the image to base64 format
      String base64Image = base64Encode(imageBytes);
      formDataFile = FormData.fromMap({
        "file": await MultipartFile.fromFile(_pickedBgImage!.path,
            filename: _pickedBgImage!.path.split('/').last),
        "show_url": 'data:image/png;base64,$base64Image'
      });
      formData.fields.add(
          MapEntry('banner[show_url]', 'data:image/png;base64,$base64Image'));

      try {
        setState(() {
          isLoading = true;
        });
        await MediaApi().uploadMediaEmso(formDataFile).then((value) {
          if (value != null) {
            setState(() {
              dataBgAvatar = value;
              isLoading = false;
            });
          }
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
      await custom.PageApi().pagePostMedia(formData, widget.dataCreate['id']);
    }
  }
}
