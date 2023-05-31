import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_network_app_mobile/data/emoji_activity.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widget/EditImage/crop_image/edit_img_crop.dart';
import 'package:social_network_app_mobile/widget/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';
import 'package:social_network_app_mobile/widget/search_input.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

class EditImageMain extends StatefulWidget {
  dynamic imageData;
  final int? index;
  final Function? updateData;
  EditImageMain({this.imageData, this.index, this.updateData, super.key});

  @override
  State<EditImageMain> createState() => _EditImageMainState();
}
//  {file: File: '/Users/hungnguyen/Library/Developer/CoreSimulator/Devices/9E5F6F30-B1CE-4E1E-A1AD-0235D3EBCF57/data/Containers/Data/Application/B26E10D0-966F-419D-BB2E-E3A81ACC1556/tmp/flutter-images/d9ddb2824e1053b4ed1c8a3633477a07_exif.jpg',
//   aspect: 1.3333333333333333,
//    type: image,
//     subType: local}

class _EditImageMainState extends State<EditImageMain> {
  bool? _musicSelection;
  bool? _tagsSelection;
  bool? _cropSelection;
  bool? _emojiSelection;
  bool? _wordSelection;
  bool? _lineSelection;
  bool? _animationSelection;
  bool? _filterSelection;
  bool? _saveSelection;
  dynamic _imageData;
  File? cropImage;
  Uint8List? _cropImageUnit8List;
  TextEditingController _wordController = TextEditingController(text: '');
  GlobalKey _imageKey = GlobalKey();
  List<ValueNotifier<Matrix4>> notifier = [];
  GlobalKey _globalKey = GlobalKey();
  List<dynamic>? _emojiSelectionItems = [];
  List<Widget> _overlayWidget = [];

  List iconList = [
    {"key": "close", "icon": FontAwesomeIcons.xmark, 'color': white},
    {
      "key": "music",
      "icon": 'assets/icons/edit_music_icon.png',
      'color': white
    },
    {
      "key": "tags",
      "icon": 'assets/icons/edit_friend_tags.png',
      'color': white
    },
    {"key": "crop", "icon": 'assets/icons/edit_crop_icon.png', 'color': white},
    {
      "key": "emoji",
      "icon": 'assets/icons/edit_emoji_icon.png',
      'color': white
    },
    {"key": "word", "icon": 'assets/icons/edit_word_icon.png', 'color': white},
    {"key": "line", "icon": 'assets/icons/edit_line_icon.png', 'color': white},
    {
      "key": "animation",
      "icon": 'assets/icons/edit_animation_icon.png',
      'color': white
    },
    {
      "key": "filter",
      "icon": 'assets/icons/edit_filter_icon.png',
      'color': white
    },
    {"key": "save", "icon": 'assets/icons/edit_save_icon.png', 'color': white},
    {
      "key": "complete",
      "icon": FontAwesomeIcons.paperPlane,
      'color': secondaryColor
    },
  ];

  chooseMenu(dynamic key, {int index = -1}) async {
    switch (key) {
      case "close":
        popToPreviousScreen(context);
        break;
      case "music":
        setState(() {
          _musicSelection = true;
        });
        _showBarMusicSelection();
        break;
      case "tags":
        setState(() {
          _tagsSelection = true;
        });
        break;
      case "crop":
        setState(() {
          _cropSelection = true;
        });
        Uint8List imageBytes =
            await loadImageFromAsset(widget.imageData['file'].path);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditImageCrop(
              image: imageBytes,
              onChange: (value) {},
              completeFunction: (value) async {
                if (value != null) {
                  final newFile =
                      await uint8ListToFile(value, _imageData['file'].path);

                  setState(() {
                    _imageData['file'] = newFile;
                    _cropImageUnit8List = value;
                  });
                }
              },
            ),
          ),
        );
        break;
      case "emoji":
        setState(() {
          _emojiSelection = true;
        });
        _showBarEmojiSelection();
        break;
      case "word":
        if (_wordSelection != true) {
          setState(() {
            _wordSelection = true;
            notifier.add(ValueNotifier(Matrix4.identity()));
          });
          _overlayWidget.add(_buildWordWidget());
        }
        break;
      case "line":
        setState(() {
          _lineSelection = true;
        });
        break;
      case "animation":
        setState(() {
          _animationSelection = true;
        });
        break;
      case "filter":
        setState(() {
          _filterSelection = true;
        });
        break;
      case "save":
        setState(() {
          _saveSelection = true;
        });
        break;
      case "complete":
        final newCapturePng = await _capturePng();
        // final newFile =
        //     await uint8ListToFile(newCapturePng, _imageData['file'].path);

        dynamic newData = {
          "file": _imageData["file"],
          "aspect": _imageData["aspect"],
          "type": "image",
          "subType": "local",
          "newUint8ListFile": newCapturePng
        };

        widget.updateData != null
            ? widget.updateData!(widget.index, newData)
            : null;
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        break;
      default:
        break;
    }
    if (index != -1) {
      resetColorIconMenu();
      setState(() {
        iconList[index]['color'] = secondaryColor;
      });
    }
  }

  Future<Uint8List> _capturePng() async {
    final imageRenderObject = _imageKey.currentContext?.findRenderObject();
    if (imageRenderObject is RenderBox) {
      final imageHeight = imageRenderObject.size.height; 
    }
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      return pngBytes;
    } catch (e) {
      throw (e);
    }
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    File file = File(fileName);
    file.writeAsBytesSync(data, mode: FileMode.write);
    return file;
  }

  resetColorIconMenu() {
    iconList.forEach((element) {
      element['color'] = white;
    });
  }

  Future<Uint8List> loadImageFromAsset(String assetPath) async {
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List uint8List = byteData.buffer.asUint8List();
    return uint8List;
  }

  @override
  void initState() {
    _imageData = widget.imageData;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: blackColor,
      body: SafeArea(
        child: Stack(children: [
          RepaintBoundary(
            key: _globalKey,
            child: Container(
              height: size.height * 0.8,
              margin: EdgeInsets.symmetric(vertical: size.height * 0.1),
              child: Stack(
                children: [
                  Center(
                    key: ValueKey(
                        _cropImageUnit8List != null ? 'true' : 'false'),
                    child: _cropImageUnit8List != null
                        ? Image.memory(
                            _cropImageUnit8List!,
                            key: _imageKey,
                            fit: BoxFit.contain,
                            width: size.width,
                          )
                        : _imageData['file'] != null
                            ? ExtendedImage.file(
                                File(_imageData['file'].path),
                                key: _imageKey,
                                fit: BoxFit.contain,
                                width: size.width,
                                loadStateChanged: (ExtendedImageState state) {
                                  if (state.extendedImageLoadState ==
                                      LoadState.completed) {
                                    // WidgetsBinding.instance
                                    //     .addPostFrameCallback((_) {
                                    //   setState(() {
                                    //     imageHeight = state
                                    //         .extendedImageInfo?.image.height
                                    //         .toDouble();
                                    //   });
                                    // });
                                  }
                                },
                              )
                            : const SizedBox(),
                  ),
                  Stack(
                    children: _overlayWidget.map((e) {
                      final index = _overlayWidget.indexOf(e);
                      return MatrixGestureDetector(
                        onMatrixUpdate: (matrix, translationDeltaMatrix,
                            scaleDeltaMatrix, rotationDeltaMatrix) {
                          setState(() {
                            notifier[index].value = matrix;
                          });
                        },
                        child: AnimatedBuilder(
                            animation: notifier[index],
                            builder: (ctx, child) {
                              return Transform(
                                transform: notifier[index].value,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: e,
                                  ),
                                ),
                              );
                            }),
                      );
                    }).toList(),
                  )
                ],
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: iconList
                        .sublist(0, 7)
                        .map((e) => GestureDetector(
                              onTap: () {
                                chooseMenu(e['key'],
                                    index: iconList.indexOf(e));
                              },
                              child: e['icon'] is! String
                                  ? Icon(
                                      e['icon'],
                                      size: 20,
                                      color: e['color'],
                                    )
                                  : Image.asset(
                                      e['icon'],
                                      height: 20,
                                      width: 20,
                                      color: e['color'],
                                    ),
                            ))
                        .toList()),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: iconList.sublist(7, iconList.length).map((e) {
                      if (e['key'] == "complete") {
                        return GestureDetector(
                          onTap: () {
                            chooseMenu(e['key'], index: iconList.indexOf(e));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(25)),
                            padding: const EdgeInsets.all(15),
                            child: Icon(
                              e['icon'],
                              size: 25,
                              color: secondaryColor,
                            ),
                          ),
                        );
                      }
                      return GestureDetector(
                          onTap: () {
                            chooseMenu(e['key'], index: iconList.indexOf(e));
                          },
                          child: e['icon'] is! String
                              ? Icon(
                                  e['icon'],
                                  size: 20,
                                  color: e['color'],
                                )
                              : Image.asset(
                                  e['icon'],
                                  height: 20,
                                  width: 20,
                                  color: e['color'],
                                ));
                    }).toList()),
              )
            ],
          )
        ]),
      ),
    );
  }

// word
  Widget _buildWordWidget() {
    return _buildTextFormField();
  }

  Widget _buildTextFormField() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        onChanged: (value) {},
        maxLines: null,
        // expands: true,
        controller: _wordController,
        autofocus: true,
        style: const TextStyle(fontSize: 30, color: Colors.white),
        decoration: const InputDecoration(
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 10, top: 10, right: 15),
          border: InputBorder.none,
          hintText: "Bắt đầu nhập",
          hintStyle: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 30),
        ),
      ),
    );
  }

// music
  _showBarMusicSelection() {
    final size = MediaQuery.of(context).size;
    return showBarModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: size.height * 0.9,
            child: Column(
              children: [
                buildSpacer(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 7, left: 7, bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: SearchInput()),
                      buildSpacer(width: 7),
                      Container(
                        width: 40,
                        height: 40,
                        padding: const EdgeInsets.only(left: 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: greyColor.shade300,
                        ),
                        child: const Center(
                          child: Icon(
                            FontAwesomeIcons.save,
                            size: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Flexible(
                    child: ListView.builder(
                        padding: const EdgeInsets.only(top: 20),
                        shrinkWrap: true,
                        itemCount: 200,
                        itemBuilder: ((context, index) {
                          return ListTile(
                            title: Text("Music ${index}"),
                          );
                        })))
              ],
            ),
          );
        });
  }

// emoji
// Widget _buildEmojiWidget(){
//   return
// }
  _showBarEmojiSelection() {
    final size = MediaQuery.of(context).size;
    return showBarModalBottomSheet(
        context: context,
        builder: (ctx) {
          return SizedBox(
            height: size.height * 0.9,
            child: Column(
              children: [
                buildSpacer(height: 10),
                Flexible(
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                crossAxisCount: 6,
                                childAspectRatio: 1.0),
                        padding: const EdgeInsets.only(top: 20),
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: emojis.length,
                        itemBuilder: ((context, index) {
                          final emojiData = emojis[index];
                          return GestureDetector(
                            onTap: () {
                              chooseEmojiItem(index);
                            },
                            child: Container(
                              height: 50,
                              width: 50,
                              child: ExtendedImage.network(
                                emojiData['url'],
                              ),
                            ),
                          );
                        })))
              ],
            ),
          );
        });
  }

  chooseEmojiItem(int index) {
    setState(() {
      _emojiSelectionItems!.add([index]);
      _overlayWidget.add(
          ExtendedImage.network(emojis[index]['url'], height: 50, width: 50));
      notifier.add(ValueNotifier(Matrix4.identity()));
    });
    popToPreviousScreen(context);
  }
}
