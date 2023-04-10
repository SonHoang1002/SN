import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart' as pv;
import 'package:social_network_app_mobile/apis/events_api.dart';
import 'package:social_network_app_mobile/screen/Event/CreateEvent/date_picker.dart';
import 'package:social_network_app_mobile/screen/Event/CreateEvent/event_publish.dart';
import 'package:social_network_app_mobile/screen/Event/event_detail.dart';
import 'package:social_network_app_mobile/theme/theme_manager.dart';
import 'package:social_network_app_mobile/widget/CustomCropImage/crop_your_image.dart';
import 'package:social_network_app_mobile/widget/button_primary.dart';

import '../../../widget/appbar_title.dart';
import '../../../widget/back_icon_appbar.dart';
import 'event_meeting.dart';

class CreateEvents extends ConsumerStatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  ConsumerState<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends ConsumerState<CreateEvents> {
  TextEditingController nameController = TextEditingController();
  TextEditingController detailController = TextEditingController();
  DateTime selectedDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      DateTime.now().minute >= 55
          ? DateTime.now().hour + 2
          : DateTime.now().hour + 1,
      0);
  DateTime? selectedEndDate;
  DateTime? endDateTime;
  Uint8List? _croppedImage;
  bool eventDateEnd = false;
  List checkin = [];
  File? files;
  String privateEvent = '';
  List checkinSelected = [];
  bool isCropping = false;
  bool formLoading = false;
  Future<Uint8List> _load(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return Uint8List.fromList(bytes);
  }

  void _updateCheckinSelected(List<dynamic> newSelected) {
    setState(() {
      checkinSelected = newSelected;
    });
  }

  File uint8ListToFile(Uint8List data, String fileName) {
    final buffer = data.buffer;
    File file = File(fileName);
    file.writeAsBytesSync(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return file;
  }

  Future<void> _getImage() {
    final pickedFileFuture = ImagePicker()
        // ignore: deprecated_member_use
        .getImage(source: ImageSource.gallery, imageQuality: 100);
    pickedFileFuture.then((pickedFile) {
      if (pickedFile != null) {
        final imageDataFuture = _load(File(pickedFile.path));
        imageDataFuture.then((imageData) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CropImageScreen(
                image: imageData,
                onChange: (value) {
                  if (mounted) {
                    setState(() {
                      files = uint8ListToFile(value, pickedFile.path);
                      isCropping = false;
                    });
                  }
                },
              ),
            ),
          ).then((loading) {
            if (mounted) {
              setState(() {
                isCropping = loading;
              });
            }
          });
        });
      }
    });
    return Future.value();
  }

  void createEvent() async {
    setState(() {
      formLoading = true;
    });
    FormData formData = FormData.fromMap({
      'title': nameController.text,
      'description': detailController.text,
      'visibility': privateEvent,
      'start_time': selectedDateTime.toString(),
      'end_time': endDateTime?.toString(),
      'event_type': 'offline',
      'id':
          checkinSelected.isNotEmpty ? checkinSelected[0]['id'].toString() : '',
      'address':
          checkinSelected.isNotEmpty ? checkinSelected[0]['address'] : '',
      'location[lat]': checkinSelected.isNotEmpty
          ? checkinSelected[0]['location']['lat'].toString()
          : null,
      'location[lng]': checkinSelected.isNotEmpty
          ? checkinSelected[0]['location']['lng'].toString()
          : null,
    });

    if (files != null) {
      formData.files.add(MapEntry(
        'banner[file]',
        await MultipartFile.fromFile(
          files!.path,
          filename: files!.path.split('/').last,
        ),
      ));
    }
    try {
      var response = await EventApi().createEventApi(formData);
      setState(() {
        formLoading = false;
      });
      if (context.mounted) {
        Navigator.push(
            context,
            CupertinoPageRoute(
                builder: (context) => EventDetail(
                      eventDetail: response,
                    )));
      }
    } catch (e) {
      print(e);
    }
  }

  void _updatePrivateEvent(String newSelected) {
    if (mounted) {
      setState(() {
        privateEvent = newSelected;
      });
    }
  }

  _onPressDatePicker() async {
    await Navigator.push(
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
                  endDateTime = endDate;
                  eventDateEnd = true;
                }
              });
            }
            if (endDate != null && mounted && isDateTimeChanged == false) {
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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              BackIconAppbar(),
            ],
          ),
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 200,
                      color: Colors.black12,
                      child: Stack(
                        children: [
                          if (files != null)
                            SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: files == null
                                    ? const SizedBox.shrink()
                                    : isCropping
                                        ? const Center(
                                            child: CupertinoActivityIndicator())
                                        : Image.file(files!)),
                          Positioned(
                            bottom: 8,
                            right: 12,
                            child: GestureDetector(
                              onTap: () {
                                _getImage();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: theme.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                child: Row(
                                  children: [
                                    Image.asset('assets/Plus_2.png',
                                        width: 18,
                                        height: 18,
                                        color: theme.isDarkMode
                                            ? Colors.white
                                            : Colors.black),
                                    const SizedBox(width: 8.0),
                                    Text(
                                      _croppedImage == null
                                          ? 'Thêm ảnh'
                                          : 'Chỉnh sửa',
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
                          TextFormField(
                            controller: nameController,
                            autofocus: false,
                            decoration: const InputDecoration(
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
                              autofocus: false,
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
                                    autofocus: false,
                                    enabled: false,
                                    initialValue: DateFormat('MMM d, y, h:mm a')
                                        .format(selectedEndDate!),
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
                                      selectedEndDate = DateTime(
                                          selectedDateTime.year,
                                          selectedDateTime.month,
                                          selectedDateTime.day,
                                          selectedDateTime.hour + 3,
                                          0);
                                    });
                                  },
                                  child: Row(children: const [
                                    Icon(FontAwesomeIcons.circlePlus, size: 14),
                                    SizedBox(width: 8),
                                    Text('Thêm ngày kết thúc'),
                                  ]),
                                ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16))),
                                  context: context,
                                  builder: (context) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.8,
                                      child: MeetingEvent(
                                          checkinSelected: checkinSelected,
                                          onCheckinSelectedChanged:
                                              _updateCheckinSelected)));
                            },
                            child: TextFormField(
                              key: UniqueKey(),
                              readOnly: true,
                              enabled: false,
                              initialValue: checkinSelected.isNotEmpty
                                  ? '${checkinSelected[0]['title']}'
                                  : '',
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: !checkinSelected.isNotEmpty
                                    ? 'Đây là sự kiện gặp mặt trực tiếp hay trên mạng'
                                    : 'Trực tiếp',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  isScrollControlled: true,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16))),
                                  context: context,
                                  builder: (context) => SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      child: EventPublish(
                                        privateEventOnChanged:
                                            _updatePrivateEvent,
                                      )));
                            },
                            child: TextFormField(
                              key: UniqueKey(),
                              readOnly: true,
                              enabled: false,
                              initialValue: privateEvent != ''
                                  ? privateEvent == 'private'
                                      ? 'Riêng tư'
                                      : privateEvent == 'public'
                                          ? 'Công khai'
                                          : 'Bạn bè'
                                  : '',
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Ai có thể nhìn thấy sự kiện này?',
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: detailController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Có thông tin chi tiết gì?',
                              alignLabelWithHint: true,
                            ),
                            minLines: 3,
                            maxLines: null,
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize:
                                    Size(MediaQuery.of(context).size.width, 45),
                                foregroundColor: Colors.white, // foreground
                              ),
                              onPressed: createEvent,
                              child: const Text('Tạo sự kiện'))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (formLoading)
              Container(
                color: Colors.transparent,
                child: const Center(
                  child: CupertinoActivityIndicator(),
                ),
              )
          ],
        ),
      ),
    );
  }
}

class CropImageScreen extends StatefulWidget {
  final Function(Uint8List)? onChange;
  final Uint8List? image;

  const CropImageScreen({
    required this.image,
    this.onChange,
    Key? key,
  }) : super(key: key);

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  final _cropController = CropController();
  final _loadingImage = false;
  bool _isCropping = false;
  Uint8List? _croppedData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const BackIconAppbar(),
            const AppBarTitle(title: ""),
            ButtonPrimary(
              label: "Xong",
              handlePress: () {
                Navigator.pop(context, _isCropping = true);
                _cropController.crop();
              },
            )
          ],
        ),
      ),
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
                              if (widget.onChange != null) {
                                widget.onChange!(croppedData);
                              }
                            },
                            aspectRatio: 16 / 9,
                            withCircleUi: false,
                            initialSize: 1,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
