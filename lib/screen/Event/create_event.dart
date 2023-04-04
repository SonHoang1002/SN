import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/screen/Event/date_picker.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/CropImage/src/controllers/controller.dart';
import 'package:social_network_app_mobile/widget/CropImage/src/painters/solid_path_painter.dart';
import 'package:social_network_app_mobile/widget/CropImage/src/widgets/custom_image_crop_widget.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  File? _image;
  DateTime selectedDateTime = DateTime(DateTime.now().year,
      DateTime.now().month, DateTime.now().day, DateTime.now().hour + 1, 0);
  MemoryImage? _croppedImage;
  bool eventDateEnd = false;
  bool isCropping = false;
  Future<void> _getImage() async {
    final pickedFile = await ImagePicker()
        // ignore: deprecated_member_use
        .getImage(source: ImageSource.gallery, imageQuality: 100);
    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final croppedImage = await Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => CropImageScreen(image: imageFile),
        ),
      );
      if (croppedImage != null) {
        setState(() {
          _croppedImage = croppedImage;
        });
      } else {}
    }
  }

  _onPressDatePicker() async {
    final result = await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            DatePickerCustom(
          selectedDateTime: selectedDateTime,
          onDateTimeChanged: (newDateTime, isDateTimeChanged) {
            if (isDateTimeChanged == true) {
              setState(() {
                selectedDateTime = newDateTime;
              });
            } else {
              selectedDateTime = selectedDateTime;
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
                        child: Image.memory(
                          _croppedImage!.bytes,
                          fit: BoxFit.cover,
                        )),
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
                      ? const TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Ngày và giờ kết thúc',
                          ),
                        )
                      : InkWell(
                          onTap: () {
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
  final File? image;

  const CropImageScreen({
    required this.image,
    Key? key,
  }) : super(key: key);

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  late CustomImageCropController controller;
  late BuildContext _context;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CustomImageCrop(
              cropController: controller,
              shape: CustomCropShape.Square,
              canRotate: false,
              canMove: true,
              canScale: false,
              drawPath: SolidCropPathPainter.drawPath,
              image: FileImage(widget.image!),
            ),
          ),
          Row(
            children: [
              InkWell(
                onTap: _onCropImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.crop),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(_context).padding.bottom),
        ],
      ),
    );
  }

  void _onCropImage() {
    final image = controller.onCropImage();
    Navigator.pop(_context, image);
  }
}
