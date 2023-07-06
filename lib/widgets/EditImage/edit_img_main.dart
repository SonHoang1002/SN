import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:extended_image/extended_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:perfect_freehand/perfect_freehand.dart';
import 'package:social_network_app_mobile/data/emoji_activity.dart';
import 'package:social_network_app_mobile/helper/common.dart';
import 'package:social_network_app_mobile/helper/push_to_new_screen.dart';
import 'package:social_network_app_mobile/theme/colors.dart';
import 'package:social_network_app_mobile/widgets/EditImage/crop_image/edit_img_crop.dart';
import 'package:social_network_app_mobile/widgets/EditImage/drag_object/matrix_gesture_detector_custom.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/spacer_widget.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_button.dart';
import 'package:social_network_app_mobile/widgets/GeneralWidget/text_content_widget.dart';
import 'package:social_network_app_mobile/widgets/search_input.dart';

import 'draw_image/sketcher.dart';
import 'draw_image/stroke.dart';
import 'draw_image/stroke_options.dart';

class EditImageMain extends StatefulWidget {
  final dynamic imageData;

  final int? index;
  final bool screenshot;
  final Function? updateData;
  const EditImageMain(
      {this.imageData,
      this.index,
      this.updateData,
      this.screenshot = true,
      super.key});

  @override
  State<EditImageMain> createState() => _EditImageMainState();
}

class _EditImageMainState extends State<EditImageMain> {
  List iconList = [
    {
      "key": "close",
      "title": "",
      "icon": FontAwesomeIcons.xmark,
      'color': white
    },
    {
      "key": "music",
      "title": "",
      "icon": 'assets/icons/edit_music_icon.png',
      'color': white
    },
    {
      "key": "tags",
      "title": "",
      "icon": 'assets/icons/edit_friend_tags.png',
      'color': white
    },
    {
      "key": "crop",
      "title": "",
      "icon": 'assets/icons/edit_crop_icon.png',
      'color': white
    },
    {
      "key": "emoji",
      "title": "",
      "icon": 'assets/icons/edit_emoji_icon.png',
      'color': white
    },
    {
      "key": "word",
      "title": "",
      "icon": 'assets/icons/edit_word_icon.png',
      'color': white
    },
    {
      "key": "draw",
      "title": "",
      "icon": 'assets/icons/edit_line_icon.png',
      'color': white
    },
    {
      "key": "animation",
      "title": "Hiệu ứng",
      "icon": 'assets/icons/edit_animation_icon.png',
      'color': white
    },
    {
      "key": "brightness",
      "title": "Độ sáng",
      "icon": 'assets/icons/edit_filter_icon.png',
      'color': white
    },
    {
      "key": "save",
      "title": "Lưu",
      "icon": 'assets/icons/edit_save_icon.png',
      'color': white
    },
    {
      "key": "complete",
      "title": "",
      "icon": FontAwesomeIcons.paperPlane,
      'color': secondaryColor
    },
  ];

  List<Color> drawColorList = [
    Colors.transparent,
    Colors.black,
    Colors.white,
    Colors.red,
    Colors.redAccent,
    Colors.pink,
    Colors.pinkAccent,
    Colors.purple,
    Colors.purpleAccent,
    Colors.deepPurple,
    Colors.deepPurpleAccent,
    Colors.indigo,
    Colors.indigoAccent,
    Colors.blue,
    Colors.blueAccent,
    Colors.lightBlue,
    Colors.lightBlueAccent,
    Colors.cyan,
    Colors.cyanAccent,
    Colors.teal,
    Colors.tealAccent,
    Colors.green,
    Colors.greenAccent,
    Colors.lightGreen,
    Colors.lightGreenAccent,
    Colors.lime,
    Colors.limeAccent,
    Colors.yellow,
    Colors.yellowAccent,
    Colors.amber,
    Colors.amberAccent,
    Colors.orange,
    Colors.orangeAccent,
    Colors.deepOrange,
    Colors.deepOrangeAccent,
    Colors.brown,
    Colors.grey,
    Colors.blueGrey,
  ];

  final List<dynamic> selectionFrameList = [
    null,
    "assets/effect_frame/effect_frame_1.png",
    "assets/effect_frame/effect_frame_2.png",
    "assets/effect_frame/effect_frame_3.png",
    "assets/effect_frame/effect_frame_4.png",
    "assets/effect_frame/effect_frame_5.png",
  ];
  bool? _musicSelection;
  bool? _tagsSelection;
  bool? _cropSelection;
  bool? _emojiSelection;
  bool? _wordSelection;
  bool? _lineSelection;
  bool? _animationSelection;
  bool? _brightnessSelection;
  bool? _saveSelection;
  dynamic _imageData;

  List<dynamic> _overlayWidget = [];
  final GlobalKey _imageKey = GlobalKey();
  final GlobalKey _globalKey = GlobalKey();

  List<ValueNotifier<Matrix4>> notifiers = [];

  bool _isShowDeleteArea = false;
  bool _isCanDeleteObject = false;
  Rect? rect;

  // crop property
  File? cropImage;
  Uint8List? _cropImageUnit8List;
  // word property
  List<dynamic> _dataProperties = [];
  double? fontSizeValue;
  dynamic _selectedOverlayObject;
  // emoji property
  List<dynamic>? _emojiSelectionItems = [];
  // draw property
  List<Stroke> lines = <Stroke>[];
  Stroke? line;
  StrokeOptions options = StrokeOptions();
  StreamController<Stroke> currentLineStreamController =
      StreamController<Stroke>.broadcast();
  StreamController<List<Stroke>> linesStreamController =
      StreamController<List<Stroke>>.broadcast();
  Color _drawSelectionColor = Colors.black;
  // brightness property -  độ sáng của ảnh
  double brightness = 0;
  // animation and frame property
  String? _selectedFrame;
  bool _isOpenAnimationSelections = false;

  chooseMenu(dynamic key, {int index = -1}) async {
    hiddenKeyboard(context);
    resetSelectionMenu();
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
        Uint8List imageBytes = await fileToUint8List(_imageData['file']);
        // ignore: use_build_context_synchronously
        showBarModalBottomSheet(
            enableDrag: false,
            context: context,
            isDismissible: false,
            builder: (ctx) {
              return EditImageCrop(
                image: imageBytes,
                completeFunction: (value) async {
                  if (value != null) {
                    final newFile =
                        uint8ListToFile(value, _imageData['file'].path);
                    setState(() {
                      _imageData['file'] = newFile;
                      _cropImageUnit8List = value;
                    });
                  }
                },
              );
            });
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
            notifiers.add(ValueNotifier(Matrix4.identity()));
            _dataProperties.add({
              "key": "word",
              "controller": TextEditingController(text: ""),
              "color": ValueNotifier<Color>(white),
              "fontSize": ValueNotifier<double>(25.0),
              "focus_node": FocusNode()
            });
            _overlayWidget.add({
              "key": "word",
              "visible": true,
              // "index": _dataProperties.length - 1,
              // "widget": _buildTextFormField(_dataProperties.length - 1)
              "widget": _buildTextFormField(_dataProperties.last)
            });
            _selectedOverlayObject = _dataProperties.last;
          });
        }
        break;
      case "draw":
        setState(() {
          _lineSelection = true;
        });
        break;
      case "animation":
        setState(() {
          _animationSelection = true;
          _isOpenAnimationSelections = !_isOpenAnimationSelections;
          if (index != -1) {
            if (_isOpenAnimationSelections) {
              iconList[index]['icon'] =
                  'assets/icons/edit_animation_down_icon.png';
            } else {
              iconList[index]['icon'] = 'assets/icons/edit_animation_icon.png';
            }
          }
        });
        break;
      case "brightness":
        setState(() {
          _brightnessSelection = true;
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
            ? widget.updateData!("update_file_description", newData)
            : null;
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
        break;
      default:
        break;
    }
  }

  Future<Uint8List> _capturePng() async {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // get height of image
    final imageRenderObject = _imageKey.currentContext?.findRenderObject();
    double imageHeight = 0;
    if (imageRenderObject is RenderBox) {
      imageHeight = imageRenderObject.size.height;
    }
    try {
      // render capture Image and convert to Byte Data
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      int startPixelY = (screenHeight / 2 - imageHeight / 2).toInt();
      // convert byteData to Image( to crop )
      img.Image originalImage =
          img.decodeImage(byteData!.buffer.asUint8List())!;
      img.Image croppedImage = img.copyCrop(originalImage,
          x: 0,
          y: startPixelY - 45, // unexpected height,I don't know why ??
          width: screenWidth.toInt(),
          height: imageHeight.toInt());
      // encode to Uint8List
      Uint8List pngBytes =
          img.encodePng(widget.screenshot ? croppedImage : originalImage);
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    File file = File(fileName);
    file.writeAsBytesSync(data, mode: FileMode.write);
    return file;
  }

  resetSelectionMenu() {
    setState(() {
      _musicSelection = false;
      _tagsSelection = false;
      _cropSelection = false;
      _emojiSelection = false;
      _wordSelection = false;
      _lineSelection = false;
      _animationSelection = false;
      _brightnessSelection = false;
      _saveSelection = false;
    });
  }

  resetColorIconMenu() {
    for (var element in iconList) {
      element['color'] = white;
    }
  }

  Future<Uint8List> fileToUint8List(File file) async {
    Uint8List uint8List = await file.readAsBytes();
    return uint8List;
  }

  // draw function
  Future<void> clear() async {
    setState(() {
      lines = [];
      line = null;
    });
  }

  Future<void> undo() async {
    if (lines.isNotEmpty) {
      setState(() {
        lines = List.from(lines)..removeLast();
        line = null;
      });
    }
  }

  Future<void> updateSizeOption(double size) async {
    setState(() {
      options.size = size;
    });
  }

  void onPointerDown(PointerDownEvent details) {
    options = StrokeOptions(
      simulatePressure: details.kind != PointerDeviceKind.stylus,
    );

    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    late final Point point;
    if (details.kind == PointerDeviceKind.stylus) {
      point = Point(
        offset.dx,
        offset.dy,
        (details.pressure - details.pressureMin) /
            (details.pressureMax - details.pressureMin),
      );
    } else {
      point = Point(offset.dx, offset.dy);
    }
    final points = [point];
    line = Stroke(_drawSelectionColor, points);
    currentLineStreamController.add(line!);
  }

  void onPointerMove(PointerMoveEvent details) {
    final box = context.findRenderObject() as RenderBox;
    final offset = box.globalToLocal(details.position);
    late final Point point;
    if (details.kind == PointerDeviceKind.stylus) {
      point = Point(
        offset.dx,
        offset.dy,
        (details.pressure - details.pressureMin) /
            (details.pressureMax - details.pressureMin),
      );
    } else {
      point = Point(offset.dx, offset.dy);
    }
    final points = [...line!.points, point];
    line = Stroke(_drawSelectionColor, points);
    currentLineStreamController.add(line!);
  }

  void onPointerUp(PointerUpEvent details) {
    setState(() {
      lines = List.from(lines)..add(line!);
      linesStreamController.add(lines);
    });
  }

  // draw function with pencil
  Widget buildCurrentPath(BuildContext context) {
    return Listener(
      onPointerDown: onPointerDown,
      onPointerMove: onPointerMove,
      onPointerUp: onPointerUp,
      child: RepaintBoundary(
        child: Container(
            color: Colors.transparent,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<Stroke>(
                stream: currentLineStreamController.stream,
                builder: (context, snapshot) {
                  return CustomPaint(
                    painter: Sketcher(
                        lines: line == null ? [] : [line!],
                        options: options,
                        sketcherColor:
                            line != null ? line!.color : _drawSelectionColor),
                  );
                })),
      ),
    );
  }

  Widget buildAllPaths(BuildContext context) {
    return RepaintBoundary(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder<List<Stroke>>(
          stream: linesStreamController.stream,
          builder: (context, snapshot) {
            return CustomPaint(
              painter: Sketcher(
                  lines: lines,
                  options: options,
                  sketcherColor:
                      line != null ? line!.color : _drawSelectionColor),
            );
          },
        ),
      ),
    );
  }

  Widget buildToolbar() {
    final size = MediaQuery.of(context).size;
    return Container(
        margin: EdgeInsets.only(top: size.height * 0.6, right: 5.0),
        child: Container(
          color: white.withOpacity(0.2),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Kích cỡ',
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Slider(
                    value: options.size,
                    min: 1,
                    max: 50,
                    activeColor: white,
                    inactiveColor: white.withOpacity(0.1),
                    divisions: 100,
                    label: options.size.round().toString(),
                    onChanged: (double value) => {
                          setState(() {
                            options.size = value;
                          })
                        }),
                _buildColorSelections(function: (dynamic color) {
                  setState(() {
                    _drawSelectionColor = color;
                  });
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        const Text(
                          'Hoàn tác',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        buildClearUndoButton(FontAwesomeIcons.undo, () {
                          undo();
                        }),
                      ],
                    ),
                    buildSpacer(width: size.width * 0.5),
                    Column(
                      children: [
                        const Text(
                          'Hủy',
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                        buildClearUndoButton(FontAwesomeIcons.xmark, () {
                          clear();
                        }),
                      ],
                    ),
                  ],
                )
              ]),
        ));
  }

  Widget buildClearUndoButton(IconData iconData, Function function) {
    return GestureDetector(
      onTap: () {
        function();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: CircleAvatar(
            child: Icon(
          iconData,
          size: 20.0,
          // color: Colors.white,
        )),
      ),
    );
  }

  @override
  void initState() {
    if (widget.index != null) {
      _imageData = widget.imageData[widget.index];
    } else {
      _imageData = widget.imageData;
    }
    super.initState();
  }

  @override
  void dispose() {
    linesStreamController.close();
    currentLineStreamController.close();
    _musicSelection = null;
    _tagsSelection = null;
    _cropSelection = null;
    _emojiSelection = null;
    _wordSelection = null;
    _lineSelection = null;
    _animationSelection = null;
    _brightnessSelection = null;
    _saveSelection = null;
    _imageData = null;
    _overlayWidget = [];
    notifiers = [];
    // crop property
    cropImage = null;
    _cropImageUnit8List = null;
    // word property
    _dataProperties = [];
    // emoji property
    _emojiSelectionItems = [];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (rect == null) {
      Offset deletePoint = Offset(size.width / 2, size.height * 0.8);
      rect = Rect.fromCircle(center: deletePoint, radius: 50);
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: blackColor,
      body: SafeArea(
        child: Stack(children: [
          InkWell(
            onTap: () {
              hiddenKeyboard(context);
            },
            child: RepaintBoundary(
              key: _globalKey,
              child: Stack(
                children: [
                  Center(
                      key: ValueKey(
                          _cropImageUnit8List != null ? 'true' : 'false'),
                      child: Stack(
                        children: [
                          ColorFiltered(
                            colorFilter: ui.ColorFilter.matrix([
                              1, 0, 0, 0,
                              (brightness * 70) / 100, // Red color
                              0, 1, 0, 0,
                              (brightness * 70) / 100, // Green color
                              0, 0, 1, 0,
                              (brightness * 70) / 100, // Blue color
                              0, 0, 0, 1, 0, // Alpha color
                            ]),
                            child: _cropImageUnit8List != null
                                ? Image.memory(
                                    _cropImageUnit8List!,
                                    key: _imageKey,
                                    fit: BoxFit.fitWidth,
                                    width: size.width,
                                  )
                                : _imageData['file'] != null
                                    ? ExtendedImage.file(
                                        File(_imageData['file'].path),
                                        key: _imageKey,
                                        fit: BoxFit.fitWidth,
                                        width: size.width,
                                      )
                                    : const SizedBox(),
                          ),
                        ],
                      )),
                  _selectedFrame != null
                      ? Image.asset(_selectedFrame!,
                          fit: BoxFit.fitWidth, width: size.width)
                      : const SizedBox(),
                  // show drawing board
                  Stack(
                    children: [
                      buildAllPaths(context),
                      _lineSelection == true
                          ? buildCurrentPath(context)
                          : const SizedBox()
                    ],
                  ),
                  // show drag object
                  Stack(
                    children: _overlayWidget.map((e) {
                      final index = _overlayWidget.indexOf(e);
                      return e != null &&
                              notifiers[index].value != Matrix4.zero() &&
                              _dataProperties[index] != null
                          ? Listener(
                              onPointerMove: (event) {
                                if (rect!.contains(event.position)) {
                                  setState(() {
                                    _isCanDeleteObject = true;
                                  });
                                } else {
                                  if (_isCanDeleteObject == true) {
                                    setState(() {
                                      _isCanDeleteObject = false;
                                    });
                                  }
                                }
                              },
                              onPointerDown: (details) {
                                setState(() {
                                  _selectedOverlayObject =
                                      _dataProperties[index];
                                });
                              },
                              onPointerUp: (event) {
                                if (_isCanDeleteObject) {
                                  setState(() {
                                    _selectedOverlayObject = null;
                                    _overlayWidget[index] = null;
                                    notifiers[index] =
                                        ValueNotifier(Matrix4.zero());
                                    _dataProperties[index] = null;
                                    _isCanDeleteObject = false;
                                  });
                                }
                              },
                              child: MatrixGestureDetector(
                                onMatrixUpdate: (matrix, translationDeltaMatrix,
                                    scaleDeltaMatrix, rotationDeltaMatrix) {
                                  setState(() {
                                    notifiers[index].value = matrix;
                                  });
                                },
                                onScaleStart: () {
                                  setState(() {
                                    _isShowDeleteArea = true;
                                  });
                                },
                                onScaleEnd: () {
                                  setState(() {
                                    _isShowDeleteArea = false;
                                  });
                                },
                                child: AnimatedBuilder(
                                  animation: notifiers[index],
                                  builder: (context, child) {
                                    final matrix = notifiers[index].value;
                                    final rotationAngle = math.atan2(0, 0);
                                    return Transform(
                                      transform: matrix,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.contain,
                                          child: RotatedBox(
                                            quarterTurns:
                                                rotationAngle ~/ (math.pi / 2),
                                            // quarterTurns: 3,
                                            child: e['widget'],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : const SizedBox();
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          _lineSelection == true || _brightnessSelection == true
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(right: 20, left: 20, top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          buildTextContentButton("Xong", true,
                              colorWord: white, fontSize: 20, function: () {
                            resetSelectionMenu();
                          })
                        ],
                      ),
                    ),
                    _lineSelection == true
                        ? buildToolbar()
                        : _brightnessSelection == true
                            ? Column(
                                children: [
                                  buildTextContent("Độ sáng", true,
                                      fontSize: 17,
                                      colorWord: white,
                                      isCenterLeft: false),
                                  buildSpacer(height: 10),
                                  Slider(
                                    value: brightness,
                                    min: -100,
                                    max: 100,
                                    activeColor: white,
                                    inactiveColor: white.withOpacity(0.1),
                                    divisions: 100,
                                    label: brightness.round().toString(),
                                    onChanged: (value) {
                                      setState(() {
                                        brightness = value;
                                      });
                                    },
                                    semanticFormatterCallback: (value) =>
                                        value.round().toString(),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                  ],
                )
              : const SizedBox(),
          _isShowDeleteArea
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: EdgeInsets.only(bottom: size.height * 0.1),
                    height: _isCanDeleteObject ? 60 : 40,
                    width: _isCanDeleteObject ? 60 : 40,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: red.withOpacity(_isCanDeleteObject ? 0.7 : 0.5),
                        borderRadius: BorderRadius.circular(
                            _isCanDeleteObject ? 30 : 20)),
                    child: const Icon(FontAwesomeIcons.xmark),
                  ),
                )
              : const SizedBox(),
          //menu
          _lineSelection == true ||
                  _isShowDeleteArea ||
                  _brightnessSelection == true
              ? const SizedBox()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // menu top
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
                    // menu bottom
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          _animationSelection == true &&
                                  _isOpenAnimationSelections
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Container(
                                    color: blackColor.withOpacity(0.5),
                                    child: Row(
                                        children: selectionFrameList.map((e) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            _selectedFrame = e;
                                          });
                                        },
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                  color: white, width: 1.0)),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            child: e == null
                                                ? const Icon(
                                                    FontAwesomeIcons.cancel,
                                                    size: 30,
                                                    color: white,
                                                  )
                                                : Image.asset(
                                                    e,
                                                    fit: BoxFit.fill,
                                                  ),
                                          ),
                                        ),
                                      );
                                    }).toList()),
                                  ),
                                )
                              : const SizedBox(),
                          _selectedOverlayObject != null &&
                                  _selectedOverlayObject['key'] == "word"
                              ? Column(
                                  children: [
                                    _buildColorSelections(
                                        function: (dynamic color) {
                                      setState(() {
                                        _selectedOverlayObject['color'].value =
                                            color;
                                        int index = _dataProperties
                                            .indexOf(_selectedOverlayObject);
                                        _dataProperties[index]['color'].value =
                                            color;
                                      });
                                    }),
                                  ],
                                )
                              : const SizedBox(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                                  iconList.sublist(7, iconList.length).map((e) {
                                if (e['key'] == "complete") {
                                  return GestureDetector(
                                    onTap: () {
                                      chooseMenu(e['key'],
                                          index: iconList.indexOf(e));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius:
                                              BorderRadius.circular(25)),
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
                                      chooseMenu(e['key'],
                                          index: iconList.indexOf(e));
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          e['icon'],
                                          height: 20,
                                          width: 20,
                                          color: e['color'],
                                        ),
                                        buildTextContent(e['title'], false,
                                            fontSize: 14, colorWord: white)
                                      ],
                                    ));
                              }).toList()),
                        ],
                      ),
                    )
                  ],
                )
        ]),
      ),
    );
  }

  Widget _buildColorSelections({Function? function}) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
          children: drawColorList.map(
        (e) {
          return GestureDetector(
            onTap: () {
              function != null ? function(e) : null;
            },
            child: Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: e,
                borderRadius: BorderRadius.circular(10),
                // border: _drawSelectionColor == e
                //     ? Border.all(
                //         color: secondaryColor, width: 0.4)
                //     : null
              ),
              height: 20,
              width: 20,
            ),
          );
        },
      ).toList()),
    );
  }

  Widget _buildTextFormField(dynamic data) {
    return ValueListenableBuilder<double>(
        valueListenable: data['fontSize'],
        builder: (context, value, child) {
          return ValueListenableBuilder<Color>(
              valueListenable: data['color'],
              builder: (context, value, child) {
                return Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: TextFormField(
                    onChanged: (value) {},
                    maxLines: null,
                    enableInteractiveSelection:
                        false, // dissable magnifing glass
                    // selectionControls: CustomTextSelectionControls(),
                    focusNode: data["focus_node"],
                    controller: data['controller'],
                    autofocus: true,
                    style: TextStyle(
                        fontSize: data['fontSize'].value,
                        color: data['color'].value),
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 10, top: 10, right: 15),
                      border: InputBorder.none,
                      hintText: "Bắt đầu nhập",
                      hintStyle: TextStyle(
                          color: white,
                          fontWeight: FontWeight.w400,
                          fontSize: 30),
                    ),
                  ),
                );
              });
        });
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
                            title: Text("Music $index"),
                            onTap: () {
                              popToPreviousScreen(context);
                            },
                          );
                        })))
              ],
            ),
          );
        });
  }

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
                            child: SizedBox(
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
      _dataProperties.add({"key": "emoji", "id": emojis[index]['id']});
      _overlayWidget.add({
        "key": "emoji",
        'visible': true,
        "widget":
            ExtendedImage.network(emojis[index]['url'], height: 50, width: 50)
      });
      notifiers.add(ValueNotifier(Matrix4.identity()));
      _selectedOverlayObject = _dataProperties.last;
    });
    popToPreviousScreen(context);
  }
}
