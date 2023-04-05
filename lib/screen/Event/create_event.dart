import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/screen/Event/date_picker.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/CustomCropImage/crop_your_image.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final _imageDataList = <Uint8List>[];
  DateTime selectedDateTime = DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1, 0);
  DateTime selectedEndDate = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, DateTime.now().hour + 4, 0);
  Uint8List? _croppedImage;
  bool eventDateEnd = false;

  bool isCropping = false;

  Future<Uint8List> _load(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker()
        // ignore: deprecated_member_use
        .getImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      final imageData = await _load(File(pickedFile.path));

      final croppedImage = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CropImageScreen(image: imageData),
        ),
      );
      if (croppedImage != null && mounted) {
        setState(() {
          _croppedImage = croppedImage;
        });
      }
    }
  }

  _onPressDatePicker() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DatePickerCustom(
          isEndDate: eventDateEnd,
          selectedDateTime: selectedDateTime,
          selectedEndDate: selectedEndDate,
          onDateTimeChanged: (startDate, endDate, isDateTimeChanged) {
            if (isDateTimeChanged == true && mounted) {
              setState(() {
                selectedDateTime = startDate;
                if (endDate != null) {
                  selectedEndDate = endDate;
                  eventDateEnd = true;
                }
              });
            }
            if (endDate == null && mounted) {
              setState(() {
                eventDateEnd = false;
              });
            }
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = pv.Provider.of<ThemeManager>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.black12,
              child: Stack(
                children: [
                  if (_croppedImage != null)
                    SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width,
                        child: _croppedImage == null
                            ? const SizedBox.shrink()
                            : Image.memory(_croppedImage!)),
                  Positioned(
                    bottom: 8,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        _getImage();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.isDarkMode ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/Plus_2.png',
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              _croppedImage == null ? 'Thêm ảnh' : 'Chỉnh sửa',
                              style: TextStyle(
                                  color: theme.isDarkMode
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Tên sự kiện',
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      _onPressDatePicker();
                    },
                    child: TextFormField(
                      key: UniqueKey(),
                      readOnly: true,
                      enabled: false,
                      initialValue: DateFormat('MMM d, y, h:mm a')
                          .format(selectedDateTime),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Ngày và giờ bắt đầu',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  eventDateEnd
                      ? InkWell(
                          onTap: () {
                            _onPressDatePicker();
                          },
                          child: TextFormField(
                            key: UniqueKey(),
                            readOnly: true,
                            enabled: false,
                            initialValue: DateFormat('MMM d, y, h:mm a')
                                .format(selectedEndDate),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Ngày và giờ kết thúc',
                            ),
                          ),
                        )
                      : InkWell(
                          onTap: () {
                            _onPressDatePicker();
                            setState(() {
                              eventDateEnd = true;
                            });
                          },
                          child: Row(children: const [
                            Icon(FontAwesomeIcons.circlePlus, size: 14),
                            SizedBox(width: 8),
                            Text('Thêm ngày kết thúc'),
                          ]),
                        ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText:
                          'Đây là sự kiện gặp mặt trực tiếp hay trên mạng',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Ai có thể nhìn thấy sự kiện này?',
                    ),
                  ),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Có thông tin chi tiết gì?',
                      alignLabelWithHint: true,
                    ),
                    minLines: 3,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CropImageScreen extends StatefulWidget {
  final Uint8List? image;

  const CropImageScreen({
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final _cropController = CropController();
  late BuildContext _context;
  final _loadingImage = false;
  var _isCropping = false;
  Uint8List? _croppedData;
  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Visibility(
            visible: !_loadingImage && !_isCropping,
            replacement: const CircularProgressIndicator(),
            child: Column(
              children: [
                Expanded(
                  child: Visibility(
                    visible: _croppedData == null,
                    replacement: const Center(child: SizedBox.shrink()),
                    child: Stack(
                      children: [
                        if (widget.image != null) ...[
                          Crop(
                            controller: _cropController,
                            image: widget.image!,
                            onCropped: (croppedData) {
                              Navigator.pop(_context, croppedData);
                              setState(() {
                                _croppedData = croppedData;
                                _isCropping = false;
                              });
                            },
                            aspectRatio: 16 / 9,
                            withCircleUi: false,
                            initialSize: null,
                            cornerDotBuilder: (size, edgeAlignment) =>
                                const SizedBox.shrink(),
                            interactive: false,
                            fixArea: false,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (_croppedData == null)
                  Material(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isCropping = true;
                                });
                                _cropController.crop();
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text('CROP IT!'),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
